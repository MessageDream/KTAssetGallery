//
//  KTPhotoBrowserToolbar.m
//  KTAssetGallery
//
//  Created by Jayden Zhao on 15/11/10.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotoBrowserToolbar.h"
#import "KTSelectionView.h"

@implementation KTPhotoBrowserToolbar

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* _tmpView = [super hitTest:point withEvent:event];
    if ([_tmpView isKindOfClass:[KTPhotoBrowserToolbar class]]) {
        return nil;
    }
    return _tmpView;
}

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UIButton *backbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbutton addTarget:self action:@selector(click_back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backbutton];
        backbutton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[backbutton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backbutton)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[backbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backbutton)]];
        
        UIButton *confimbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [confimbutton setTitle:@"确定" forState:UIControlStateNormal];
        
        [confimbutton addTarget:self action:@selector(click_confirm) forControlEvents:UIControlEventTouchUpInside];
        confimbutton.enabled =  NO;
        [self addSubview:confimbutton];
        self.confimBtn = confimbutton;
        confimbutton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[confimbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(confimbutton)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[confimbutton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(confimbutton)]];
        
        KTSelectionView *selectionView = [[KTSelectionView alloc] init];
        selectionView.selectionString = @"0";
        selectionView.selected = YES;
        
        [self addSubview:selectionView];
        self.selectionView = selectionView;
        
        selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[selectionView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectionView]-12-[confimbutton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectionView,confimbutton)]];
        
        [selectionView addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:selectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.backgroundColor = [UIColor clearColor];
        indexLabel.textColor  =[UIColor whiteColor];
        indexLabel.text = @"0000000000000";
        [indexLabel sizeToFit];
        indexLabel.frame =CGRectMake(0, 0, indexLabel.bounds.size.width, indexLabel.bounds.size.height);
        [self addSubview:indexLabel];
        self.indexLabel= indexLabel;
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indexLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:indexLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[indexLabel]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(indexLabel)]];
        
        //        UIButton *downloadBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        //        downloadBtn.hidden = YES;
        //        [self addSubview:downloadBtn];
        //        self.downloadBtn = downloadBtn;
    }
    return self;
}

-(void)click_confirm{
    [_delegate confirm];
}
-(void)click_back{
    [_delegate back];
}

-(void)click_save{
    [_delegate save];
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex{
    _currentPhotoIndex = currentPhotoIndex;
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _totalCount];
}

- (void)setSelectLabelCount:(NSInteger)count{
    _selectionView.selectionString = [NSString stringWithFormat:@"%i", count];
}

@end
