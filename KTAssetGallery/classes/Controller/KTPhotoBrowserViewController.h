//
//  KTPhotoBrowserViewController.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTSelectableProtocol.h"
#import "KTSettingsProtocol.h"

typedef NS_ENUM(NSInteger,KTPhotoBrowserMode){
   KTPhotoBrowserModeDefault,
   KTPhotoBrowserModeAlbum
};

@protocol KTPhotoBrowserDelegate;

@interface KTPhotoBrowserViewController : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<KTPhotoBrowserDelegate> delegate;
@property (strong, nonatomic) id<KTSelectableProtocol> dataSource;
@property (strong, nonatomic) id<KTSettingsProtocol> settings;
@property (nonatomic, strong) NSMutableArray * photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property(nonatomic) BOOL savePhotoImage;

-(instancetype)initWithBrowserMode:(KTPhotoBrowserMode)mode;
@end

@protocol KTPhotoBrowserDelegate <NSObject>

-(void)cellPhotoImageReload;

-(void)newPostImageReload:(NSInteger)ImageIndex;

@optional
// 切换到某一页图片
- (void)back_photoBrowser:(KTPhotoBrowserViewController *)photoBrowser selectPhotos:(NSArray *)photos;

- (void)photoBrowser:(KTPhotoBrowserViewController *)photoBrowser selectPhotos:(NSArray *)photos;

@end
