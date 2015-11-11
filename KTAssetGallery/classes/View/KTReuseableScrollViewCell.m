//
//  KTReuseableScrollViewCell.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTReuseableScrollViewCell.h"

@implementation KTReuseableScrollViewCell
//将内容视图添加到cell中

- (void)setPageViewInCell:(UIView *)pageView{
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self addSubview:pageView];
    
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *pageView =  self.subviews[0];
    pageView.frame = self.bounds;
}
@end
