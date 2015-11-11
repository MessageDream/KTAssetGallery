//
//  KTAssetsModel.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTAssetsModel.h"
#import "KTFetchResult.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface KTAssetsModel ()<PHPhotoLibraryChangeObserver>
{
    NSMutableArray *_selections;
}
@property(strong, nonatomic)NSArray<KTFetchResult *> *results;

-(NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet inSection:(NSInteger) section;
@end

@implementation KTAssetsModel

-(instancetype)initWithResults:(NSArray<KTFetchResult *> *)results{
    if (self = [super init]) {
        _results = results;
        _selections = [NSMutableArray array];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < __IPHONE_8_0/10000){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsChangeNotification:) name:ALAssetsLibraryChangedNotification object:nil];
        }else{
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        }
    }
    return self;
}

-(NSInteger)count{
    return _results.count;
}


-(KTFetchResult *)objectAtIndex:(NSUInteger)index{
    return _results[index];
}


-(id)valueOfIndexPath:(NSIndexPath *)indexPath{
    return [[self objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet inSection:(NSInteger)section{
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    return indexPaths;
}

-(void)removeSelections{
    [_selections removeAllObjects];
}

-(void)setSelections:(NSArray *)selections{
    _selections = [NSMutableArray arrayWithArray:selections];
}

#pragma mark - PHPhotoLibraryChangeObserver
-(void)photoLibraryDidChange:(PHChange *)changeInstance{
//    for (KTFetchResult *result in _results) {
//        NSInteger index = [_results indexOfObject:result];
//        PHFetchResult *fetchResult = result.fetchOriginalData;
//        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:fetchResult];
//        if (collectionChanges){
//            PHFetchResult *newResult = collectionChanges.fetchResultAfterChanges;
//            
//            KTFetchResult * re = _results[index];
//            re.fetchOriginalData= newResult;
//            BOOL incrementalChange = collectionChanges.hasIncrementalChanges && collectionChanges.removedIndexes != nil && collectionChanges.insertedIndexes != nil && collectionChanges.changedIndexes != nil;
//            
//            NSArray *removedIndexPaths;
//            NSArray *insertedIndexPaths;
//            NSArray *changedIndexPaths;
//            
//            if (incrementalChange) {
//                removedIndexPaths =  [self indexPathsFromIndexSet:collectionChanges.removedIndexes inSection: index];
//                insertedIndexPaths =  [self indexPathsFromIndexSet:collectionChanges.insertedIndexes inSection: index];
//                changedIndexPaths =  [self indexPathsFromIndexSet:collectionChanges.changedIndexes inSection: index];
//            } else {
//                removedIndexPaths = [NSArray array];
//                insertedIndexPaths = [NSArray array];
//                changedIndexPaths = [NSArray array];
//            }
//            
//            [self.delegate didUpdateAssets:self incrementalChange:incrementalChange insert: insertedIndexPaths delete: removedIndexPaths andChange: changedIndexPaths];
//        }
//    }
}

#pragma mark - notification
-(void)assetsChangeNotification:(NSNotification *)notification{
//    NSDictionary *dic = notification.userInfo;
//    for (KTFetchResult *result in _results) {
//        if (self.modelType == KTAssetsModelType_Assets) {
//            id change = [dic objectForKey:ALAssetLibraryUpdatedAssetsKey];
//        }else{
//            id change = [dic objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
//            id insert = [dic objectForKey:ALAssetLibraryInsertedAssetGroupsKey];
//            id delete = [dic objectForKey:ALAssetLibraryDeletedAssetGroupsKey];
//        }
//    }
}

#pragma mark - KTSelectableProtocol
-(void)selectObjectAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [_results[indexPath.section] objectAtIndex:indexPath.row];
    if (obj && ![_selections containsObject:obj]) {
        [_selections addObject:obj];
    }
}

-(void)deselectObjectAtIndexPath:(NSIndexPath *)indexPath{
    id obj = [_results[indexPath.section] objectAtIndex:indexPath.row];
    if (obj && [_selections containsObject:obj]) {
        [_selections removeObject:obj];
    }
}

-(NSInteger)selectionCount{
    return _selections.count;
}

-(NSArray<NSIndexPath *> *)selectedIndexPaths{
    NSMutableArray<NSIndexPath *> *indexPaths =  [NSMutableArray array];
    
    for (id object in _selections) {
        for (id obj  in _results) {
            NSInteger resultIndex = [_results indexOfObject:obj];
            NSInteger index = [obj indexOfObject:object];
            if (index != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:resultIndex];
                [indexPaths addObject:indexPath];
            }
        }
    }
    
    return indexPaths;
}

-(NSArray *)selections{
    return _selections;
}

-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _results.count) {
        KTFetchResult *section = _results[indexPath.section];
        if (indexPath.row < section.count) {
            id obj = [section objectAtIndex:indexPath.row];
            if (obj && [_selections containsObject:obj]) {
                return YES;
            }
            return NO;
        }
        return NO;
    }
    return NO;
}

-(void)dealloc{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= __IPHONE_7_0/10000){
        [[NSNotificationCenter defaultCenter]removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    }else{
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}
@end
