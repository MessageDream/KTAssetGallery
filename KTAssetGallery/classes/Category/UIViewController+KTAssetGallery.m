//
//  UIViewController+KTAssertGallery.m
//  KTAssertGallery
//
//  Created by Jayden Zhao on 15/11/6.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "UIViewController+KTAssetGallery.h"
#import "KTImagePickerController.h"
#import "KTImagePickerSettings.h"
#import <objc/runtime.h>

@implementation UIViewController(KTAssetGallery)

-(void)setKt_vc:(UIViewController *)kt_vc{
    objc_setAssociatedObject(self, @selector(kt_vc), kt_vc, OBJC_ASSOCIATION_ASSIGN);
}

-(UIViewController *)kt_vc{
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)kt_assetPickerCustomShow:(void (^)(UIViewController *vc)) showBlock
                           hide:(void (^)(UIViewController *vc)) hideBlock
                      mediaType:(KTAssetMediaType)mediaType
                       settings:(KTImagePickerSettings *)settings
                    hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                     whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                       deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
                   tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                         cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                         finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock{
    
    KTImagePickerController *vc = [KTImagePickerController imagePickerControllerWithHasSelected:hasSelected
                                                                                     whenSelect:selectionBlock
                                                                                       deSelect:deSelectionBlock
                                                                                    tapToPreview:tapToPreviewVideoBlock
                                                                                         cancel:^(NSArray<id<KTAssetProtocol>> *assets) {
                                                                                             if (hideBlock) {
                                                                                                 hideBlock(self.kt_vc);
                                                                                                 self.kt_vc = nil;
                                                                                             }
                                                                                             if (cancelBlock) {
                                                                                                 cancelBlock(assets);
                                                                                             }
                                                                                         } finish:^(NSArray<id<KTAssetProtocol>> *assets) {
                                                                                             if (hideBlock) {
                                                                                                 hideBlock(self.kt_vc);
                                                                                                 self.kt_vc = nil;
                                                                                             }
                                                                                             
                                                                                             if (finishBlock) {
                                                                                                 finishBlock(assets);
                                                                                             }
                                                                                         }];
    
    
    [KTImagePickerController authorize:self completion:^{
        vc.mediaType = mediaType;
        vc.maxNumberOfSelections = settings.maxNumberOfSelections;
        vc.selectionString = settings.selectionString;
        vc.selectionFillColor = settings.selectionFillColor;
        vc.selectionStrokeColor = settings.selectionStrokeColor;
        vc.selectionShadowColor = settings.selectionShadowColor;
        vc.selectionTextAttributes = settings.selectionTextAttributes;
        vc.cellsPerRow = settings.cellsPerRow;
        self.kt_vc = vc;
        if (showBlock) {
            showBlock(vc);
        }
    }];
}

-(void)kt_assetPickerShowWithMediaType:(KTAssetMediaType)mediaType
                              settings:(KTImagePickerSettings *) settings
                           hasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                            whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                              deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
                          tapToPreviewVideo:(void (^)(id<KTAssetProtocol> asset)) tapToPreviewVideoBlock
                                cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                                finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) finishBlock
                              complete:(void (^)())complete{
    KTImagePickerController *vc = [KTImagePickerController imagePickerControllerWithHasSelected:hasSelected
                                                                                     whenSelect:selectionBlock
                                                                                       deSelect:deSelectionBlock
                                                                                    tapToPreview:tapToPreviewVideoBlock
                                                                                         cancel:^(NSArray<id<KTAssetProtocol>> *assets) {
                                                                                            
                                                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                                                             
                                                                                             if (cancelBlock) {
                                                                                                 cancelBlock(assets);
                                                                                             }
                                                                                         } finish:^(NSArray<id<KTAssetProtocol>> *assets) {
                                                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                                                             
                                                                                             if (finishBlock) {
                                                                                                 finishBlock(assets);
                                                                                             }
                                                                                         }];
    
    
    [KTImagePickerController authorize:self completion:^{
        vc.mediaType = mediaType;
        vc.maxNumberOfSelections = settings.maxNumberOfSelections;
        vc.selectionString = settings.selectionString;
        vc.selectionFillColor = settings.selectionFillColor;
        vc.selectionStrokeColor = settings.selectionStrokeColor;
        vc.selectionShadowColor = settings.selectionShadowColor;
        vc.selectionTextAttributes = settings.selectionTextAttributes;
        vc.cellsPerRow = settings.cellsPerRow;
        self.kt_vc = vc;
        [self presentViewController:vc animated:YES completion:complete];
    }];
 
}
@end
