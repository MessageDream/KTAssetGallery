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

@interface KTPHAlbum : NSObject<KTAlbumProtocol,KTIndexPathProtocol>
-(instancetype)initWithAssetCollection:(id)collection mediaType:(KTAssetMediaType)mediaType;
@end
