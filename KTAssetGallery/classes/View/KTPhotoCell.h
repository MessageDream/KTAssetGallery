//
//  KTPhotoCell.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KTPhotoCellDelegate
@required
- (BOOL)photoCellShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)photoCellShouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)photoCellDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)photoCellDidDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface KTPhotoCell : UICollectionViewCell
@property(strong,nonatomic)UIImage *image;
@property(strong,nonatomic)NSIndexPath *indexPath;
@property(assign,nonatomic,getter=isKtSelected)BOOL ktSelected;
@property(weak,nonatomic)id<KTPhotoCellDelegate> delegate;
@end
