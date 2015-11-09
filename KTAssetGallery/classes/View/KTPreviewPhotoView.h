//
//  KTPreviewPhotoView.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPreviewPhotoViewDelegate <NSObject>


@end


@interface KTPreviewPhotoView : UIImageView
@property(weak,nonatomic)id<KTPreviewPhotoViewDelegate> photoViewDelegate;
@end
