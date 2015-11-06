//
//  KTPhotosController.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAssetProtocol.h"
#import "KTSettingsProtocol.h"

@interface KTPhotosController : UIViewController
@property(weak,nonatomic)id<KTSettingsProtocol> settings;
@property(strong,nonatomic)NSArray<id<KTAssetProtocol>> *lastTimeSelections;
@property(copy,nonatomic)void (^selectionBlock)(id<KTAssetProtocol> asset);
@property(copy,nonatomic)void (^deSelectionBlock)(id<KTAssetProtocol> asset);
@property(copy,nonatomic)void (^cancelBlock)(NSArray<id<KTAssetProtocol>> *assets);
@property(copy,nonatomic)void (^finishBlock)(NSArray<id<KTAssetProtocol>> *assets);
@end
