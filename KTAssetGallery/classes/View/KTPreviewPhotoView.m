//
//  KTPreviewPhotoView.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPreviewPhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface KTPreviewPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
}
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator ;
@end

@implementation KTPreviewPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.maximumZoomScale = 4.0;
        self.minimumZoomScale  = 1.0;
        self.zoomScale = 1.0;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicator setHidesWhenStopped:YES];
        [self addSubview:activityIndicator];
        
        self.activityIndicator = activityIndicator;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)showImage{
    _imageView.image = nil;
    self.minimumZoomScale  = 1.0;
    self.maximumZoomScale = 4.0;
    if (self.photoUrl) {
        
    }else {
        [_asset fullScreenImage:^(UIImage *image) {
            _imageView.image = image;
            [self.photoViewDelegate photoViewImageFinishLoad:self photo:image];
            [self adjustFrame];
        }];
    }
}

-(void)didMoveToWindow{
    [self showImage];
}
#pragma mark 调整frame
- (void)adjustFrame{
    if (_imageView.image==nil) {
        CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
        (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
        (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
        CGPoint center  = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                      self.contentSize.height * 0.5 + offsetY);
        [self.activityIndicator setCenter:center];
        return;
    }
    CGSize size = _imageView.image.size;
    
    self.zoomScale = 1;
    
    _imageView.frame = CGRectMake(0, 0,  size.width-2, size.height-2);
    
    self.contentOffset = CGPointZero;
    
    float scale4 =  [[UIScreen mainScreen] scale];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h =  self.bounds.size.height;
    
    //图片原始宽度(像素)
    float imgW = size.width;
    
    //图片原始高度(像素)
    float imgH = size.height;
    
    float imgW2 = scale4*imgW;
    //图片的逻辑宽度(加入屏幕scale因素后的像素宽度)
    
    //最终使用的宽度(像素，不能超过ImageView的宽度)
    float w2 = MIN(imgW2, w);
    
    //X轴期望的缩放
    float scale2 = w2 / imgW;
    
    
    //图片的逻辑高度(加入屏幕scale因素后的像素高度)
    float imgH2 = scale4*imgH;
    
    //最终使用的宽度(像素,不能超过ImageView的高度)
    float h2 = MIN(imgH2, h);
    
    //Y轴期望的缩放
    float scale3 = h2 / imgH;
    
    //统一X方向，Y方向的缩放值 （取最小值）
    float scale = MIN(scale2, scale3);
    
    //将缩放值加入矩阵中
    
    self.minimumZoomScale =  scale;
    
    self.zoomScale  = scale;
    
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                    self.contentSize.height * 0.5 + offsetY);
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)hide{
    if (_doubleTap) return;
    
    [UIView animateWithDuration:0.25 animations:^{
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:_imageView];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
    
}


@end
