//
//  KTAlbumCell.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTAlbumCell : UITableViewCell
@property(strong,nonatomic)UIImage *firstImage;
@property(strong,nonatomic)UIImage *secondImage;
@property(strong,nonatomic)UIImage *thirdImage;
@property(copy,nonatomic)NSString *title;
@end
