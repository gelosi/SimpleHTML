//
//  OSSimpleHTMLStyleCollection.h
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "OSSimpleHTMLStyle.h"
#import "OSSimpleHTMLStyleAncor.h"
#import "OSSimpleHTMLStyleLineBreak.h"

@interface OSSimpleHTMLStyleCollection : NSObject
+ (NSArray<OSSimpleHTMLStyle *> *)styles;
@end
