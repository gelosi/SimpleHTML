//
//  OSSimpleHTMLStyleAncor.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

@import UIKit;

#import "OSSimpleHTMLStyleAncor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OSSimpleHTMLStyleAncor

- (instancetype)styleByApplyingHTMLAttributes:(nullable NSDictionary<NSString *,NSString *> *)htmlAttributes
{
    NSString *href = htmlAttributes[@"href"];

    if (href) {
        NSURL *url = [NSURL URLWithString:href];

        if (url) {
            NSString *tag = [NSString stringWithFormat:@"%@(href_hash:%@)", self.tag, @(url.absoluteString.hash)];

            NSMutableDictionary *compositeAttributes = [NSMutableDictionary dictionaryWithDictionary:self.attributes];
            [compositeAttributes addEntriesFromDictionary:@{NSLinkAttributeName:url}];

            return [[self class] styleWithTag:tag attributes:compositeAttributes];

        }
    }

    return [super styleByApplyingHTMLAttributes:htmlAttributes];
}

@end

NS_ASSUME_NONNULL_END
