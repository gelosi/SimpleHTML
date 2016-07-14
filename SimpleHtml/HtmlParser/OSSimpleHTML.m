//
//  OSSimpleHTML.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHTML.h"
#import "OSSimpleHTMLStyleCollection.h"
#import "OSSimpleHtmlOutput.h"

@interface OSSimpleHTML () <NSXMLParserDelegate>

@property (nonatomic) NSMutableArray *styleStack;
@property (nonatomic) id<OSSimpleHTMLOutput> output;

@end

@implementation OSSimpleHTML

- (instancetype)initWithBasicStyle:(OSSimpleHTMLStyle *)basicStyle
{
    self = [super init];

    if (self) {
        if (!basicStyle.attributes[NSFontAttributeName]) {
            NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:basicStyle.attributes];
            textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:[UIFont systemFontSize]];

            basicStyle = [OSSimpleHTMLStyle styleWithTag:basicStyle.tag attributes:textAttributes];
        }

        _basicStyle = basicStyle;
        _unsupportedStyle = [OSSimpleHTMLStyle styleWithTag:@"unsupported" attributes:@{}];

        _styles = [NSMutableDictionary new];

        self.styles[self.basicStyle.tag] = self.basicStyle;

        [[OSSimpleHTMLStyleCollection styles] enumerateObjectsUsingBlock:^(OSSimpleHTMLStyle *style, NSUInteger idx, BOOL *stop) {
            self.styles[style.tag] = style;
        }];
    }

    return self;
}

- (instancetype)initWithBasicTextAttributes:(NSDictionary<NSString *,NSString *> *)basicTextAttributes
{
    return [self initWithBasicStyle:[OSSimpleHTMLStyle styleWithTag:@"text" attributes:basicTextAttributes]];
}

- (NSString *)stringFromHTML:(NSString *)html
{
    self.output = [OSSimpleHTMLOutputString new];

    NSXMLParser *parser = [self createParserForString:html];

    [self startParsingWithParser:parser];

    return self.output.string;
}

- (NSAttributedString *)attributedStringFromHTML:(NSString *)html
{
    self.output = [OSSimpleHTMLOutputAttributedString new];

    NSXMLParser *parser = [self createParserForString:html];

    [self startParsingWithParser:parser];

    return self.output.string;
}

#pragma mark - pre-parse stuff

- (NSXMLParser *)createParserForString:(NSString *)string
{
    NSParameterAssert(string != nil);

    NSArray *components = @[
                            @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
                            @"<", self.basicStyle.tag, @">",
                            string,
                            @"</", self.basicStyle.tag, @">"
                            ];

    NSString *xmlString = [components componentsJoinedByString:@""];

    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    return parser;
}

- (OSSimpleHTMLStyle *)computeStyleStack:(NSArray *)styleStack
{
    __block OSSimpleHTMLStyle *computedStyle = self.basicStyle;

    [styleStack enumerateObjectsUsingBlock:^(OSSimpleHTMLStyle *dynamicStyle, NSUInteger idx, BOOL *stop) {
        computedStyle = [computedStyle styleByApplyingStyle:dynamicStyle];
    }];

    if (computedStyle.attributes[UIFontSymbolicTrait]) {
        UIFont *font = (UIFont *) computedStyle.attributes[NSFontAttributeName];
        NSNumber *computedTraits = (NSNumber *) computedStyle.attributes[UIFontSymbolicTrait];
        UIFontDescriptor *newFont = [font.fontDescriptor fontDescriptorWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)computedTraits.unsignedIntegerValue];
        font = [UIFont fontWithDescriptor:newFont size:font.pointSize];
        NSMutableDictionary *newAttributes = [NSMutableDictionary dictionaryWithDictionary:computedStyle.attributes];
        newAttributes[NSFontAttributeName] = font;
        [newAttributes removeObjectForKey:UIFontSymbolicTrait];
        NSString* styleTag = [NSString stringWithFormat:@"%@:traits", computedStyle.tag];
        computedStyle = [OSSimpleHTMLStyle styleWithTag:styleTag attributes:newAttributes];
    }

    return computedStyle;
}

- (void)startParsingWithParser:(NSXMLParser *)parser
{
    self.styleStack = [NSMutableArray new];

    if(![parser parse]) {
        NSError *parserError = [parser parserError];

        NSLog(@"Parser error: %@", parserError);
    };
}

- (void)appendOutputString:(NSString *)string withStyleStack:(NSArray *)styleStack
{
    if (self.output.isAttributedString) {
        OSSimpleHTMLStyle *computedStyle = [self computeStyleStack:self.styleStack];

        NSAttributedString *chunk = [[NSAttributedString alloc] initWithString:string
                                                                    attributes:computedStyle.attributes];

        NSLog(@"ComputedStyle: %@ for text: '%@'", computedStyle.tag, string);

        [self.output appendString:chunk];
    } else {
        [self.output appendString:string];
    }
}

- (BOOL)styleStackAllowsToAddText
{
    __block BOOL allowsToAdd = YES;
    [self.styleStack enumerateObjectsUsingBlock:^(OSSimpleHTMLStyle *style, NSUInteger idx, BOOL *stop) {
        if ([style.tag isEqualToString: self.unsupportedStyle.tag]) {
            allowsToAdd = NO;
            *stop = YES;
        }
    }];

    return allowsToAdd;
}

#pragma mark - NSXMLParserDelegate stuff

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{
    OSSimpleHTMLStyle *style  = self.styles[elementName];

    if (style) {
        OSSimpleHTMLStyle *dynamicStyle = [style styleByApplyingHTMLAttributes:attributeDict];
        [self.styleStack addObject:dynamicStyle];
    } else {
        [self.styleStack addObject:self.unsupportedStyle];
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [self.styleStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self styleStackAllowsToAddText]) {
        [self appendOutputString:string withStyleStack:self.styleStack];
    }
}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
    NSLog(@"Parser error (delegate): %@", parseError);
}

@end
