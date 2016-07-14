//
//  ViewController.m
//  SimpleHtml
//
//  Created by Oleg Shanyuk on 08/07/16.
//  Copyright © 2016 AvocadoVentures. All rights reserved.
//

#import "ViewController.h"
#import "OSSimpleHTML.h"

@interface ViewController () <UITextViewDelegate>
@property (nonatomic) IBOutlet UITextView *textPreview;
@property (nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self toHtml:nil];
}

- (IBAction)toHtml:(UIButton *)sender
{
    OSSimpleHTML *htmlParser = [[OSSimpleHTML alloc] initWithBasicTextAttributes:@{}];

    NSAttributedString *labelText = [htmlParser attributedStringFromHTML:self.textView.text];

    if (!labelText) {
        labelText = [[NSAttributedString alloc] initWithString:@"[parse error]" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    }

    self.textPreview.attributedText = labelText;

    [self.textView resignFirstResponder];
}


@end
