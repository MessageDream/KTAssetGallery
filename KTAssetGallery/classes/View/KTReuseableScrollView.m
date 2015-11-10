//
//  KTReuseableScrollView.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTReuseableScrollView.h"
#import "KTReuseableScrollViewCell.h"

#define KTReuseableScrollViewDefaultMargin 0

@interface KTReuseableScrollView()
@property (nonatomic, strong) NSMutableArray *pageViewFrames;
@property (nonatomic, strong) NSMutableDictionary *displayingPageViews;
@property (nonatomic, strong) NSMutableSet *reusePageViews;
@property (nonatomic, strong) NSMutableDictionary *registedCellClassesDic;
@end

@implementation KTReuseableScrollView

- (NSMutableArray *)pageViewFrames{
    
    if (!_pageViewFrames) {
        _pageViewFrames = [NSMutableArray array];
    }
    
    return _pageViewFrames;
    
}

- (NSMutableDictionary *)displayingPageViews{
    if (!_displayingPageViews) {
        _displayingPageViews = [NSMutableDictionary dictionary];
    }
    return _displayingPageViews;
}


- (NSMutableSet *)reusePageViews{
    if (!_reusePageViews) {
        _reusePageViews = [NSMutableSet set];
    }
    return _reusePageViews;
}

-(NSMutableDictionary *)registedCellClassesDic{
    if (!_registedCellClassesDic) {
        _registedCellClassesDic = [NSMutableDictionary dictionary];
    }
    return _registedCellClassesDic;
}

-(void)setReuseableScrollViewDataSource:(id<KTReuseableScrollViewDateSource>)reuseableScrollViewDataSource{
    _reuseableScrollViewDataSource = reuseableScrollViewDataSource;
    [self reloadPageViews];
}

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
}

- (void)setMargin:(CGFloat)margin{
    _margin = margin;
}

- (void)cleanDate{
    [self.displayingPageViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingPageViews removeAllObjects];
    [self.pageViewFrames removeAllObjects];
    [self.reusePageViews removeAllObjects];
}

- (void)reloadPageViews{
    
    [self cleanDate];
    
    NSUInteger numberOfCells = [self.reuseableScrollViewDataSource numberOfCellInReuseableScrollView:self];
    
    if (numberOfCells == 0 || self.frame.size.width == 0 || self.frame.size.height == 0) return;
    
    //计算cell的边距
    CGFloat topMargin = [self marginForType:KTReuseableScrollViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:KTReuseableScrollViewMarginTypeBottom];
    CGFloat leftMargin = [self marginForType:KTReuseableScrollViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:KTReuseableScrollViewMarginTypeRight];
    
    //计算cell的frame
    CGFloat cellWidth = self.frame.size.width - leftMargin - rightMargin;
    CGFloat cellHeght = self.frame.size.height - topMargin - bottomMargin;
    CGFloat cellY = topMargin;
    
    for (int i = 0; i < numberOfCells; i++) {
        CGFloat cellX = i * (self.frame.size.width) + leftMargin;
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeght);
        NSValue *cellFrameValue = [NSValue valueWithCGRect:cellFrame];
        
        [self.pageViewFrames addObject:cellFrameValue];
    }
    self.contentSize = CGSizeMake(self.frame.size.width * numberOfCells, 0);
}

-(void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)cellIdentifier{
    if (![self.registedCellClassesDic.allKeys containsObject:cellIdentifier]) {
        [self.registedCellClassesDic setObject:cellClass forKey:cellIdentifier];
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    if (![self.registedCellClassesDic.allKeys containsObject:identifier]) {
        return nil;
    }
    
    Class cls = [self.registedCellClassesDic objectForKey:identifier];
    __block KTReuseableScrollViewCell *reusableCell = nil;
    [self.reusePageViews enumerateObjectsUsingBlock:^(KTReuseableScrollViewCell *cell, BOOL *stop) {
        if ([cell isKindOfClass:cls]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        [self.reusePageViews removeObject:reusableCell];
    }
    
    if (!reusableCell) {
        reusableCell = [[cls alloc] init];
    }
    return reusableCell;
}

- (CGFloat)marginForType:(KTReuseableScrollViewMarginType)type{
    if ([self.reuseableScrollViewDelegate respondsToSelector:@selector(reuseableScrollView: marginForType:)]) {
        return [self.reuseableScrollViewDelegate reuseableScrollView:self marginForType:type];
    } else {
        return KTReuseableScrollViewDefaultMargin;
    }
}

/**
 *  判断cell是否显示在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame{
    
    return (CGRectGetMaxX(frame) > self.contentOffset.x) &&
    (CGRectGetMinX(frame) < self.contentOffset.x + self.bounds.size.width);
}


//注意：一开始此方法会被调用两次，在reloadPageView后会被调用一次，是第一次，最后还会被吊用一次

//拽动期间 displayingPageViews 中最多两个cell，因为最多显示两个cell,所以在打印的时候会出现相同的情况输出多次

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSUInteger numberOfCells = self.pageViewFrames.count;
    
    for (int i = 0; i < numberOfCells; i++) {
        
        CGRect cellFrame = [self.pageViewFrames[i] CGRectValue];
        
        //记录当前显示的cell，当显示到下一个cell时，移除上一次的cell
        
        KTReuseableScrollViewCell *cell = self.displayingPageViews[@(i)];
        
        //查看cellFrame与self.contentOffSet.x
        
        if ([self isInScreen:cellFrame]) {
            
            if (cell == nil) {
                cell = [self.reuseableScrollViewDataSource reuseableScrollView:self atIndex:i];
                cell.frame = cellFrame;
                [cell layoutIfNeeded];
                [self addSubview:cell];
                self.displayingPageViews[@(i)] = cell;
                return;
            }
            
        }else{
            
            //移除的cell需要达到两个条件，第一 cell不在屏幕中，第二 cell是缓存在displayingPageViews
            
            if (cell) {
                
                // 从scrollView和字典中移除
                [cell removeFromSuperview];
                
                [self.displayingPageViews removeObjectForKey:@(i)];
                
                // 将消失的cell存放进缓存池
                [self.reusePageViews addObject:cell];
            }
            
        }
    }
}

@end
