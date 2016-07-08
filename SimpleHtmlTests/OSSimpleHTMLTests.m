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


@end
