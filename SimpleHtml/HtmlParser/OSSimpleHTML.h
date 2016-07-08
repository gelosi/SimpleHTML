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

@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *basicTextAttributes;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, OSSimpleHTMLStyle *> *styles;

- (instancetype)initWithBasicTextAttributes:(NSDictionary<NSString *, NSString *> *)basicTextAttributes;

- (NSString *)stringFromHTML:(NSString *)html;
- (NSAttributedString *)attributedStringFromHTML:(NSString *)html;

@end

NS_ASSUME_NONNULL_END