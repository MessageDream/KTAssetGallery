//
//  KTPhotoBrowserViewController.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotoBrowserViewController.h"
#import "KTPreviewPhotoView.h"
#import "KTPhotoBrowserToolbar.h"
#import "KTPhotoBrowserBottomToolbar.h"
#import "KTReuseableScrollView.h"
#import "KTReuseableScrollViewCell.h"
#import "KTAssetProtocol.h"

#define kPadding 0

static NSString *reuseIdentifier = @"reuseableCell";
@interface KTPhotoBrowserViewController () <KTPreviewPhotoViewDelegate, KTPhotoBrowserBottomToolbarDelegate, KTPhotoBrowserToolbarDelegate,KTReuseableScrollViewDelegate,KTReuseableScrollViewDateSource>
{
    // 滚动的view
    KTReuseableScrollView *_photoScrollView;
    KTPhotoBrowserMode _currentMode;
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}
@property(nonatomic,strong) KTPhotoBrowserToolbar *toolbar;
@property(nonatomic,strong) KTPhotoBrowserBottomToolbar *bottomtoolbar;
@end

@implementation KTPhotoBrowserViewController

-(instancetype)initWithBrowserMode:(KTPhotoBrowserMode)mode{
    if (self = [super init]) {
        _currentMode = mode;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)loadView{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    self.view = [[UIView alloc] init];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        int w  =  [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        int h  =  [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        self.view.frame = CGRectMake(0, 0, w, h);
        
    }else{
        int w  =  [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        int h  =  [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
        self.view.frame = CGRectMake(0, 0, w, h);
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view setExclusiveTouch:YES];
}

- (void)createBottomToolbar{
    _bottomtoolbar = [[KTPhotoBrowserBottomToolbar alloc] init];
    _bottomtoolbar.delegate = self;
    [self.view addSubview:_bottomtoolbar];
    _bottomtoolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomtoolbar(==60)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomtoolbar)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomtoolbar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomtoolbar)]];
}

- (void)createToolbar{
    _toolbar = [[KTPhotoBrowserToolbar alloc] init];
    _toolbar.totalCount = [self.dataSource countOfSection:0];
    _toolbar.delegate = self;
    
    [self.view addSubview:_toolbar];
    [_toolbar setSelectLabelCount:[self.dataSource selectionCount]];
    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_toolbar(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
    if ([self.dataSource selectionCount] > 0){
        _toolbar.confimButton.enabled = YES;
    }else{
        _toolbar.confimButton.enabled = NO;
    }
}

- (void)createScrollView{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    _photoScrollView = [[KTReuseableScrollView alloc] initWithFrame:frame];
    [_photoScrollView registerClass:[KTReuseableScrollViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoScrollView];
    _photoScrollView.reuseableScrollViewDelegate = self;
    _photoScrollView.reuseableScrollViewDataSource = self;
    [_photoScrollView setExclusiveTouch:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createScrollView];
    [self createToolbar];
    
    if (_currentMode == KTPhotoBrowserModeAlbum) {
        [self createBottomToolbar];
    }
    [self showPhotoViewAtIndex:_currentPhotoIndex];
}

#pragma mark - KTPhotoBrowserToolbarDelegate
-(void)back{
    [_delegate backFromViewController:self currentPhotoIndex:_currentPhotoIndex];
}

-(void)confirm{
   [_delegate backFromViewController:self currentPhotoIndex:_currentPhotoIndex];
}

-(void)save{
    
}

#pragma mark - KTPhotoBrowserBottomToolbarDelegate
-(BOOL)shouldSelectedAtIndex:(NSInteger)index{
    return [self.dataSource selectionCount] < self.settings.maxNumberOfSelections;
}

-(BOOL)shouldDeSelectedAtIndex:(NSInteger)index{
    return YES;
}

-(void)didSelectedAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
   [self.dataSource selectObjectAtIndexPath:indexPath];
    NSInteger count = [self.dataSource selectionCount];
    [_toolbar setSelectLabelCount:count];
    _toolbar.confimButton.enabled = count > 0;
}

-(void)didDeSelectedAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.dataSource deselectObjectAtIndexPath:indexPath];
    NSInteger count = [self.dataSource selectionCount];
    [_toolbar setSelectLabelCount:count];
    _toolbar.confimButton.enabled = count > 0;
}

-(void)selectedFailedAtIndex:(NSInteger)index{
    
}

#pragma mark - KTPreviewPhotoViewDelegate
- (void)photoViewSingleTap:(KTPreviewPhotoView *)photoView{
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.alpha = 1.0 - _toolbar.alpha;
        _bottomtoolbar.alpha = 1.0 - _bottomtoolbar.alpha;
    }];
}

- (void)photoViewDidEndZoom:(KTPreviewPhotoView *)photoView{
    //    [self.view removeFromSuperview];
    //    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(KTPreviewPhotoView *)photoView{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - KTReuseableScrollViewDateSource
- (NSUInteger)numberOfCellInReuseableScrollView:(KTReuseableScrollView *)reuseableScrollView{
    return [self.dataSource countOfSection:0];
}

- (KTReuseableScrollViewCell *)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView atIndex:(NSUInteger)index{
    KTReuseableScrollViewCell *cell = [reuseableScrollView dequeueReusableCellWithIdentifier:reuseIdentifier];
    KTPreviewPhotoView *photoView = [[KTPreviewPhotoView alloc] initWithFrame:CGRectZero];
    photoView.photoViewDelegate = self;
    [cell setPageViewInCell:photoView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    id<KTAssetProtocol> asset = [self.dataSource valueOfIndexPath:indexPath];
    photoView.asset = asset;
    
    _currentPhotoIndex = index;
    _toolbar.currentPhotoIndex = index;
    _bottomtoolbar.currentPhotoIndex = index;
    _bottomtoolbar.selected = [self.dataSource isSelectedAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - KTReuseableScrollViewDelegate
//- (void)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView didSelectAtIndex:(NSUInteger)index{
//    
//}

//- (CGFloat)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView marginForType:(KTReuseableScrollViewMarginType)type{
//    
//}

#pragma mark - 私有方法
- (void)setPhotos:(NSMutableArray *)photos{
    _photos = photos;
}


#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index{
     _photoScrollView.contentOffset = CGPointMake(index * _photoScrollView.frame.size.width, 0);
}


- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    //    KTMBProgressHUD * hud = [[KTMBProgressHUD alloc] initWithView:self.view];
    //    hud.mode = KTMBProgressHUDModeText;
    //    hud.removeFromSuperViewOnHide = YES;
    //
    //    [self.view addSubview:hud];
    //
    //    if(error){
    //        hud.detailsLabelText =  [KTResManager loadString:STRING_NO_PERMISSION_TO_ACCESS_ALBUM] ; //XBC
    //
    //    }else{
    //        hud.labelText = [KTResManager loadString:STRING_SAVE_GALLERY] ;  //XBC
    //    }
    //
    //    [hud show:YES];
    //    [hud hide:YES afterDelay:1];
    
}

//- (void)photoViewLoadImage:(KTPreviewPhotoView *)photoView display:(BOOL)display photo:(KTPhoto *)photo{
////    NSInteger type = photo.srcType;
////    if (type==0 || _savePhotoImage ) {
////        _toolbar. downloadBtn.hidden = !display;
////
////    }else{
////        _toolbar. downloadBtn.hidden = YES;
////    }
//}

@end
