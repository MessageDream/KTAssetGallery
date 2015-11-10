//
//  KTPhotosDataSource.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KTAssetsDelegate.h"
#import "KTSelectableProtocol.h"
#import "KTAssetProtocol.h"
#import "KTAlbumProtocol.h"

@interface KTPhotosDataSource : NSObject<KTSelectableProtocol>
@property(assign,nonatomic)CGSize imageSize;
@property(weak,nonatomic)id<KTAssetsDelegate> delegate;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView cellClass:(Class)cellClass lastTimeSelections:(NSArray<id<KTAssetProtocol>> *)lastTimeSelections loadContentBlock:(void (^)(id cell, id<KTAssetProtocol> asset, BOOL isSelected, NSIndexPath *indexPath))block;
- (void)fetchResultsForAsset:(id<KTAlbumProtocol>)album;
@end
