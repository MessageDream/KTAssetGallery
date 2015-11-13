//
//  KTPHAssets.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTPHAsset.h"
#import <Photos/Photos.h>

@interface KTPHAsset ()
{
    NSIndexPath *_indexPath;
}
@property(strong,nonatomic)PHAsset *asset;
@end

@implementation KTPHAsset
-(instancetype)initWithPHAsset:(PHAsset *)asset{
    if (self = [super init]) {
        self.asset = asset;
    }
    return self;
}

-(KTAssetMediaType)mediaType{
    return (KTAssetMediaType)self.asset.mediaType;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(NSIndexPath *)indexPath{
    return _indexPath;
}

- (void)thumbnail:(void (^)(UIImage *image))imageCallback;{
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(79, 79) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        imageCallback(result);
    }];
}

- (void)aspectRatioThumbnail:(void (^)(UIImage *image))imageCallback;{
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(79, 79) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        imageCallback(result);
    }];
}

//- (long long)size{
//    [[PHImageManager defaultManager] requestImageDataForAsset: self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//        float imageSize = imageData.length;
//        //convert to Megabytes
//        imageSize = imageSize/(1024*1024);
//        NSLog(@"%f",imageSize);
//    }];
//}

- (void)fullResolutionImage:(void (^)(UIImage *image))imageCallback;{
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        imageCallback([UIImage imageWithData:imageData]);
    }];
}


- (void)fullScreenImage:(void (^)(UIImage *image))imageCallback;{
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        imageCallback(result);
    }];
}

- (void)url:(void (^)(NSURL *url))callback;{
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if ([info objectForKey:@"PHImageFileURLKey"]) {
            NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
            callback([path absoluteURL]);
        }
    }];
}

- (void)orientation:(void (^)(KTAssetOrientation orientation))orientationCallback{
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        orientationCallback((KTAssetOrientation)orientation);
    }];
}

- (void)filename:(void (^)(NSString *fileName))callback{
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if ([info objectForKey:@"PHImageFileURLKey"]) {
            NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
            NSString *pathString = [path absoluteString];
            callback([pathString lastPathComponent]);
        }
    }];
}

- (void)baseInfo:(void (^)(NSString *fileName, KTAssetOrientation orientation,NSTimeInterval duration,NSDate *creationDate,NSDate *modificationDate,CLLocation *location))callback{
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if ([info objectForKey:@"PHImageFileURLKey"]) {
            NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
            NSString *pathString = [path absoluteString];
            NSString *fileName = [pathString lastPathComponent];
            callback(fileName,
                     (KTAssetOrientation)orientation,
                     self.asset.duration,
                     self.asset.creationDate,
                     self.asset.modificationDate,
                     self.asset.location);
        }
    }];
}

- (void)requestPlayerItemResultHandler:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))resultHandler{
    
}

- (void)requestExportSessionExportPreset:(NSString *)exportPreset resultHandler:(void (^)(AVAssetExportSession *exportSession, NSDictionary *info))resultHandler{
    
}

- (void)requestAVAssetResultHandler:(void (^)(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info))resultHandler{
    
}
@end
