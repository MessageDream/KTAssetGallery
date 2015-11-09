//
//  KTALAlbum.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTALAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KTALAsset.h"

@interface KTALAlbum()
{
    NSIndexPath *_indexPath;
}
@property(strong,nonatomic)ALAssetsGroup *group;
@end

@implementation KTALAlbum
-(instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group{
    if (self = [super init]) {
        self.group = group;
    }
    return self;
}

-(instancetype)initWithAssetCollection:(id)collection mediaType:(KTAssetMediaType)mediaType{
    if (self = [super init]) {
        self.group = collection;
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
    return nil;
}

- (id)valueForProperty:(NSString *)property{
    return [self.group valueForProperty:property];
}

- (void)posterImage:(void (^)(UIImage *image))imageCallback;{
    imageCallback([UIImage imageWithCGImage:[self.group posterImage]]);
}

- (NSInteger)numberOfAssets{
    return self.group.numberOfAssets;
}

- (void)enumerateAssetsUsingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        KTALAsset *aResult = [[KTALAsset alloc] initWithALAsset:result];
        [aResult setIndexPath:[NSIndexPath indexPathForRow:index inSection:[self indexPath].row]];
        enumerationBlock(aResult,index,stop);
    }];
}

- (void)enumerateAssetsWithOptions:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    [self.group enumerateAssetsWithOptions:options usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        KTALAsset *aResult = [[KTALAsset alloc] initWithALAsset:result];
        [aResult setIndexPath:[NSIndexPath indexPathForRow:index inSection:[self indexPath].row]];
        enumerationBlock(aResult,index,stop);
    }];
}

- (void)enumerateAssetsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock{
    [self.group enumerateAssetsAtIndexes:indexSet options:options usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        KTALAsset *aResult = [[KTALAsset alloc] initWithALAsset:result];
        [aResult setIndexPath:[NSIndexPath indexPathForRow:index inSection:[self indexPath].row]];
        enumerationBlock(aResult,index,stop);
    }];
}
@end
