//
//  KTAlbumProtocol.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KTAssetProtocol.h"

typedef void (^KTAlbumEnumerationResultsBlock)(id<KTAssetProtocol> result, NSUInteger index, BOOL *stop);



@protocol KTAlbumProtocol <NSObject>
@required
-(instancetype)initWithAssetCollection:(id)collection mediaType:(KTAssetMediaType)mediaType;

- (NSString *)title;

- (id)valueForProperty:(NSString *)property;

- (void)posterImage:(void (^)(UIImage *image))imageCallback;

//- (void)setAssetsFilter:(ALAssetsFilter *)filter;

- (NSInteger)numberOfAssets;

- (void)enumerateAssetsUsingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock;
- (void)enumerateAssetsWithOptions:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock;
- (void)enumerateAssetsAtIndexes:(NSIndexSet *)indexSet options:(NSEnumerationOptions)options usingBlock:(KTAlbumEnumerationResultsBlock)enumerationBlock;
@end
