//
//  KTPhotoBrowserToolbar.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTSelectionView.h"

@protocol KTPhotoBrowserToolbarDelegate<NSObject>

-(void)back;

-(void)confirm;

-(void)save;

@end

@interface KTPhotoBrowserToolbar : UIView
@property (weak, nonatomic, readonly) UIButton *backButton;
@property (weak, nonatomic, readonly) UIButton *downloadButton;
@property (weak, nonatomic, readonly) UIButton *confimButton;
@property (weak, nonatomic, readonly) KTSelectionView *selectionView;
// 所有的图片对象
@property (assign, nonatomic) NSUInteger totalCount;
// 当前展示的图片索引
@property (assign, nonatomic) NSUInteger currentPhotoIndex;
@property (assign, nonatomic) id<KTPhotoBrowserToolbarDelegate> delegate;

- (void)setSelectLabelCount:(NSInteger)count;
@end
