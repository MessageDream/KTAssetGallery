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

- (void)CGImageWithOptions:(NSDictionary *)options callback:(void (^)(UIImage *))imageCallback{
    return  imageCallback([UIImage imageWithCGImage:[self.asset.defaultRepresentation CGImageWithOptions:options]]);
}

- (void)fullScreenImage:(void (^)(UIImage *image))imageCallback;{
    return  imageCallback([UIImage imageWithCGImage:[self.asset.defaultRepresentation fullScreenImage]]);
}

- (void)url:(void (^)(NSURL *url))callback;{
    return callback([self.asset.defaultRepresentation url]);
}

- (float)scale{
    return [self.asset.defaultRepresentation scale];
}

- (void)filename:(void (^)(NSString *fileName))callback{
    callback([self.asset.defaultRepresentation filename]);
}
@end
