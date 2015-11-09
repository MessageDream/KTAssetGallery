//
//  KTPhotoBrowserViewController.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/9.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPhotoBrowserDelegate;

@interface KTPhotoBrowserViewController : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<KTPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property(nonatomic,assign) BOOL hideHUD;

@property(nonatomic) BOOL savePhotoImage;


@property(nonatomic,assign) BOOL hideConfimBtn;
// 显示
- (void)show;

-(void)albumSelected:(NSInteger)count list:(NSArray *)list;
@end

@protocol KTPhotoBrowserDelegate <NSObject>

-(void)CellPhotoImageReload;

-(void)NewPostImageReload:(NSInteger)ImageIndex;

@optional
// 切换到某一页图片
- (void)back_photoBrowser:(KTPhotoBrowserViewController *)photoBrowser selectPhotos:(NSArray *)photos;

- (void)photoBrowser:(KTPhotoBrowserViewController *)photoBrowser selectPhotos:(NSArray *)photos;

@end
