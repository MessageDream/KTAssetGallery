//
//  KTAlbumsDataSource.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/2.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTAlbumsDataSource.h"
#import "KTAssetsModel.h"
#import "KTAssetManager.h"

static NSString *albumCellIdentifier = @"albumCellIdentifier";

@interface KTAlbumsDataSource()<KTAssetsDelegate>
{
    KTAssetsModel *_assetsModel;
    void (^_loadContentBlock)(UITableViewCell *cell, id<KTAlbumProtocol> album);
}
@end

@implementation KTAlbumsDataSource
-(instancetype)init{
    if (self = [super init]) {
        _assetsModel = [[KTAssetsModel alloc] initWithResults:[KTAssetManager albumFetchResults]];
    }
    return self;
}

-(void)setTableView:(UITableView *)tableView cellClass:(Class)cellClass loadContentBlock:(void (^)(id cell, id<KTAlbumProtocol> album))block{
        [tableView registerClass:cellClass forCellReuseIdentifier:albumCellIdentifier];
        _loadContentBlock = block;
        tableView.dataSource = self;
}

-(id<KTAlbumProtocol>)valueOfIndexPath:(NSIndexPath *)indexPath{
    return [_assetsModel valueOfIndexPath:indexPath];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _assetsModel.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_assetsModel objectAtIndex:section].count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   id<KTAlbumProtocol> album = [_assetsModel valueOfIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellIdentifier];
    if (_loadContentBlock) {
        _loadContentBlock(cell,album);
    }
    return cell;
}

//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier(albumCellIdentifier, forIndexPath: indexPath) as! AlbumCell
//    
//    // Fetch album
//    if let album = _assetsModel[indexPath.section][indexPath.row] as? PHAssetCollection {
//        // Title
//        cell.albumTitleLabel.text = album.localizedTitle
//        
//        // Selected
//        cell.selected = contains(_assetsModel.selections(), album)
//        
//        // Selection style
//        cell.selectionStyle = .None
//        
//        // Set images
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [
//                                        NSSortDescriptor(key: "creationDate", ascending: false)
//                                        ]
//        // TODO: Limit result to 3 images
//        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.Image.rawValue)
//        
//        PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions)
//        if let result = PHAsset.fetchAssetsInAssetCollection(album, options: fetchOptions) {
//            result.enumerateObjectsUsingBlock { (object, idx, stop) in
//                if let asset = object as? PHAsset {
//                    let imageSize = CGSize(width: 79, height: 79)
//                    let imageContentMode: PHImageContentMode = .AspectFill
//                    switch idx {
//                    case 0:
//                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                            cell.firstImageView.image = result
//                            cell.secondImageView.image = result
//                            cell.thirdImageView.image = result
//                        }
//                    case 1:
//                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                            cell.secondImageView.image = result
//                            cell.thirdImageView.image = result
//                        }
//                    case 2:
//                        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageSize, contentMode: imageContentMode, options: nil) { (result, _) in
//                            cell.thirdImageView.image = result
//                        }
//                        
//                    default:
//                        // Stop enumeration
//                        stop.initialize(true)
//                    }
//                }
//            }
//        }
//    }
//    
//    return cell
//}

-(void)didUpdateAssets:(id)sender incrementalChange:(BOOL)incrementalChange insert:(NSArray *)insert delete:(NSArray *)delete andChange:(NSArray *)change{
    [self.delegate didUpdateAssets:sender incrementalChange:incrementalChange insert:insert delete:delete andChange:change];
}

-(void)selectObjectAtIndexPath:(NSIndexPath *)indexPath{
    [_assetsModel removeSelections];
    [_assetsModel selectObjectAtIndexPath:indexPath];
}

-(void)deselectObjectAtIndexPath:(NSIndexPath *)indexPath{
    [_assetsModel deselectObjectAtIndexPath:indexPath];
}

-(NSInteger)selectionCount{
    return [_assetsModel selectionCount];
}

-(NSArray<NSIndexPath *> *)selectedIndexPaths{
    return [_assetsModel selectedIndexPaths];
}

-(NSArray *)selections{
    return [_assetsModel selections];
}

-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath{
    return [_assetsModel isSelectedAtIndexPath:indexPath];
}
@end
