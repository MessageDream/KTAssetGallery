//
//  KTALAssets.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTALAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface KTALAsset ()
{
    NSIndexPath *_indexPath;
}
@property(strong,nonatomic)ALAsset *asset;
@end

@implementation KTALAsset
-(instancetype)initWithALAsset:(ALAsset *)asset{
    if (self = [super init]) {
        self.asset = asset;
    }
    return self;
}

-(KTAssetMediaType)mediaType{
    NSString *type = [self.asset valueForProperty:ALAssetPropertyType];
    if ([type isEqualToString:ALAssetTypePhoto]) {
        return KTAssetMediaTypeImage;
    }else if([type isEqualToString:ALAssetTypeVideo]){
        return KTAssetMediaTypeVideo;
    }else{
        return KTAssetMediaTypeUnknown;
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(NSIndexPath *)indexPath{
    return _indexPath;
}

- (void)thumbnail:(void (^)(UIImage *image))imageCallback{
    imageCallback([UIImage imageWithCGImage:[self.asset thumbnail]]);
}

- (void)aspectRatioThumbnail:(void (^)(UIImage *image))imageCallback;{
    return  imageCallback([UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]]);
}

//- (long long)size{
//    return [self.asset.defaultRepresentation size];
//}

- (void)orientation:(void (^)(KTAssetOrientation orientation))orientationCallback{
    orientationCallback((KTAssetOrientation)[self.asset valueForProperty:ALAssetPropertyOrientation]);
}

- (void)fullResolutionImage:(void (^)(UIImage *image))imageCallback;{
    return  imageCallback([UIImage imageWithCGImage:[self.asset.defaultRepresentation fullResolutionImage]]);
}

- (void)fullScreenImage:(void (^)(UIImage *image))imageCallback;{
    return  imageCallback([UIImage imageWithCGImage:[self.asset.defaultRepresentation fullScreenImage]]);
}

- (void)url:(void (^)(NSURL *url))callback;{
    return callback([self.asset.defaultRepresentation url]);
}

- (void)filename:(void (^)(NSString *fileName))callback{
    callback([self.asset.defaultRepresentation filename]);
}

- (void)baseInfo:(void (^)(NSString *fileName, KTAssetOrientation orientation,NSTimeInterval duration,NSDate *creationDate,NSDate *modificationDate,CLLocation *location))callback{
    NSTimeInterval duration = 0;
    if (self.mediaType == KTAssetMediaTypeAudio || self.mediaType == KTAssetMediaTypeVideo) {
        duration = [[self.asset valueForProperty:ALAssetPropertyDuration] timestamp];
    }
    callback([self.asset.defaultRepresentation filename],
             (KTAssetOrientation)[self.asset valueForProperty:ALAssetPropertyOrientation],
             duration,
             [self.asset valueForProperty:ALAssetPropertyDate],
             [self.asset valueForProperty:ALAssetPropertyDate],
             [self.asset valueForProperty:ALAssetPropertyLocation]);
}

- (void)requestPlayerItemResultHandler:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))resultHandler{
    
}

- (void)requestExportSessionExportPreset:(NSString *)exportPreset resultHandler:(void (^)(AVAssetExportSession *exportSession, NSDictionary *info))resultHandler{
    
}

- (void)requestAVAssetResultHandler:(void (^)(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info))resultHandler{
    
}
@end
