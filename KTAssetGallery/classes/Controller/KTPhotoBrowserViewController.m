//
//  KTPhotoBrowserViewController.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotoBrowserViewController.h"
#import "KTPreviewPhotoView.h"
#import "KTSelectionView.h"

#define kPadding 0
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@class KTPhotoBrowserBottomToolbar;

@protocol KTPhotoBrowserBottomToolbarDelegate<NSObject>

-(BOOL)shouldSelectedAtIndex:(NSInteger)index;
-(BOOL)shouldDeSelectedAtIndex:(NSInteger)index;

-(void)didSelectedAtindex:(NSInteger)index;
-(void)didDeSelectedAtindex:(NSInteger)index;

-(void)selectedFailedAtIndex:(NSInteger)index;

@end

@interface KTPhotoBrowserBottomToolbar : UIView
{
    BOOL _selected;
}
@property (assign, nonatomic) NSInteger currentPhotoIndex;
@property (assign, nonatomic) BOOL selected;
@property (weak, nonatomic) KTSelectionView *selectionView;
@property (assign, nonatomic) id<KTPhotoBrowserBottomToolbarDelegate> delegate;
@end

@implementation KTPhotoBrowserBottomToolbar
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* _tmpView = [super hitTest:point withEvent:event];
    if ([_tmpView isKindOfClass:[KTPhotoBrowserBottomToolbar class]]) {
        return nil;
    }
    return _tmpView;
}

- (id)init{
    self = [super init];
    if (self) {
        KTSelectionView *selectionView = [[KTSelectionView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectView:)];
        tapGes.numberOfTapsRequired = 1;
        [selectionView addGestureRecognizer:tapGes];
        
        [self addSubview:selectionView];
        self.selectionView = selectionView;
        selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [selectionView addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(BOOL)selected{
    return _selected;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    self.selectionView.selected = selected;
}

-(void)clickSelectView:(UITapGestureRecognizer *)sender{
    if (self.selected && [_delegate shouldDeSelectedAtIndex:_currentPhotoIndex]) {
        [_delegate didDeSelectedAtindex:_currentPhotoIndex];
        self.selected = !self.selected;
        return;
    }
    
    if (!self.selected && [_delegate shouldDeSelectedAtIndex:_currentPhotoIndex]){
        [_delegate didSelectedAtindex:_currentPhotoIndex];
        self.selected = !self.selected;
        return;
    }
}

@end

@protocol KTPhotoBrowserToolbarDelegate<NSObject>

-(void)back;

-(void)confirm;

-(void)save;

@end

@interface KTPhotoBrowserToolbar : UIView
// 所有的图片对象
@property (assign, nonatomic) NSUInteger totalCount;

// 当前展示的图片索引
@property (weak, nonatomic) UIButton *confimBtn;
@property (weak, nonatomic) UIButton *downloadBtn;

@property (assign, nonatomic) NSUInteger currentPhotoIndex;
@property (weak, nonatomic) UILabel *indexLabel;

@property (weak, nonatomic) KTSelectionView *selectionView;
@property (assign, nonatomic) id<KTPhotoBrowserToolbarDelegate> delegate;

- (void)setSelectLabelCount:(NSInteger)count;
@end

@implementation KTPhotoBrowserToolbar

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* _tmpView = [super hitTest:point withEvent:event];
    if ([_tmpView isKindOfClass:[KTPhotoBrowserToolbar class]]) {
        return nil;
    }
    return _tmpView;
}

- (id)init{
    self = [super init];
    if (self) {
        
        UIButton *backbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbutton addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backbutton];
        backbutton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[backbutton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backbutton)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[backbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backbutton)]];
        
        UIButton *confimbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [confimbutton setTitle:@"确定" forState:UIControlStateNormal];
        
        [confimbutton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
        confimbutton.enabled =  NO;
        [self addSubview:confimbutton];
        self.confimBtn = confimbutton;
        confimbutton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[confimbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(confimbutton)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[confimbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(confimbutton)]];
        
        KTSelectionView *selectionView = [[KTSelectionView alloc] init];
        selectionView.selectionString = @"0";
        selectionView.selected = YES;
        
        [self addSubview:selectionView];
        self.selectionView = selectionView;
        
        selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectionView]-12-[confimbutton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView,confimbutton)]];
        
        [selectionView addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.backgroundColor = [UIColor clearColor];
        indexLabel.textColor  =[UIColor whiteColor];
        indexLabel.text = @"0000000000000";
        [indexLabel sizeToFit];
        indexLabel.frame =CGRectMake(0, 0, indexLabel.bounds.size.width, indexLabel.bounds.size.height);
        [self addSubview:indexLabel];
        self.indexLabel= indexLabel;
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indexLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indexLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[indexLabel]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(indexLabel)]];
        
        //        UIButton *downloadBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        //        downloadBtn.hidden = YES;
        //        [self addSubview:downloadBtn];
        //        self.downloadBtn = downloadBtn;
    }
    return self;
}

-(void)click_confirm{
    [_delegate confirm];
}
-(void)click_back{
    [_delegate back];
}

-(void)click_save{
    [_delegate save];
}

- (void)setPhotosCount:(NSInteger)totalCount{
    _totalCount = totalCount;
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _totalCount];
}

- (void)setSelectLabelCount:(NSInteger)count{
    _selectionView.selectionString = [NSString stringWithFormat:@"%i", count];
}

@end

@interface KTPhotoBrowserViewController () <KTPreviewPhotoViewDelegate, KTPhotoBrowserBottomToolbarDelegate, KTPhotoBrowserToolbarDelegate>
{
    // 滚动的view
    UIScrollView *_photoScrollView;
    // 所有的图片view
    NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}
@property(nonatomic,strong) KTPhotoBrowserToolbar *toolbar;
@property(nonatomic,strong) KTPhotoBrowserBottomToolbar *bottomtoolbar;

@property(nonatomic,strong) NSMutableArray *selectIndexs;

@property (nonatomic) NSUInteger selectedCount;
@property (nonatomic) NSUInteger allowCount;

@end

@implementation KTPhotoBrowserViewController

-(void)albumSelected:(NSInteger)count list:(NSArray *)list{
    self.selectIndexs = [NSMutableArray arrayWithArray:list];
    self.allowCount =  count  ;
    self.selectedCount =[self.selectIndexs count] ;
}

#pragma mark - Lifecycle
- (void)loadView{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    self.view = [[UIView alloc] init];
    // self.selectIndexs = [NSMutableArray array];
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


-(BOOL)shouldSelectedAtIndex:(NSInteger)index{
    return YES;
}

-(BOOL)shouldDeSelectedAtIndex:(NSInteger)index{
    return YES;
}

-(void)didSelectedAtindex:(NSInteger)index{
    
}

-(void)didDeSelectedAtindex:(NSInteger)index{
    
}

-(void)selectedFailedAtIndex:(NSInteger)index{
    
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
    _toolbar.totalCount = [_photos count];
    _toolbar.delegate = self;
    
    [self.view addSubview:_toolbar];
    [_toolbar setSelectLabelCount:self.selectedCount];
    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_toolbar(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
    if (_selectIndexs.count>0 ){
        _toolbar.confimBtn.enabled = YES;
    }else{
        _toolbar.confimBtn.enabled = NO;
        
    }
    
    [self updateTollbarState];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createScrollView];
    if (!_hideHUD) {
        [self createToolbar];
        
        if (!_hideConfimBtn) {
            [self createBottomToolbar];
            
        }
    }
}

-(void)back{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.selectIndexs];
    [_delegate back_photoBrowser:self selectPhotos:array];
}

-(void)confirm{
    
}

#pragma mark - 私有方法
#pragma mark 创建工具条

-(void)deleteThisImage:(NSInteger)ThisImageIndex{
    if ( ThisImageIndex == 0 ) {
        _currentPhotoIndex = 1;
    }else if ( ThisImageIndex == _currentPhotoIndex ) {
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }else{
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }
    
    [_photos removeObjectAtIndex: ThisImageIndex];
    
    [self setCurrentPhotoIndex: _currentPhotoIndex ];
    
}

#pragma mark 创建UIScrollView
- (void)createScrollView{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    [_photoScrollView setExclusiveTouch:YES];
    
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSMutableArray *)photos{
    _photos = photos;
    
    //    if (photos.count > 1) {
    //        _visiblePhotoViews = [NSMutableSet set];
    //        _reusablePhotoViews = [NSMutableSet set];
    //    }
    //
    //    for (int i = 0; i<_photos.count; i++) {
    //        KTPhoto *photo = _photos[i];
    //        photo.index = i;
    //        photo.firstShow = i == _currentPhotoIndex;
    //
    //        if (i == _currentPhotoIndex) {
    //            [_bottomtoolbar setCurrentPhoto:photo];
    //        }
    //    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    
    //    for (int i = 0; i<_photos.count; i++) {
    //        KTPhoto *photo = _photos[i];
    //        photo.firstShow = i == currentPhotoIndex;
    //    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - PhotoView代理
- (void)photoViewSingleTap:(KTPreviewPhotoView *)photoView{
    _toolbar.alpha = 1.0 - _toolbar.alpha;
    _bottomtoolbar.alpha = 1.0 - _bottomtoolbar.alpha;
}

- (void)photoViewDidEndZoom:(KTPreviewPhotoView *)photoView{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(KTPreviewPhotoView *)photoView{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (KTPreviewPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index{
    KTPreviewPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[KTPreviewPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    //    KTPhoto *photo = _photos[index];
    //    photoView.frame = photoViewFrame;
    //    photoView.photo = photo;
    //
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (KTPreviewPhotoView *photoView in _visiblePhotoViews) {
        if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}

#pragma mark 循环利用某个view
- (KTPreviewPhotoView *)dequeueReusablePhotoView{
    KTPreviewPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

-(void)save{
    
    //    KTPhoto *photo = _photos[_currentPhotoIndex];
    //
    //    NSString *fileKey = [KTImageUtils makeThumbnailsUrl:photo.src type:KTImageType2Default];
    //
    //    [[KTImagePool shareImagePool] asyncSetImage:fileKey completion:^(UIImage *img) {
    //
    //        [self saveImageToPhotos:img];
    //
    //    }];
    
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    [self updateTollbarState];
    //    KTPhoto *photo = _photos[_currentPhotoIndex];
    //    [_bottomtoolbar setCurrentPhoto:photo];
}
@end
