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
#import "KTALAlbum.h"

@implementation KTAssetManager

+(ALAssetsLibrary *)defaultAssetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

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
    KTFetchResult *cameraResult = [[KTFetchResult alloc] init];
    NSMutableArray *cameraArray = [[NSMutableArray alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < __IPHONE_8_0/10000){
        
        ALAssetsLibrary *library = [self defaultAssetsLibrary];;
       
        __block NSInteger idx = 0;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([group numberOfAssets]) {
                    KTALAlbum *album = [[KTALAlbum alloc] initWithAssetCollection:group mediaType:mediaType];
                    [album setIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                    idx++;
                    [cameraArray addObject:album];
                }
                
            } failureBlock:^(NSError *error) {
                idx++;
            }];
           
            while (idx == 0) {
                
            }
        });
        
        while (idx == 0) {
            
        }
    }else{
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        PHFetchResult<PHAssetCollection *> *cameraCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:option];
        PHFetchResult<PHAssetCollection *> *albumCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:option];
        
        [cameraCollectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KTPHAlbum *album = [[KTPHAlbum alloc] initWithAssetCollection:obj mediaType:mediaType];
            [album setIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            [cameraArray addObject:album];
        }];
        
        [albumCollectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.estimatedAssetCount) {
                KTPHAlbum *album = [[KTPHAlbum alloc] initWithAssetCollection:obj mediaType:mediaType];;
                [album setIndexPath:[NSIndexPath indexPathForRow:cameraArray.count + idx inSection:0]];
                [cameraArray addObject:album];
            }
        }];
    }
    
    [cameraResult setData: cameraArray];
     return @[cameraResult];
}

+(NSArray<KTFetchResult *> *)fetchResultsForAlbum:(id<KTAlbumProtocol>)album{
    KTFetchResult *albumResult = [[KTFetchResult alloc] init];
    NSMutableArray *albumArray = [[NSMutableArray alloc] init];
    [album enumerateAssetsUsingBlock:^(id<KTAssetProtocol> result, NSUInteger index, BOOL *stop) {
        [albumArray addObject:result];
    }];
    [albumResult setData:albumArray];
    return @[albumResult];
}
@end
