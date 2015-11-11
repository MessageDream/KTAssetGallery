//
//  KTPhotosController.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotosController.h"
#import "KTAssetProtocol.h"
#import "KTPhotoCell.h"
#import "KTPhotosDataSource.h"
#import "KTAlbumsController.h"
#import "KTImagePickerSettings.h"
#import "KTPhotoBrowserViewController.h"

static CGFloat imageCellSpace = 1.f;
@interface KTPhotosController()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,KTPhotoCellDelegate>
{
    void (^_loadContentBlock)(KTPhotoCell *cell, id<KTAssetProtocol> asset, BOOL isSelected, NSIndexPath *indexPath);
}
@property(weak,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)KTPhotosDataSource *dataSource;
@property(strong,nonatomic)KTAlbumsController *albumController;

@end

@implementation KTPhotosController

-(void)loadView{
   [super loadView];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.allowsMultipleSelection = YES;
    [collectionView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UIButton *albumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [albumButton addTarget:self action:@selector(album_click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = albumButton;
    
    if ([self.lastTimeSelections count] > 0) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"done(%ld)",[self.lastTimeSelections count]] style:UIBarButtonItemStyleDone target:self action:@selector(done_click:)];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(done_click:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel_click:)];
    
    if (!self.settings) {
        self.settings = [[KTImagePickerSettings alloc] init];
    }
    
    __weak __typeof(self) weakSelf = self;
    _loadContentBlock = ^(KTPhotoCell *cell, id<KTAssetProtocol> asset, BOOL isSelected, NSIndexPath *indexPath) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        cell.ktSelected = isSelected;
        cell.delegate = strongSelf;
        cell.indexPath = indexPath;
        
       [asset thumbnail:^(UIImage *image) {
           cell.image = image;
       }];
    };
    
    self.dataSource = [[KTPhotosDataSource alloc] initWithCollectionView:self.collectionView cellClass:[KTPhotoCell class] lastTimeSelections:self.lastTimeSelections loadContentBlock:_loadContentBlock];
    
    self.collectionView.delegate = self;
    
    _albumController = [[KTAlbumsController alloc] initWithMediaType:self.mediaType albumChangedBlock:^(id<KTAlbumProtocol> album) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [albumButton setTitle:album.title forState:UIControlStateNormal];
        
        [strongSelf.dataSource fetchResultsForAsset:album];
        [strongSelf.collectionView reloadData];
    }];
}

- (void)album_click:(id)sender{
    [_albumController showInViewController:self.navigationController fromView:sender];
}

- (void)done_click:(id)sender{
    if (self.finishBlock) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.finishBlock([self.dataSource selections]);
        });
    }
}

- (void)cancel_click:(id)sender{
    if (self.cancelBlock) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.cancelBlock(self.lastTimeSelections);
        });
    }
}

-(void)updateDoneButton{
    NSInteger count = [self.dataSource selectionCount];
    if (count) {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"done(%ld)",count];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.title = @"done";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark-- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger cellCountPerRow = self.settings.cellsPerRow([UIDevice currentDevice].orientation);
    
    float spaceInSum = imageCellSpace * (cellCountPerRow - 1) * 2;
    float cellWidth = (CGRectGetWidth(collectionView.bounds) - spaceInSum)/cellCountPerRow;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return imageCellSpace * 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return imageCellSpace;
}

#pragma mark-- UICollectionViewDelegate
- (BOOL)photoCellShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   return [self.dataSource selectionCount] < self.settings.maxNumberOfSelections;
}

- (BOOL)photoCellShouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)photoCellDidSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource selectObjectAtIndexPath:indexPath];
    
    [self updateDoneButton];
    
    if (self.selectionBlock) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.selectionBlock([self.dataSource valueOfIndexPath:indexPath]);
        });
    }
}

- (void)photoCellDidDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource deselectObjectAtIndexPath:indexPath];
    [self updateDoneButton];
    
    if (self.deSelectionBlock) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.deSelectionBlock([self.dataSource valueOfIndexPath:indexPath]);
        });
    }
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id<KTAssetProtocol> asset = [self.dataSource valueOfIndexPath:indexPath];
    if (self.tapToPreviewBlock && asset.mediaType == KTAssetMediaTypeVideo) {//视频预览
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.tapToPreviewBlock(asset);
        });
    }else{
        //默认预览
        
        if (asset.mediaType == KTAssetMediaTypeImage) {
            KTPhotoBrowserViewController *vc = [[KTPhotoBrowserViewController alloc] initWithBrowserMode:KTPhotoBrowserModeAlbum];
            vc.dataSource = self.dataSource;
            vc.currentPhotoIndex = indexPath.row;
            vc.settings = self.settings;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}


- (void)syncSelectionInDataSource:(KTPhotosDataSource *)dataSource withCollectionView:(UICollectionView *)collectionView {
    NSArray<NSIndexPath *> *indexPaths = [dataSource selectedIndexPaths];
    
    for (NSIndexPath *indexPath in indexPaths) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

-(void)dealloc{
    
}
@end
