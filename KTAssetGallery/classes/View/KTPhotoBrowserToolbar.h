//
//  KTPhotoBrowserToolbar.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTSelectionView;

@protocol KTPhotoBrowserToolbarDelegate<NSObject>

-(void)back;

-(void)confirm;

-(void)save;

@end

@interface KTPhotoBrowserToolbar : UIView

// 所有的图片对象
@property (assign, nonatomic) NSUInteger totalCount;
@property (weak, nonatomic) UIButton *confimBtn;
@property (weak, nonatomic) UIButton *downloadBtn;

// 当前展示的图片索引
@property (assign, nonatomic) NSUInteger currentPhotoIndex;
@property (weak, nonatomic) UILabel *indexLabel;

@property (weak, nonatomic) KTSelectionView *selectionView;
@property (assign, nonatomic) id<KTPhotoBrowserToolbarDelegate> delegate;

- (void)setSelectLabelCount:(NSInteger)count;
@end