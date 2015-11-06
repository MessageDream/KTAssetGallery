//
//  KTPhotosDataSource.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTPhotosDataSource.h"
#import "KTAssetsModel.h"
#import "KTAssetManager.h"
#import "KTIndexPathProtocol.h"

@interface KTPhotosDataSource()<UICollectionViewDataSource, KTAssetsDelegate>
{
    KTAssetsModel *_assetsModel;
    void (^_loadContentBlock)(UICollectionViewCell *cell, id<KTAssetProtocol> asset, BOOL isSelected, NSIndexPath *indexPath);
    NSMutableArray<id<KTAssetProtocol>> *_lastTimeSelectedAssets;
}
@end

static NSString *photoCellIdentifier = @"photoCellIdentifier";

@implementation KTPhotosDataSource


- (instancetype)initWithCollectionView:(UICollectionView *)collectionView cellClass:(Class)cellClass lastTimeSelections:(NSArray<id<KTAssetProtocol>> *)lastTimeSelections loadContentBlock:(void (^)(id cell, id<KTAssetProtocol> asset, BOOL isSelected, NSIndexPath *indexPath))block{
    if (self = [super init]) {
        _lastTimeSelectedAssets = [NSMutableArray arrayWithArray:lastTimeSelections];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:photoCellIdentifier];
        _loadContentBlock = block;
        collectionView.dataSource = self;
    }
    return self;
}


- (void)fetchResultsForAsset:(id<KTAlbumProtocol,KTIndexPathProtocol>)album;{
    NSArray<id<KTAssetProtocol>> *temSelections = [_assetsModel selections];
    _assetsModel = [[KTAssetsModel alloc] initWithResults:[KTAssetManager fetchResultsForAlbum:album]];
    _assetsModel.delegate = self;
    
    for (id<KTAssetProtocol> selectedAsset in temSelections) {
        [_lastTimeSelectedAssets addObject:selectedAsset];
    }
    
    NSMutableArray<id<KTAssetProtocol>> *temHasSelected = [[NSMutableArray alloc] init];
    for (id<KTAssetProtocol,KTIndexPathProtocol> asset in _lastTimeSelectedAssets) {
        if (asset.indexPath.section != album.indexPath.row) {
            [temHasSelected addObject:asset];
            continue;
        }
        [_assetsModel selectObjectAtIndexPath:[NSIndexPath indexPathForRow:asset.indexPath.row inSection:0]];
    }
    
    _lastTimeSelectedAssets = temHasSelected;
    
    [self.delegate didUpdateAssets:self incrementalChange:false insert:nil delete:nil andChange:nil];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _assetsModel.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_assetsModel objectAtIndex:section].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<KTAssetProtocol> asset = [_assetsModel valueOfIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellIdentifier forIndexPath:indexPath];
    if (_loadContentBlock) {
        _loadContentBlock(cell,asset,[self isSelectedAtIndexPath:indexPath],indexPath);
    }
    return cell;
}

//func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    UIView.setAnimationsEnabled(false)
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! PhotoCell
//
//    // Cancel any pending image requests
//    if cell.tag != 0 {
//        photosManager.cancelImageRequest(PHImageRequestID(cell.tag))
//    }
//
//    if let asset = _assetsModel[indexPath.section][indexPath.row] as? PHAsset {
//        cell.asset = asset
//
//        // Request image
//        cell.tag = Int(photosManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//            cell.imageView.image = result
//        })
//
//        // Set selection number
//        if let index = find(_assetsModel.selections(), asset) {
//            cell.selectionNumber = index + 1
//            cell.selected = true
//        } else {
//            cell.selectionNumber = 0
//            cell.selected = false
//        }
//    }
//
//    UIView.setAnimationsEnabled(true)
//
//    return cell
//}

-(id<KTAssetProtocol>)valueOfIndexPath:(NSIndexPath *)indexPath{
    return [_assetsModel valueOfIndexPath:indexPath];
}

-(void)didUpdateAssets:(id)sender incrementalChange:(BOOL)incrementalChange insert:(NSArray *)insert delete:(NSArray *)delete andChange:(NSArray *)change{
    [self.delegate didUpdateAssets:sender incrementalChange:incrementalChange insert:insert delete:delete andChange:change];
}

-(void)selectObjectAtIndexPath:(NSIndexPath *)indexPath{
    [_assetsModel selectObjectAtIndexPath:indexPath];
}

-(void)deselectObjectAtIndexPath:(NSIndexPath *)indexPath{
    [_assetsModel deselectObjectAtIndexPath:indexPath];
}

-(NSInteger)selectionCount{
    return [_assetsModel selectionCount] + [_lastTimeSelectedAssets count];
}

-(NSArray<NSIndexPath *> *)selectedIndexPaths{
    return [_assetsModel selectedIndexPaths];
}

-(NSArray<id<KTAssetProtocol>> *)selections{
    
    NSArray *newSelected = [_assetsModel selections];
    if (!_lastTimeSelectedAssets) {
        return newSelected;
    }
   
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithArray:_lastTimeSelectedAssets];
    for (id<KTAssetProtocol> asset in newSelected) {
        [totalArray addObject:asset];
    }
    return totalArray;
}

-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath{
    return [_assetsModel isSelectedAtIndexPath:indexPath];
}
@end
