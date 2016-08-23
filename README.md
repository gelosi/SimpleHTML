# SimpleHTML

Very primitive HTML parser _oh yeah, one more!_

## Why?

I want to parse a lot of small html-like chunks to a `NSAttributedString` in background. So, I can do something like Android guys doing with _android.text.Html_ and then we can do primitive formatted text on the backend...

But **I hate to do it with build-in main-thread-only parser from UIKit**:

```objective-c
    [[NSAttributedString alloc] initWithData:[html dataUsingEncoding: NSUTF8StringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                               NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding),
                                               NSDefaultAttributesDocumentAttribute:@{
                                                        NSFontAttributeName : [UIFont systemFontOfSize:SystemFontSize]
                                                        }}
                          documentAttributes: nil
                                       error: &error];
```
When I need only that:

`<b>Bold:</b> important <i>italic</i> message`

**Bold:** important _italic_ message

## Ok, what I can do with it?

Well, not much, as it is designed to be small, fast, one thing

### Tags currently supported:

`<b>`
`<i>`
`<a>`
`<br>` - very nasty way, though

### Some well-known symbols:

`&amp;`  - makes `&`

`&nbsp;` - replaced by simple space

## How does it look like to parse?

```objective-c
    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];
    NSAttributedString *labelText = [htmlParser attributedStringFromHTML:@"<b>Bold:</b> important <i>italic</i> message"];
```

## I want to make my text red color xxx font by default:

```objective-c
UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
UIFont *font = [UIFont fontWithDescriptor:descriptor size:descriptor.pointSize];

OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{
                                                                               NSForegroundColorAttributeName : [UIColor redColor],
                                                                               NSFontAttributeName : font
                                                                               }];
```


## Is it thread-safe?
 - Not yet. But you can send a MR =^^=

