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

@property (strong, nonatomic) UIImageView *cachedImageView;
@property (strong, nonatomic) UIImageView *cachedImagePreview;

@end


@implementation JSQMultiMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        image = [image copy];
        _cachedImageView = nil;
    }
    return self;
}



- (instancetype)initWithData:(NSMutableArray *)data
{
    self = [super init];
    if (self) {
        _data = [data copy];
        _cachedImageView = nil;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
}

- (void)setData:(NSMutableArray *)data
{
    _data = [data copy];
    _cachedImageView = nil;
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
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol


- (UIView *)mediaView
{
    if (self.data == nil) {
        return nil;
    } 
    if (self.cachedImageView == nil) {
        
        NSInteger viewcount= self.data.count;
        NSInteger maxWidth = 250;
        CGFloat item_y = 0;
        CGFloat resViewHeight = 0;
        
        UIView *resView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,maxWidth, resViewHeight)];
        
        resView.backgroundColor = [UIColor clearColor];
        
        
        for (int i = 0; i <viewcount; i++)
        {
            if([[self.data objectAtIndex:i] isKindOfClass:[JSQPhotoMediaItem class]]){
                JSQPhotoMediaItem *jsqphoto = [self.data objectAtIndex:i];
                UIImageView *imageView = jsqphoto.mediaView;
                imageView.frame = CGRectMake(0, item_y,imageView.frame.size.width, imageView.frame.size.height);
                resViewHeight = resViewHeight+imageView.frame.size.height + 5;
                item_y = item_y + imageView.frame.size.height + 5;
                [resView addSubview:imageView];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[JSQAudioMediaItem class]]){
                JSQAudioMediaItem *jsqaudio = [self.data objectAtIndex:i];
                UIView *myview = jsqaudio.mediaView;
                myview.frame = CGRectMake(maxWidth - myview.frame.size.width, item_y,myview.frame.size.width, myview.frame.size.height);
                resViewHeight = resViewHeight+myview.frame.size.height + 5;
                item_y = item_y + myview.frame.size.height + 5;
                [resView addSubview:myview];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[JSQVideoMediaItem class]]){
                JSQVideoMediaItem *jsqaudio = [self.data objectAtIndex:i];
                UIImageView *imageView = jsqaudio.mediaView;
                imageView.frame = CGRectMake(0, item_y,imageView.frame.size.width, imageView.frame.size.height);
                resViewHeight = resViewHeight+imageView.frame.size.height + 5;
                item_y = item_y + imageView.frame.size.height + 5;
                [resView addSubview:imageView];
            }else if([[self.data objectAtIndex:i] isKindOfClass:[NSString class]]){
                NSLog(@"%@", [self.data objectAtIndex:i]);
                NSLog(@"ssssss");
                NSString *text = [self.data objectAtIndex:i];
                
                UIFont *customFont = [UIFont systemFontOfSize:18];
                CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(250, 155) lineBreakMode:NSLineBreakByTruncatingTail];
                UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, labelSize.width, labelSize.height)];
                fromLabel.text = text;
                fromLabel.textColor = [UIColor whiteColor];
                fromLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                fromLabel.font = customFont;
                fromLabel.numberOfLines = 0;
                fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
                fromLabel.adjustsFontSizeToFitWidth = YES;
                fromLabel.adjustsLetterSpacingToFitWidth = YES;
                fromLabel.clipsToBounds = YES;
                fromLabel.textAlignment = NSTextAlignmentLeft;

                UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(maxWidth - fromLabel.frame.size.width - 20, item_y, fromLabel.frame.size.width + 20, fromLabel.frame.size.height + 20)];
                myview.backgroundColor =  [UIColor lightGrayColor];
                myview.layer.cornerRadius = 20.0;
                myview.layer.masksToBounds = YES;
                [myview addSubview:fromLabel];
                resViewHeight = resViewHeight + myview.frame.size.height + 5;
                item_y = item_y + myview.frame.size.height + 5;
                 [resView addSubview:myview];
            }
            
            
            // do stuff
        }
        resView.frame = CGRectMake(0, 0,maxWidth, resViewHeight - 5 );
        
        
        self.cachedImageView = resView;
        
    }
    
    return self.cachedImageView;
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

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    JSQMultiMediaItem *copy = [[JSQMultiMediaItem allocWithZone:zone] initWithImage:self.image];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
