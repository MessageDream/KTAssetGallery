//
//  KTPHAlbum.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTPHAlbum.h"
#import <Photos/Photos.h>
#import "KTPHAsset.h"

@interface KTPHAlbum ()
{
    NSIndexPath *_indexPath;
}
@property(strong,nonatomic)PHAssetCollection *collection;
@property(strong,nonatomic)PHFetchOptions *fetchOptions;
@end

@implementation KTPHAlbum
-(instancetype)initWithAssetCollection:(id)collection mediaType:(KTAssetMediaType)mediaType{
    if (self = [super init]) {
        self.collection = collection;
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]
                                         ];
        
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",mediaType];
        self.fetchOptions = fetchOptions;
    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(NSIndexPath *)indexPath{
    return _indexPath;
}

- (NSString *)title{
    return self.collection.localizedTitle;
}

- (id)valueForProperty:(NSString *)property{
    return nil;
}

- (void)posterImage:(void (^)(UIImage *image))imageCallback{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:self.fetchOptions];
    if (result) {
        PHAsset *asset = [result lastObject];
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(79, 79) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            imageCallback(result);
        }];
        
    }else{
        imageCallback(nil);
    }
}

- (NSInteger)numberOfAssets{
    return [self.collection estimatedAssetCount];
}

- (void)enumerateAssetsUsingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:self.fetchOptions];
    if (result) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            KTPHAsset *aResult = [[KTPHAsset alloc] initWithPHAsset:obj];
            [aResult setIndexPath:[NSIndexPath indexPathForRow:idx inSection:[self indexPath].row]];
            enumerationBlock(aResult,idx,stop);
        }];
    }
}

- (void)enumerateAssetsWithOptions:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:self.fetchOptions];
    if (result) {
        [result enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            KTPHAsset *aResult = [[KTPHAsset alloc] initWithPHAsset:obj];
            [aResult setIndexPath:[NSIndexPath indexPathForRow:idx inSection:[self indexPath].row]];
            enumerationBlock(aResult,idx,stop);
        }];
    }
}

- (void)enumerateAssetsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    PHFetchResult *result = [PHAsset fetchKeyAssetsInAssetCollection:self.collection options:self.fetchOptions];
    [result enumerateObjectsAtIndexes:indexSet options:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KTPHAsset *aResult = [[KTPHAsset alloc] initWithPHAsset:obj];
        [aResult setIndexPath:[NSIndexPath indexPathForRow:idx inSection:[self indexPath].row]];
        enumerationBlock(aResult,idx,stop);
    }];
}
@end
