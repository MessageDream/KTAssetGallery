//
//  KTPhotoBrowserBottomToolbar.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPhotoBrowserBottomToolbar;
@class KTSelectionView;

@protocol KTPhotoBrowserBottomToolbarDelegate<NSObject>

-(BOOL)shouldSelectedAtIndex:(NSInteger)index;
-(BOOL)shouldDeSelectedAtIndex:(NSInteger)index;

-(void)didSelectedAtIndex:(NSInteger)index;
-(void)didDeSelectedAtIndex:(NSInteger)index;

-(void)selectedFailedAtIndex:(NSInteger)index;

@end

@interface KTPhotoBrowserBottomToolbar : UIView
{
    BOOL _selected;
}
@property (assign, nonatomic) NSInteger currentPhotoIndex;
@property (assign, nonatomic) BOOL selected;
@property (weak, nonatomic) KTSelectionView *selectionView;
@property (assign, nonatomic) id<KTPhotoBrowserBottomToolbarDelegate> delegate;
@end
