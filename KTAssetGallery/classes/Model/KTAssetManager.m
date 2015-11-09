//
//  KTAssetManager.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/6.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTAssetManager.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "KTPHAlbum.h"

@implementation KTAssetManager
+ (KTAuthorizationStatus)authorizationStatus{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < __IPHONE_8_0/10000){
        return (KTAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
    }else{
        return (KTAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
    }
}

+(void)requestAuthorization:(void (^)(KTAuthorizationStatus status))handler{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < __IPHONE_8_0/10000){
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            if (handler) {
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    
                    if (*stop) {
                        handler((KTAuthorizationStatus)[ALAssetsLibrary authorizationStatus]);
                        return;
                    }
                    *stop = TRUE;
                    
                } failureBlock:^(NSError *error) {
                    handler((KTAuthorizationStatus)[ALAssetsLibrary authorizationStatus]);
                }];
            }
        }
    }else{
         [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
             if (handler) {
                 handler((KTAuthorizationStatus) status);
             }
        }];
    }
}

+ (NSArray<KTFetchResult *> *)albumFetchResultsWithMediaType:(KTAssetMediaType)mediaType{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < __IPHONE_8_0/10000){
        return nil;
    }else{
        
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        PHFetchResult<PHAssetCollection *> *cameraCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:option];
        PHFetchResult<PHAssetCollection *> *albumCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:option];
        
        KTFetchResult *cameraResult = [[KTFetchResult alloc] init];
        NSMutableArray *cameraArray = [[NSMutableArray alloc] init];
        [cameraCollectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KTPHAlbum *album = [[KTPHAlbum alloc] initWithAssetCollection:obj mediaType:mediaType];
            [album setIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            [cameraArray addObject:album];
        }];
        
        
        //        KTFetchResult *albumResult = [[KTFetchResult alloc] init];
        //        albumResult.fetchOriginalData = albumCollectionResult;
        //        NSMutableArray *albumArray = [[NSMutableArray alloc] init];
        //        [albumCollectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            [albumArray addObject:[[KTPHAlbum alloc] initWithPHAssetCollection:obj]];
        //        }];
        //        albumResult.constructionData = albumArray;
        //
        //        return @[cameraResult, albumResult];
        
        [albumCollectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.estimatedAssetCount) {
                KTPHAlbum *album = [[KTPHAlbum alloc] initWithAssetCollection:obj mediaType:mediaType];;
                [album setIndexPath:[NSIndexPath indexPathForRow:cameraArray.count + idx inSection:0]];
                [cameraArray addObject:album];
            }
        }];
        
       [cameraResult addConstructionData: cameraArray];
        
        return @[cameraResult];
    }
}

+(NSArray<KTFetchResult *> *)fetchResultsForAlbum:(id<KTAlbumProtocol>)album{
    KTFetchResult *albumResult = [[KTFetchResult alloc] init];
    NSMutableArray *albumArray = [[NSMutableArray alloc] init];
    [album enumerateAssetsUsingBlock:^(id<KTAssetProtocol> result, NSUInteger index, BOOL *stop) {
        [albumArray addObject:result];
    }];
    [albumResult addConstructionData:albumArray];
    return @[albumResult];
}
@end
