//
//  OSSimpleHTMLStyleCollection.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

@import UIKit;

#import "OSSimpleHTMLStyleCollection.h"

@implementation OSSimpleHTMLStyleCollection
+ (NSArray<OSSimpleHTMLStyle *> *)styles
{
    return @[
             [OSSimpleHTMLStyle styleWithTag:@"b" attributes:@{UIFontSymbolicTrait:@(UIFontDescriptorTraitBold)}],
             [OSSimpleHTMLStyle styleWithTag:@"i" attributes:@{UIFontSymbolicTrait:@(UIFontDescriptorTraitItalic)}],
             [OSSimpleHTMLStyle styleWithTag:@"u" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}],
             [OSSimpleHTMLStyleAncor styleWithTag:@"a" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}],
             [OSSimpleHTMLStyleLineBreak style],
             ];
}
@end
