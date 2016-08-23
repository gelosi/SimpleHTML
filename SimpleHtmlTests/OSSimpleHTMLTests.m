//
//  OSSimpleHTMLTests.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSSimpleHTML.h"

@interface OSSimpleHTMLTests : XCTestCase

@end

@implementation OSSimpleHTMLTests


- (void)testSimpleStringParsing
{
    NSString *html = @"Test";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSString *res = [htmlParser stringFromHTML:html];

    XCTAssertEqualObjects(res, html);
}

- (void)testLineBreak
{
    NSString *html = @"Test<br>Best";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSString *res = [htmlParser stringFromHTML:html];

    XCTAssertEqualObjects(res, @"Test\nBest");
}

- (void)testBoldStringParsing
{
    NSString *html = @"<b>Test</b>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSString *res = [htmlParser stringFromHTML:html];

    XCTAssertEqualObjects(res, @"Test");
}

- (void)testBoldStringParsingWithSpace
{
    NSString *html = @"<b>Test</b> ";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSString *res = [htmlParser stringFromHTML:html];

    XCTAssertEqualObjects(res, @"Test ");
}

- (void)testBoldItalicStringParsing
{
    NSString *html = @"<b>bold</b> <i>italic</i>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSString *res = [htmlParser stringFromHTML:html];

    XCTAssertEqualObjects(res, @"bold italic");
}

- (void)testBoldStringParsing_Attributed
{
    NSString *html = @"<b>Test</b>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSAttributedString *res = [htmlParser attributedStringFromHTML:html];

    XCTAssertEqualObjects(res.string, @"Test");

    NSDictionary *attributes = [res attributesAtIndex:0 effectiveRange:nil];

    XCTAssertNotNil(attributes);

    UIFont *font = attributes[NSFontAttributeName];
    XCTAssertTrue([font isKindOfClass:[UIFont class]]);
    XCTAssertTrue(font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold);
}

- (void)testAncorStringParsing_Attributed
{
    NSString *html = @"<a href=\"http://test.com\">Test</a>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSAttributedString *res = [htmlParser attributedStringFromHTML:html];

    XCTAssertEqualObjects(res.string, @"Test");

    NSDictionary *attributes = [res attributesAtIndex:0 effectiveRange:nil];

    XCTAssertNotNil(attributes);

    NSURL *link = attributes[NSLinkAttributeName];
    XCTAssertTrue([link isKindOfClass:[NSURL class]]);
}

- (void)testBoldItalicStringParsing_Attributed
{
    NSString *html = @"<i><b>Test</b></i>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSAttributedString *res = [htmlParser attributedStringFromHTML:html];

    XCTAssertEqualObjects(res.string, @"Test");

    NSDictionary *attributes = [res attributesAtIndex:0 effectiveRange:nil];

    XCTAssertNotNil(attributes);

    UIFont *font = attributes[NSFontAttributeName];
    XCTAssertTrue([font isKindOfClass:[UIFont class]]);
    XCTAssertTrue(font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold);
    XCTAssertTrue(font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic);
}

- (void)testPerfomanceAttributedString
{
    NSString *html = @"<b>Test</b> +49157519<b>4</b>95 <i>slide</i> <i><a href=\"http://obrij.com\"> click <b>to</b> visit <b>obrij</b>.com</a></i><b>booooooool</b>";

    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    [self measureBlock:^{
        id str = [htmlParser attributedStringFromHTML:html];
        XCTAssert(str);
    }];
}

- (void)testPerfomanceAttributedStringUIKit
{
    NSString *html = @"<b>Test</b> +49157519<b>4</b>95 <i>slide</i> <i><a href=\"http://obrij.com\"> click <b>to</b> visit <b>obrij</b>.com</a></i><b>booooooool</b>";

    NSString *head = @"<!DOCTYPE html>"
    "<style type=\"text/css\">"
    "body{"
    "   font-family: HelveticaNeue, Helvetica;"
    "   font-size: 15pt;"
    "   color:#000;"
    "   background:#fff;"
    "   "
    "}"
    "a {"
    "   color: #aaa"
    "   text-decoration: underline;"
    "}"
    "</style>"

    "<html>"
    "<head>"
    "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\" />"
    "</head>"
    "<body>";

    NSArray *components = @[head,
                            html,
                            @"</body></html>"];

    NSString *stringWithHtmlHead = [components componentsJoinedByString:@""];

    [self measureBlock:^{

        NSError *error;

        id str = [[NSAttributedString alloc] initWithData: [stringWithHtmlHead dataUsingEncoding: NSUTF8StringEncoding]
                                                  options: @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                             NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding),
                                                             NSDefaultAttributesDocumentAttribute:@{
                                                                     NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                                     }}
                                       documentAttributes: nil
                                                    error: &error];
        XCTAssert(str);
    }];
}


@end
