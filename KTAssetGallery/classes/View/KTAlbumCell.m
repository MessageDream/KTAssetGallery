//
//  KTAlbumCell.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTAlbumCell.h"
@interface KTAlbumCell()
@property(weak,nonatomic)UIImageView *firstImageView;
@property(weak,nonatomic)UIImageView *secondImageView;
@property(weak,nonatomic)UIImageView *thirdImageView;
@property(weak,nonatomic)UILabel *titleLabel;
@end
@implementation KTAlbumCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *imageContainer = [[UIView alloc] init];
        [self.contentView addSubview:imageContainer];
        imageContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[imageContainer(==79)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageContainer)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[imageContainer(==79)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageContainer)]];
        
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.5 constant:79]];
        
//         [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:imageContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        
       
        UIImageView *tView = [[UIImageView alloc] init];
        [imageContainer addSubview:tView];
         _thirdImageView = tView;
        _thirdImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_thirdImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_thirdImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thirdImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdImageView)]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_thirdImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_thirdImageView)]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_thirdImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-5.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_thirdImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-5.0]];
        
        UIImageView *sView = [[UIImageView alloc] init];
        [imageContainer addSubview:sView];
        _secondImageView = sView;
        _secondImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_secondImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_secondImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondImageView)]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_secondImageView)]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_secondImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-5.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_secondImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-5.0]];
        
        UIImageView *fView = [[UIImageView alloc] init];
        [imageContainer addSubview:fView];
        _firstImageView = fView;
        _firstImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_firstImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_firstImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstImageView)]];
        
        [imageContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_firstImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_firstImageView)]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_firstImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-5.0]];
        
        [imageContainer addConstraint:[NSLayoutConstraint constraintWithItem:_firstImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-5.0]];
        
        for (UIImageView *imageView in @[_firstImageView, _secondImageView, _thirdImageView]) {
            imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
            imageView.layer.shadowRadius = 1.0;
            imageView.layer.shadowOffset = CGSizeMake(0.5, -0.5);
            imageView.layer.shadowOpacity = 1.0;
        }
        
       UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageContainer attribute:NSLayoutAttributeRight multiplier:1.0f constant:8.0f]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-8.0f]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:8.0f]];
        
    }
    return self;
}


-(void)setFirstImage:(UIImage *)firstImage{
    _firstImage = firstImage;
    _firstImageView.image = firstImage;
}

-(void)setSecondImage:(UIImage *)secondImage{
    _secondImage = secondImage;
    _secondImageView.image = secondImage;
}

-(void)setThirdImage:(UIImage *)thirdImage{
    _thirdImage = thirdImage;
    _thirdImageView.image = thirdImage;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
@end
