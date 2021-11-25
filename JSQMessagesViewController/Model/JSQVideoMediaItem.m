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

#import "JSQVideoMediaItem.h" 
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesVideoThumbnailFactory.h"

#import "UIImage+JSQMessages.h"


@interface JSQVideoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedVideoImageView;
@property (strong, nonatomic) UIImageView *cachedVideoImagePreview;
@property (strong, nonatomic) UIButton *playButton;
@end


@implementation JSQVideoMediaItem

#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay
{
    return [self initWithFileURL:fileURL isReadyToPlay:isReadyToPlay thumbnailImage:nil presentVC:nil];
}

- (instancetype)initWithFileURL:(NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay thumbnailImage:(UIImage *)thumbnailImage  presentVC:(UIViewController *)presentVC
{
    self = [super init];
    if (self) {
        _fileURL = [fileURL copy];
        _isReadyToPlay = isReadyToPlay;
        _cachedVideoImageView = nil;
        _cachedVideoImagePreview = nil;
        
        _thumbnailImage = thumbnailImage;
        _presentVC = presentVC;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedVideoImageView = nil;
    _cachedVideoImagePreview = nil;
}

#pragma mark - Setters

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = [fileURL copy];
    _cachedVideoImageView = nil;
    _cachedVideoImagePreview = nil;
}

- (void)setIsReadyToPlay:(BOOL)isReadyToPlay
{
    _isReadyToPlay = isReadyToPlay;
    _cachedVideoImageView = nil;
    _cachedVideoImagePreview = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedVideoImageView = nil;
    _cachedVideoImagePreview = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }

    if (self.cachedVideoImageView == nil) {
        CGSize size = CGSizeMake(250, 155);
        
        UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        playView.backgroundColor = [UIColor redColor];
        playView.contentMode = UIViewContentModeCenter;
        playView.clipsToBounds = YES;
        
        UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
 
        self.playButton.contentMode = UIViewContentModeCenter;
       
        [self.playButton setImage:playIcon forState:UIControlStateNormal];
        [self.playButton setImage:playIcon forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(onPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
 

        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:self.playButton isOutgoing:self.appliesMediaViewMaskAsOutgoing];

        if (self.thumbnailImage) {
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:self.thumbnailImage];
            thumbnailImageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
            thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
            thumbnailImageView.clipsToBounds = YES;
            self.playButton.backgroundColor = [UIColor clearColor];
            [playView addSubview:thumbnailImageView];
            [playView addSubview:self.playButton];
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:playView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
            self.cachedVideoImageView = playView;
        }
        else {
            self.playButton.backgroundColor = [UIColor blackColor];
            self.cachedVideoImageView = self.playButton;
        }
    }

    return self.cachedVideoImageView;
}

- (UIView *)mediaPreview
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }
    
    if (self.cachedVideoImagePreview == nil) {
         CGSize size = CGSizeMake(130.0f, 130.0f);
        
        UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        playView.backgroundColor = [UIColor clearColor];
        playView.contentMode = UIViewContentModeCenter;
        playView.clipsToBounds = YES;
        
        UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        
        self.playButton.contentMode = UIViewContentModeCenter;
        
        [self.playButton setImage:playIcon forState:UIControlStateNormal];
        [self.playButton setImage:playIcon forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(onPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (self.thumbnailImage) {
            NSInteger previewBoxSize = 130;

            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:self.thumbnailImage];
            thumbnailImageView.frame = CGRectMake(0.0f, 0.0f,previewBoxSize, previewBoxSize);
            thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
            thumbnailImageView.clipsToBounds = YES;
            self.playButton.backgroundColor = [UIColor clearColor];
            [playView addSubview:thumbnailImageView];
            [playView addSubview:self.playButton];
            
          
            self.cachedVideoImagePreview = playView;
        }
        else {
            playView.backgroundColor = [UIColor blackColor];
            self.cachedVideoImagePreview = playView;
        }
    }
    
    return self.cachedVideoImagePreview;
}


- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject



- (void)onPlayVideo:(UIButton *)sender
{
    
    AVPlayer *player = [AVPlayer playerWithURL: self.fileURL];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init]; 
    [self.presentVC presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];
 
//    [JSQMessagesViewController jsq_playvideo:self.fileURL];
    
}


- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }

    JSQVideoMediaItem *videoItem = (JSQVideoMediaItem *)object;

    return [self.fileURL isEqual:videoItem.fileURL]
    && self.isReadyToPlay == videoItem.isReadyToPlay;
}

- (NSUInteger)hash
{
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: fileURL=%@, isReadyToPlay=%@, appliesMediaViewMaskAsOutgoing=%@>, thumbnailImage=%@",
            [self class], self.fileURL, @(self.isReadyToPlay), @(self.appliesMediaViewMaskAsOutgoing), self.thumbnailImage];
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        _isReadyToPlay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isReadyToPlay))];
        _thumbnailImage = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(thumbnailImage))];
         _presentVC = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(presentVC))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
    [aCoder encodeBool:self.isReadyToPlay forKey:NSStringFromSelector(@selector(isReadyToPlay))];
    [aCoder encodeObject:self.thumbnailImage forKey:NSStringFromSelector(@selector(thumbnailImage))];
    [aCoder encodeObject:self.presentVC forKey:NSStringFromSelector(@selector(presentVC))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVideoMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL
                                                                   isReadyToPlay:self.isReadyToPlay
                                                                  thumbnailImage:self.thumbnailImage
                                                                       presentVC:self.presentVC];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
