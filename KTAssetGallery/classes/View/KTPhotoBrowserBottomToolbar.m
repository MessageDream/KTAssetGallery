//
//  KTPhotoBrowserBottomToolbar.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotoBrowserBottomToolbar.h"
#import "KTSelectionView.h"

@implementation KTPhotoBrowserBottomToolbar
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* _tmpView = [super hitTest:point withEvent:event];
    if ([_tmpView isKindOfClass:[KTPhotoBrowserBottomToolbar class]]) {
        return nil;
    }
    return _tmpView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        KTSelectionView *selectionView = [[KTSelectionView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectView:)];
        tapGes.numberOfTapsRequired = 1;
        [selectionView addGestureRecognizer:tapGes];
        
        [self addSubview:selectionView];
        self.selectionView = selectionView;
        selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [selectionView addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(BOOL)selected{
    return _selected;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    self.selectionView.selected = selected;
}

-(void)clickSelectView:(UITapGestureRecognizer *)sender{
    if (self.selected && [_delegate shouldDeSelectedAtIndex:_currentPhotoIndex]) {
        [_delegate didDeSelectedAtIndex:_currentPhotoIndex];
        self.selected = !self.selected;
        return;
    }
    
    if (!self.selected && [_delegate shouldSelectedAtIndex:_currentPhotoIndex]){
        [_delegate didSelectedAtIndex:_currentPhotoIndex];
        self.selected = !self.selected;
        return;
    }
}

@end


