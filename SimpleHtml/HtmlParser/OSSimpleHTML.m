//
//  OSSimpleHTML.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHTML.h"
#import "OSSimpleHTMLStyleCollection.h"

@interface OSSimpleHTML () <NSXMLParserDelegate>

@property (nonatomic) NSMutableArray *styleStack;
@property (nonatomic) BOOL currentStringAppendAllowed;

@property (nonatomic) id output;
@property (nonatomic) BOOL isAttributedOutput;



//@property (nonatomic) NSDictionary *boldAttributes;
//@property (nonatomic) NSDictionary *italicAttributes;
//@property (nonatomic) NSDictionary *linkAttributes;

//@property (nonatomic) NSDictionary *styleMap;

@end

@implementation OSSimpleHTML

- (instancetype)initWithBasicTextAttributes:(NSDictionary<NSString *,NSString *> *)basicTextAttributes
{
    self = [super init];

    if (self) {
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionaryWithDictionary:basicTextAttributes];
        if (!textAttributes[NSFontAttributeName]) {
            textAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }

        _basicTextAttributes = [NSDictionary dictionaryWithDictionary:textAttributes];
        _styles = [NSMutableDictionary new];


        self.styles[@"text"] = [OSSimpleHTMLStyle styleWithTag:@"text" attributes:self.basicTextAttributes];

        [[OSSimpleHTMLStyleCollection styles] enumerateObjectsUsingBlock:^(OSSimpleHTMLStyle *style, NSUInteger idx, BOOL *stop) {
            self.styles[style.tag] = style;
        }];
    }

    return self;
}

- (NSString *)stringFromHTML:(NSString *)html
{
    self.output = [NSMutableString new];
    self.isAttributedOutput = NO;

    NSXMLParser *parser = [self createParserForString:html];

    [self startParsingWithParser:parser];

    return self.output;
}

- (NSAttributedString *)attributedStringFromHTML:(NSString *)html
{
    self.output = [NSMutableAttributedString new];
    self.isAttributedOutput = YES;

    NSXMLParser *parser = [self createParserForString:html];

    [self startParsingWithParser:parser];

    return self.output;
}

#pragma mark - pre-parse stuff

- (NSXMLParser *)createParserForString:(NSString *)string
{
    string = [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><text>" stringByAppendingString:string];
    string = [string stringByAppendingString:@"</text>"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    return parser;
}

- (void)startParsingWithParser:(NSXMLParser *)parser
{
    self.styleStack = [NSMutableArray new];
    self.currentStringAppendAllowed = YES;

    if(![parser parse]) {
        NSError *parserError = [parser parserError];

        NSLog(@"Parser error: %@", parserError);
    };
}

- (void)appendOutputString:(NSString *)string withStyleStack:(NSArray *)styleStack
{
    if (self.isAttributedOutput) {
        NSMutableAttributedString *output = self.output;


        __block OSSimpleHTMLStyle *computedStyle = self.styles[@"text"];

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
            NSString* styleTag = [NSString stringWithFormat:@"%@(:traits)", computedStyle.tag];
            computedStyle = [OSSimpleHTMLStyle styleWithTag:styleTag attributes:newAttributes];
        }

        NSAttributedString *chunk = [[NSAttributedString alloc] initWithString:string attributes:computedStyle.attributes];

        NSLog(@"ComputedStyle: %@ for text: '%@'", computedStyle.tag, string);

        [output appendAttributedString:chunk];
    } else {
        NSMutableString *output = self.output;
        [output appendString:string];
    }
}

- (BOOL)styleStackAllowsToAddText
{
    __block BOOL allowsToAdd = YES;
    [self.styleStack enumerateObjectsUsingBlock:^(OSSimpleHTMLStyle *style, NSUInteger idx, BOOL *stop) {
        if ([style.tag isEqualToString: @"unsupported"]) {
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
        [self.styleStack addObject:[OSSimpleHTMLStyle styleWithTag:@"unsupported" attributes:@{}]];
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
