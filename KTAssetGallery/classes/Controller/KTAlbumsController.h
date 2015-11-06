//
//  AlbumController.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAlbumProtocol.h"
@class KTFetchResult;
@interface KTAlbumsController : UIViewController
-(instancetype)initWithAlbumChangedBlock:(void (^)(id<KTAlbumProtocol> album))block;
- (void)showInViewController:(UIViewController *)viewController fromView:(UIView *)fromView;
@end
