//
//  KTReuseableScrollView.h
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTReuseableScrollViewCell;
@class KTReuseableScrollView;

typedef enum{
    KTReuseableScrollViewMarginTypeTop,
    KTReuseableScrollViewMarginTypeBottom,
    KTReuseableScrollViewMarginTypeLeft,
    KTReuseableScrollViewMarginTypeRight
} KTReuseableScrollViewMarginType;

@protocol KTReuseableScrollViewDateSource <NSObject>

@required

- (NSUInteger)numberOfCellInReuseableScrollView:(KTReuseableScrollView *)reuseableScrollView;
- (KTReuseableScrollViewCell *)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView atIndex:(NSUInteger)index;

@end

@protocol KTReuseableScrollViewDelegate <NSObject>
@optional
- (void)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView didSelectAtIndex:(NSUInteger)index;

- (CGFloat)reuseableScrollView:(KTReuseableScrollView *)reuseableScrollView marginForType:(KTReuseableScrollViewMarginType)type;
@end

@interface KTReuseableScrollView : UIScrollView

@property (nonatomic, weak) id <KTReuseableScrollViewDateSource>reuseableScrollViewDataSource;
@property (nonatomic, weak) id <KTReuseableScrollViewDelegate>reuseableScrollViewDelegate;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, assign) CGFloat margin;

- (void)reloadPageViews;
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)cellIdentifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
