//
//  UIViewController+KTAssertGallery.h
//  KTAssertGallery
//
//  Created by Jayden Zhao on 15/11/6.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAssetProtocol.h"

@class KTImagePickerSettings;

@interface UIViewController(KTAssertGallery)
@property(weak,nonatomic)UIViewController *kt_vc;

-(void)kt_imagePickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                       settings:(KTImagePickerSettings *) settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                     whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                       deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
                         cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;
@end
