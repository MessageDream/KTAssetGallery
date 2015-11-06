//
//  KTPhotoCell.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTPhotoCell.h"
#import "KTSelectionView.h"
@interface KTPhotoCell()
{
    BOOL _ktSelected;
}
@property(weak,nonatomic)UIView *selectionOverlayView;
@property(weak,nonatomic)UIImageView *imageView;
@property(weak,nonatomic)KTSelectionView  *selectionView;
@end
@implementation KTPhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imageView = imageView;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        
        UIView *overlayView = [[UIView alloc] init];
        overlayView.backgroundColor = [UIColor whiteColor];
        overlayView.alpha = 0.0f;
        [self addSubview:overlayView];
        _selectionOverlayView = overlayView;
        _selectionOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(overlayView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(overlayView)]];
        
        KTSelectionView *selectionView = [[KTSelectionView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelectView:)];
        tapGes.numberOfTapsRequired = 1;
        [selectionView addGestureRecognizer:tapGes];
    
        [self addSubview:selectionView];
        _selectionView = selectionView;
        _selectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f/3 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:selectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f/3 constant:0.0]];
    }
    return self;
}


-(void)clickSelectView:(UITapGestureRecognizer *)sender{
    if (!self.isKtSelected && [self.delegate photoCellShouldSelectItemAtIndexPath:self.indexPath]) {
        _ktSelected = YES;
        [self.delegate photoCellDidSelectItemAtIndexPath:self.indexPath];
        [self updateSelectedState:self.isKtSelected];
        return;
    }
    
    if (self.isKtSelected && [self.delegate photoCellShouldDeselectItemAtIndexPath:self.indexPath]) {
        _ktSelected = NO;
        [self.delegate photoCellDidDeselectItemAtIndexPath:self.indexPath];
        [self updateSelectedState:self.isKtSelected];
        return;
    }
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

-(BOOL)isKtSelected{
    return  _ktSelected;
}

-(void)setKtSelected:(BOOL)ktSelected{
    _ktSelected = ktSelected;
    [self updateAlpha:ktSelected];
}

-(void)updateSelectedState:(BOOL)selected{
    [UIView animateWithDuration:0.3 animations:^{
        [self updateAlpha:selected];
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)updateAlpha:(BOOL)selected {
    if (selected) {
        self.selectionOverlayView.alpha = 0.3;
    } else {
        self.selectionOverlayView.alpha = 0.0;
    }
    self.selectionView.selected = selected;
}
@end
