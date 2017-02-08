//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesCollectionViewCellOutgoing.h"

@implementation JSQMessagesCollectionViewCellOutgoing

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentRight;
    self.cellBottomLabel.textAlignment = NSTextAlignmentRight;
    
    
    unsigned rgbValue = 0;
    NSScanner *scanner1 = [NSScanner scannerWithString:@"#D6A23F"];
    [scanner1 setScanLocation:1]; // bypass '#' character
    [scanner1 scanHexInt:&rgbValue];
    UIColor *color1 = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    rgbValue = 0;
    NSScanner *scanner2 = [NSScanner scannerWithString:@"#F5E5B9"];
    [scanner2 setScanLocation:1]; // bypass '#' character
    [scanner2 scanHexInt:&rgbValue];
    UIColor *color2 = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    rgbValue = 0;
    NSScanner *scanner3 = [NSScanner scannerWithString:@"#F0D57A"];
    [scanner3 setScanLocation:1]; // bypass '#' character
    [scanner3 scanHexInt:&rgbValue];
    UIColor *color3 = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    
    
    NSLog(@"%f",self.textView.bounds.size.width);
    
    gradientMask.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    gradientMask.colors = @[(id)color1.CGColor,
                            (id)color2.CGColor,
                            (id)color3.CGColor];
    gradientMask.locations = @[@0.0, @0.7, @1.0];
    gradientMask.startPoint = CGPointMake(0.0, 0.5);   // start at left middle
    gradientMask.endPoint = CGPointMake(1.0, 0.5);     // end at right middle
    [self.messageBubbleImageView.layer addSublayer:gradientMask];
    self.messageBubbleImageView.layer.cornerRadius = 17.0;
//    self.messageBubbleImageView.layer.masksToBounds = YES;
    self.messageBubbleImageView.clipsToBounds = YES;

}

@end
