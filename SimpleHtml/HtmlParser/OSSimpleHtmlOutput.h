//
//  OSSimpleHtmlOutput.h
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 14/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol OSSimpleHTMLOutput <NSObject>

@property (nonatomic, readonly) id string;

- (void)appendString:(id)string;
- (BOOL)isAttributedString;

@end

@interface OSSimpleHTMLOutputString: NSObject<OSSimpleHTMLOutput>
@property (nonatomic, readonly) NSString *string;
@end

@interface OSSimpleHTMLOutputAttributedString: NSObject<OSSimpleHTMLOutput>
@property (nonatomic, readonly) NSAttributedString *string;
@end

NS_ASSUME_NONNULL_END