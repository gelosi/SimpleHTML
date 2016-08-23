//
//  OSSimpleHTML.h
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "OSSimpleHTMLStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSSimpleHTML : NSObject

@property (nonatomic, readonly) OSSimpleHTMLStyle *basicStyle;
@property (nonatomic, readonly) OSSimpleHTMLStyle *unsupportedStyle;

@property (nonatomic, readonly) NSMutableDictionary<NSString *, OSSimpleHTMLStyle *> *styles;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithBasicTextAttributes:(NSDictionary<NSString *, NSString *> *)basicTextAttributes;
- (instancetype)initWithBasicStyle:(OSSimpleHTMLStyle *)basicStyle NS_DESIGNATED_INITIALIZER;

- (NSString *)stringFromHTML:(NSString *)html;
- (NSAttributedString *)attributedStringFromHTML:(NSString *)html;

@end

NS_ASSUME_NONNULL_END