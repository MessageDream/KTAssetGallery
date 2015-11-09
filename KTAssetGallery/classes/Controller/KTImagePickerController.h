//
//  KTImagePickerController.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/5.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTSettingsProtocol.h"
#import "KTAssetProtocol.h"
#import "KTAssetManager.h"

@interface KTImagePickerController : UINavigationController<KTSettingsProtocol>
@property(assign,nonatomic)KTAssetMediaType mediaType;
+ (KTImagePickerController *)imagePickerControllerWithHasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock  tapToPreview:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewBlock cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets))finishBlock;

+ (void)authorize:(UIViewController *)fromViewController completion:(void (^)())completion;
@end
