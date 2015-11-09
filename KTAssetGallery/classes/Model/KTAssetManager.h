//
//  KTAssetManager.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/6.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTAlbumProtocol.h"
#import "KTFetchResult.h"

typedef NS_ENUM(NSInteger, KTAuthorizationStatus) {
    KTAuthorizationStatusNotDetermined = 0,
    KTAuthorizationStatusRestricted,
    KTAuthorizationStatusDenied,
    KTAuthorizationStatusAuthorized
};

@interface KTAssetManager : NSObject
+ (KTAuthorizationStatus)authorizationStatus;
+ (void)requestAuthorization:(void (^)(KTAuthorizationStatus status))handler;
+ (NSArray<KTFetchResult *> *)albumFetchResultsWithMediaType:(KTAssetMediaType)mediaType;
+ (NSArray<KTFetchResult *> *)fetchResultsForAlbum:(id<KTAlbumProtocol>)album;
@end
