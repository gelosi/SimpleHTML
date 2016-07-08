//
//  OSSimpleHTMLStyle.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHTMLStyle.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OSSimpleHTMLStyle

+ (instancetype)styleWithTag:(NSString *)tag attributes:(NSDictionary<NSString *,NSString *> *)attributes
{
    return [[[self class] alloc] initWithTag:tag attributes:attributes];
}

- (instancetype)initWithTag:(NSString *)tag attributes:(NSDictionary<NSString *,NSString *> *)attributes
{
    self = [super init];

    if (self) {
        _attributes = [attributes copy];
        _tag = [tag copy];
    }

    return self;
}

- (instancetype) styleByApplyingStyle:(OSSimpleHTMLStyle *)style
{
    NSString *compositeStyleName = [NSString stringWithFormat:@"%@.%@",self.tag, style.tag];
    NSMutableDictionary *compositeAttributes = [NSMutableDictionary dictionaryWithDictionary:self.attributes];

    NSNumber* traitsCurrent = (NSNumber *) self.attributes[UIFontSymbolicTrait];
    NSNumber* traitsNew = (NSNumber *) style.attributes[UIFontSymbolicTrait];

    [compositeAttributes addEntriesFromDictionary:style.attributes];

    if (traitsCurrent || traitsNew) {
        compositeAttributes[UIFontSymbolicTrait] = @(traitsCurrent.unsignedIntegerValue | traitsNew.unsignedShortValue);
    }

    return [[self class] styleWithTag:compositeStyleName attributes:compositeAttributes];
}

- (instancetype) styleByApplyingHTMLAttributes:(nullable NSDictionary<NSString *,NSString *> *)_
{
    return self;
}

@end

NS_ASSUME_NONNULL_END