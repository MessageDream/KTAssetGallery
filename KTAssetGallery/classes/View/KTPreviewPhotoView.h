//
//  KTPreviewPhotoView.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAssetProtocol.h"

@class KTPreviewPhotoView;
@protocol KTPreviewPhotoViewDelegate <NSObject>
- (void)photoViewSingleTap:(KTPreviewPhotoView *)photoView;
- (void)photoViewDidEndZoom:(KTPreviewPhotoView *)photoView;
- (void)photoViewImageFinishLoad:(KTPreviewPhotoView *)photoView photo:(UIImage *)photo;
@end


@interface KTPreviewPhotoView :UIScrollView<UIScrollViewDelegate>
@property(weak,nonatomic)id<KTPreviewPhotoViewDelegate> photoViewDelegate;
@property(copy,nonatomic)NSString *photoUrl;
@property(weak,nonatomic)id<KTAssetProtocol> asset;
@end
