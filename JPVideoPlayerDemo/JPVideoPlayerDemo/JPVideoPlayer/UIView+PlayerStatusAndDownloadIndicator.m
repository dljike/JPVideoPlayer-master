/*
 * This file is part of the JPVideoPlayer package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/Chris-Pan
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */


#import "UIView+PlayerStatusAndDownloadIndicator.h"
#import <objc/runtime.h>
#import "JPVideoPlayerPlayVideoTool.h"
#import "JPVideoPlayerActivityIndicator.h"

@interface UIView ()

@property(nonatomic)UIProgressView *progressView;

@property(nonatomic)UIColor *progressViewTintColor;

@property(nonatomic)UIColor *progressViewBackgroundColor;

@property(nonatomic)JPVideoPlayerActivityIndicator *activityIndicatorView;

@end

static char progressViewKey;
static char progressViewTintColorKey;
static char progressViewBackgroundColorKey;
static char activityIndicatorViewKey;
@implementation UIView (PlayerStatusAndDownloadIndicator)

#pragma mark -----------------------------------------
#pragma mark Public

-(void)perfersProgressViewColor:(UIColor * _Nonnull)tintColor{
    if (tintColor)
        self.progressViewTintColor = tintColor;
}

-(void)perfersProgressViewBackgroundColor:(UIColor * _Nonnull)backgroundColor{
    if (backgroundColor) {
        self.progressViewBackgroundColor = backgroundColor;
    }
}

-(void)showProgressView{
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
}

-(void)hideProgressView{
    self.progressView.hidden = YES;
}

-(void)progressViewStatusChangedWithReceivedSize:(NSUInteger)receivedSize expectSize:(NSUInteger)expectSize{
    CGFloat progress = (CGFloat)receivedSize/expectSize;
    progress = MAX(0, progress);
    progress = MIN(progress, 1);
    self.progressView.progress = progress;
}

-(void)showActivityIndicatorView{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideActivityIndicatorView{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


#pragma mark -----------------------------------------
#pragma mark Progress

-(void)setProgressViewTintColor:(UIColor *)progressViewTintColor{
    objc_setAssociatedObject(self, &progressViewTintColorKey, progressViewTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)progressViewTintColor{
    UIColor *color = objc_getAssociatedObject(self, &progressViewTintColorKey);
    if (!color) {
        color = [UIColor colorWithRed:0.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    }
    return color;
}

-(void)setProgressViewBackgroundColor:(UIColor *)progressViewBackgroundColor{
    objc_setAssociatedObject(self, &progressViewBackgroundColorKey, progressViewBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)progressViewBackgroundColor{
    UIColor *color = objc_getAssociatedObject(self, &progressViewTintColorKey);
    if (!color) {
        color = [UIColor colorWithRed:155.0/255 green:155.0/255 blue:155.0/255 alpha:1.0];
    }
    return color;
}

-(UIProgressView *)progressView{
    UIProgressView *progressView = objc_getAssociatedObject(self, &progressViewKey);
    if (!progressView) {
        progressView = [UIProgressView new];
        progressView.hidden = YES;
        progressView.frame = CGRectMake(0, 0, self.frame.size.width, JPVideoPlayerLayerFrameY);
        [self addSubview:progressView];
        progressView.tintColor = self.progressViewTintColor;
        progressView.backgroundColor = self.progressViewBackgroundColor;
        objc_setAssociatedObject(self, &progressViewKey, progressView, OBJC_ASSOCIATION_ASSIGN);
    }
    return progressView;
}

-(JPVideoPlayerActivityIndicator *)activityIndicatorView{
    JPVideoPlayerActivityIndicator *acv = objc_getAssociatedObject(self, &activityIndicatorViewKey);
    if (!acv) {
        acv = [JPVideoPlayerActivityIndicator new];
        CGSize viewSize = self.frame.size;
        CGFloat selfX = (viewSize.width-ActivityIndicatorWH)*0.5;
        CGFloat selfY = (viewSize.height-ActivityIndicatorWH)*0.5;
        acv.frame = CGRectMake(selfX, selfY, ActivityIndicatorWH, ActivityIndicatorWH);
        NSInteger count = self.subviews.count;
        [self insertSubview:acv atIndex:count+1];
        acv.hidden = YES;
        objc_setAssociatedObject(self, &activityIndicatorViewKey, acv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return acv;
}

@end
