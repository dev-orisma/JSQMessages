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

#import "JSQMultiMediaItem.h"
#import "JSQAudioMediaItem.h"
#import "JSQPhotoMediaItem.h"
#import "JSQVideoMediaItem.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessage.h" 
#import <MobileCoreServices/UTCoreTypes.h>

@interface JSQMultiMediaItem ()

@property (strong, nonatomic) UIView *cachedMultiView;
@property (strong, nonatomic) UIImageView *cachedImagePreview;

@end


@implementation JSQMultiMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        image = [image copy];
        _cachedMultiView = nil;
    }
    return self;
}



- (instancetype)initWithData:(NSMutableArray *)data
{
    self = [super init];
    if (self) {
        _data = [data copy];
        _cachedMultiView = nil;
    }
    NSLog(@"%@",@"initWithData");
    _cachedMultiView = nil;
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
//    _cachedMultiView = nil;
    
    NSLog(@"%@",@"clearCachedMediaViews");
    
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    NSLog(@"%@",@"setImage");
    _image = [image copy];
    _cachedMultiView = nil;
}

- (void)setData:(NSMutableArray *)data
{
    NSLog(@"%@",@"setData");
    _data = [data copy];
    _cachedMultiView = nil;
}
- (void)setTextView:(UITextView *)textView
{
    [textView  setFont:[UIFont systemFontOfSize:18]];
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.textColor = [UIColor whiteColor];
    _textView = textView;
}


- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    
    NSLog(@"%@",@"setAppliesMediaViewMaskAsOutgoing");
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedMultiView = nil;
}

#pragma mark - JSQMessageMediaData protocol


- (UIView *)mediaView
{
    if (self.data == nil) {
        return nil;
    }
    NSInteger maxWidth = 250;
    if (self.cachedMultiView == nil) {
        
        NSInteger viewcount= self.data.count;
        
        CGFloat item_y = 0;
        CGFloat resViewHeight = 0;
        
        UIView *resView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,maxWidth, resViewHeight)];
        
        resView.backgroundColor = [UIColor clearColor];
        
        
        for (int i = 0; i < viewcount; i++)
        {
            if([[self.data objectAtIndex:i] isKindOfClass:[JSQPhotoMediaItem class]]){
                JSQPhotoMediaItem *jsqphoto = [self.data objectAtIndex:i];
                UIImageView *imageView = jsqphoto.mediaView;
                CGFloat posAudioX = 0.0;
                if ( self.appliesMediaViewMaskAsOutgoing ) {
                    posAudioX = maxWidth - imageView.frame.size.width;
                }
                
                imageView.frame = CGRectMake(posAudioX, item_y,imageView.frame.size.width - 5, imageView.frame.size.height);
                
                resViewHeight = resViewHeight+imageView.frame.size.height + 5;
                item_y = item_y + imageView.frame.size.height + 5;
                
                [resView addSubview:imageView];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[JSQAudioMediaItem class]]){
                JSQAudioMediaItem *jsqaudio = [self.data objectAtIndex:i];
                UIView *myview = jsqaudio.mediaView;
                CGFloat posAudioX = 0.0;
                if ( self.appliesMediaViewMaskAsOutgoing ) {
                    posAudioX = maxWidth - myview.frame.size.width - 5;
                }
                myview.frame = CGRectMake(posAudioX, item_y,myview.frame.size.width, myview.frame.size.height);
                resViewHeight = resViewHeight+myview.frame.size.height + 5;
                item_y = item_y + myview.frame.size.height + 5;
                [resView addSubview:myview];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[JSQVideoMediaItem class]]){
                JSQVideoMediaItem *jsqaudio = [self.data objectAtIndex:i];
                UIImageView *imageView = jsqaudio.mediaView;
                
                imageView.frame = CGRectMake(0, item_y,imageView.frame.size.width - 5, imageView.frame.size.height);
                resViewHeight = resViewHeight+imageView.frame.size.height + 5;
                item_y = item_y + imageView.frame.size.height + 5;
                [resView addSubview:imageView];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[NSString class]]){
                
        
                NSString *text = [self.data objectAtIndex:i];
                
                UIFont *customFont = [UIFont fontWithName:@"ThaiSansNeue-Regular" size:24.0f];
                CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(250, 155) lineBreakMode:NSLineBreakByTruncatingTail];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 0.0f;
                paragraphStyle.lineHeightMultiple = 0.8f;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,  text.length)];
                
                
                
                CGRect stringRect = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                  attributes:@{ NSFontAttributeName : customFont,  NSParagraphStyleAttributeName: paragraphStyle}
                                                                     context:nil];
                
                
                UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, stringRect.size.width, stringRect.size.height + 10)];
                fromLabel.text = text;
                fromLabel.attributedText = attributedString;
                fromLabel.textColor = [UIColor blackColor];
                fromLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                fromLabel.font = customFont;
                fromLabel.numberOfLines = 0;
                
                fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
                fromLabel.adjustsFontSizeToFitWidth = YES;
                fromLabel.adjustsLetterSpacingToFitWidth = YES;
                fromLabel.clipsToBounds = YES;
                fromLabel.textAlignment = NSTextAlignmentLeft;
                fromLabel.backgroundColor = [UIColor clearColor];
                
                CGFloat posAudioX = 0.0;
                if ( self.appliesMediaViewMaskAsOutgoing ) {
                    posAudioX = maxWidth - fromLabel.frame.size.width - 35;
                }
                
                UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(posAudioX, item_y, fromLabel.frame.size.width + 30, fromLabel.frame.size.height + 5)];
                 unsigned rgbValue = 0;
                if ( self.appliesMediaViewMaskAsOutgoing ) {
                 
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
                
                gradientMask.frame = myview.bounds;
                gradientMask.colors = @[(id)color1.CGColor,
                                        (id)color2.CGColor,
                                        (id)color3.CGColor];
                gradientMask.locations = @[@0.0, @0.7, @1.0];
                gradientMask.startPoint = CGPointMake(0.0, 0.5);   // start at left middle
                gradientMask.endPoint = CGPointMake(1.0, 0.5);     // end at right middle
                [myview.layer addSublayer:gradientMask];
                }
                
                
                NSScanner *scanner1 = [NSScanner scannerWithString:@"#EEEEEE"];
                [scanner1 setScanLocation:1]; // bypass '#' character
                [scanner1 scanHexInt:&rgbValue];
                UIColor *color1 = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
                myview.backgroundColor =  color1;
                myview.layer.cornerRadius = 17.0;
                myview.layer.masksToBounds = YES;
                [myview addSubview:fromLabel];
                resViewHeight = resViewHeight + myview.frame.size.height + 5;
                item_y = item_y + myview.frame.size.height + 5;
                 [resView addSubview:myview];
            }
        }
        
        resView.frame = CGRectMake(0, 0,maxWidth, resViewHeight - 5 );
        NSLog(@"%@",@"create cachedMultiView");
        self.cachedMultiView = resView;
//        return resView;
        
    }else{
        CGFloat resViewHeight = 0;
        for (int i = 0; i < self.cachedMultiView.subviews.count; i++)
        {
            resViewHeight = resViewHeight + self.cachedMultiView.subviews[i].frame.size.height + 5;
        }
        
        self.cachedMultiView.frame = CGRectMake(0, 0,maxWidth, resViewHeight); //.size.height = resViewHeight;
         NSLog(@"%@ %f",@"use cachedMultiView",self.cachedMultiView.frame.size.height);
        
        
//         NSLog(@"%@",@"use cachedMultiView");
    }
    
    return self.cachedMultiView;
}

- (UIColor *)jsq_messageBubbleHexColor:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSString *)mediaDataType
{
    return (NSString *)kUTTypeJPEG;
}

- (id)mediaData
{
    return UIImageJPEGRepresentation(self.image, 1);
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder Multi");
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQMultiMediaItem *copy = [[JSQMultiMediaItem allocWithZone:zone] initWithData:self.data];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
