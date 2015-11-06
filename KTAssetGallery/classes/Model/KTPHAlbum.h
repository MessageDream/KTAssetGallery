//
//  KTPHAlbum.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTAlbumProtocol.h"
#import "KTIndexPathProtocol.h"

@class PHAssetCollection;

@interface KTPHAlbum : NSObject<KTAlbumProtocol,KTIndexPathProtocol>
-(instancetype)initWithPHAssetCollection:(PHAssetCollection *)collection;
@end
