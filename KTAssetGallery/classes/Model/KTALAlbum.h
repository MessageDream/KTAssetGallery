//
//  KTALAlbum.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTAlbumProtocol.h"
#import "KTIndexPathProtocol.h"

@class ALAssetsGroup;
@interface KTALAlbum : NSObject<KTAlbumProtocol,KTIndexPathProtocol>
-(instancetype)initWithALAssetsGroup:(ALAssetsGroup *)group;
@end
