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

#import "JSQPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


#import <MobileCoreServices/UTCoreTypes.h>

@interface JSQPhotoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;
@property (strong, nonatomic) UIImageView *cachedImagePreview;

@end


@implementation JSQPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _image = [image copy];
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
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        
        
        if(_textView != nil){
            CGSize size = [self mediaViewDisplaySize];
            
            [self.image drawInRect:CGRectMake(0, 0, size.width,  _textView.frame.size.height)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
            
            imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height + _textView.frame.size.height);
            //            imageView.contentMode = UIViewContentModeScaleAspectFill;
            _textView.frame = CGRectMake(0,size.height, size.width, _textView.frame.size.height);
            _textView.bounds = CGRectInset(_textView.frame, 2.0f, 2.0f);
            
            [imageView addSubview:_textView];
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
            self.cachedImageView = imageView;
        }else{
            CGSize size = [self mediaViewDisplaySize];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
            
            imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height );
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
            self.cachedImageView = imageView;
        }
        
        
    }
    
    return self.cachedImageView;
}




- (UIView *)mediaPreview
{
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImagePreview == nil) {
        
        
            CGSize size = CGSizeMake(130.0f, 130.0f);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
            
            imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height );
            imageView.bounds = CGRectInset(imageView.frame, 10.0f, 10.0f);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        
            self.cachedImagePreview = imageView;
 
        
    }
    
    return self.cachedImagePreview;
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
    JSQPhotoMediaItem *copy = [[JSQPhotoMediaItem allocWithZone:zone] initWithImage:self.image];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
