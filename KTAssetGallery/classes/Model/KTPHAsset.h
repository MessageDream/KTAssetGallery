//
//  KTPHAssets.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTAssetProtocol.h"
#import "KTIndexPathProtocol.h"
@class PHAsset;
@interface KTPHAsset : NSObject<KTAssetProtocol,KTIndexPathProtocol>
-(instancetype)initWithPHAsset:(PHAsset *)asset;
@end
