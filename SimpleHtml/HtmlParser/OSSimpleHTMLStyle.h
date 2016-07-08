//
//  OSSimpleHTMLStyle.h
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface OSSimpleHTMLStyle : NSObject

@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *attributes;

+ (instancetype) styleWithTag:(NSString *)tag attributes:(NSDictionary<NSString *, NSString *> *)attributes;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithTag:(NSString *)tag attributes:(NSDictionary<NSString *, NSString *> *)attributes;

- (instancetype) styleByApplyingStyle:(OSSimpleHTMLStyle *)style;
- (instancetype) styleByApplyingHTMLAttributes:(nullable NSDictionary<NSString *, NSString *> *)htmlAttributes;
@end

NS_ASSUME_NONNULL_END