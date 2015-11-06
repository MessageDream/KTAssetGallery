//
//  KTAssetProtocol.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTAssetOrientation) {
    KTAssetOrientationUp ,            // default orientation
    KTAssetOrientationDown ,          // 180 deg rotation
    KTAssetOrientationLeft ,          // 90 deg CCW
    KTAssetOrientationRight ,         // 90 deg CW
    KTAssetOrientationUpMirrored ,    // as above but image mirrored along other axis. horizontal flip
    KTAssetOrientationDownMirrored ,  // horizontal flip
    KTAssetOrientationLeftMirrored ,  // vertical flip
    KTAssetOrientationRightMirrored , // vertical flip
};

@protocol KTAssetProtocol <NSObject>
@required
- (void)thumbnail:(void (^)(UIImage *image))imageCallback;
- (void)aspectRatioThumbnail:(void (^)(UIImage *image))imageCallback;

//- (long long)size;

- (void)fullResolutionImage:(void (^)(UIImage *image))imageCallback;

- (void)CGImageWithOptions:(NSDictionary *)options callback:(void (^)(UIImage *image))imageCallback;

- (void)fullScreenImage:(void (^)(UIImage *image))imageCallback;

- (void)url:(void (^)(NSURL *url))callback;

//- (NSDictionary *)metadata;
//
- (void)orientation:(void (^)(KTAssetOrientation orientation))orientationCallback;

- (float)scale;
- (void)filename:(void (^)(NSString *fileName))callback;
@end