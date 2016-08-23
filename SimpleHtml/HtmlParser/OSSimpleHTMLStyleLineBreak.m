//
//  OSSimpleHTMLStyleLineBreak.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 23/08/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHTMLStyleLineBreak.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OSSimpleHTMLStyleLineBreak

+ (instancetype)style
{
    return [[self alloc] initWithTag:@"br" attributes:@{}];
}

- (instancetype)initWithTag:(NSString *)tag attributes:(NSDictionary<NSString *, NSString *> *)attributes
{
    self = [super initWithTag:tag attributes:attributes];

    if (self) {
        self.suffixString = @"\n";
    }

    return self;
}

@end

NS_ASSUME_NONNULL_END
