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

@interface UIViewController(KTAssetGallery)
@property(weak,nonatomic)UIViewController *kt_vc;

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                       settings:(KTImagePickerSettings *) settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                     whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                       deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
              tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                         cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                       settings:(KTImagePickerSettings *) settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
              tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                         cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                       settings:(KTImagePickerSettings *) settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                         cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                       settings:(KTImagePickerSettings *) settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock;

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                              settings:(KTImagePickerSettings *) settings
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                            whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                              deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
                     tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                                cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete;

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                              settings:(KTImagePickerSettings *) settings
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                     tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                                cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete;

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                              settings:(KTImagePickerSettings *) settings
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                                cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete;

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                              settings:(KTImagePickerSettings *) settings
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete;

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete;
@end
