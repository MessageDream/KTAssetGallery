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
#import "KTAssetProtocol.h"

typedef NS_ENUM(NSInteger,KTPhotoBrowserMode){
   KTPhotoBrowserModeDefault,
   KTPhotoBrowserModeAlbum,
   KTPhotoBrowserModeAssets
};

@class KTPhotoBrowserViewController;

@protocol KTPhotoBrowserDelegate <NSObject>
- (void)backFromViewController:(KTPhotoBrowserViewController *)vc currentPhotoIndex:(NSInteger)index;
@end


@interface KTPhotoBrowserViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<KTPhotoBrowserDelegate> delegate;
@property (strong, nonatomic) id<KTSelectableProtocol> dataSource;
@property (strong, nonatomic) id<KTSettingsProtocol> settings;
@property (nonatomic, strong) NSArray<id<KTAssetProtocol>> *photos;
@property (nonatomic, strong) NSArray<NSString *> *photoUrls;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property(nonatomic) BOOL savePhotoImage;

-(instancetype)initWithBrowserMode:(KTPhotoBrowserMode)mode;
@end


