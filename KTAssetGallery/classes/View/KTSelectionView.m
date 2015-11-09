//
//  KTSelectionView.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTSelectionView.h"
#import "KTImagePickerSettings.h"
@interface KTSelectionView()
@property(strong,nonatomic)KTImagePickerSettings *settings;
@end

@implementation KTSelectionView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _settings = [[KTImagePickerSettings alloc] init];
        _selectionString = _settings.selectionString;
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    
    //// Shadow Declarations
    CGSize shadow2Offset = CGSizeMake(0.f, -0.f);
    CGFloat shadow2BlurRadius = 2.5f;
    
    //// Frames
    CGRect checkmarkFrame = self.bounds;
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(checkmarkFrame) + 3, CGRectGetMinY(checkmarkFrame) + 3, CGRectGetWidth(checkmarkFrame) - 6, CGRectGetHeight(checkmarkFrame) - 6);
    
    //// CheckedOval Drawing
    UIBezierPath* checkedOvalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.0 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.0 + 0.5), floor(CGRectGetWidth(group) * 1.0 + 0.5) - floor(CGRectGetWidth(group) * 0.0 + 0.5), floor(CGRectGetHeight(group) * 1.0 + 0.5) - floor(CGRectGetHeight(group) * 0.0 + 0.5))];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, self.settings.selectionShadowColor.CGColor);
    if (self.selected) {
        [self.settings.selectionFillColor setFill];
    }else{
        [[UIColor clearColor] setFill];
    }
   
    [checkedOvalPath fill];
    CGContextRestoreGState(context);
    
    [self.settings.selectionStrokeColor setStroke];
    checkedOvalPath.lineWidth = 1;
    [checkedOvalPath stroke];
    
    //// Bezier Drawing (Picture Number)
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self.settings.selectionTextAttributes setObject:[UIFont boldSystemFontOfSize:self.bounds.size.height/1.5] forKey:NSFontAttributeName];
    CGSize size = [self.selectionString sizeWithAttributes:self.settings.selectionTextAttributes];
    
    [self.selectionString drawInRect:CGRectMake(CGRectGetMidX(checkmarkFrame) - size.width / 2.0,
                                          CGRectGetMidY(checkmarkFrame) - size.height / 2.0,
                                          size.width,
                                                size.height) withAttributes: self.settings.selectionTextAttributes];
}
@end
