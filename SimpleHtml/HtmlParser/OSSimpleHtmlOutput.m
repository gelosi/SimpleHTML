//
//  OSSimpleHtmlOutput.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 14/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHtmlOutput.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OSSimpleHTMLOutputString

- (instancetype)init
{
    self = [super init];

    if (self) {
        _string = [NSMutableString new];
    }

    return self;
}

- (BOOL)isAttributedString
{
    return NO;
}

- (void)appendString:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"OSSimpleHtmlOutputString is able to append NSString objects only" userInfo:nil];
    }

    NSMutableString *mutableString = (NSMutableString *)self.string;

    [mutableString appendString:string];
}

@end

@implementation OSSimpleHTMLOutputAttributedString

- (instancetype)init
{
    self = [super init];

    if (self) {
        _string = [NSMutableAttributedString new];
    }

    return self;
}

- (BOOL)isAttributedString
{
    return YES;
}

- (void)appendString:(NSAttributedString *)string
{
    if (![string isKindOfClass:[NSAttributedString class]]) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException reason:@"OSSimpleHtmlOutputAttributedString is able to append NSAttributedString objects only" userInfo:nil];
    }
    NSMutableAttributedString *mutableAttributedString = (NSMutableAttributedString *)self.string;

    [mutableAttributedString appendAttributedString:string];
}

@end

NS_ASSUME_NONNULL_END