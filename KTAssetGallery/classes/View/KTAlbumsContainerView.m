//
//  KTAlbumsContainerView.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/3.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTAlbumsContainerView.h"

@implementation KTAlbumsContainerView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UITableView *tableView = [[UITableView alloc] init];
        [self addSubview:tableView];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[tableView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[tableView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)]];
        [tableView setShowsVerticalScrollIndicator:NO];
        _tableView = tableView;
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame inContext:(CGContextRef) context{
    CGFloat R0 = 0xe6/255.0, G0 = 0xe4/255.0, B0 =  0xe4/255.0;
    
    CGFloat arrowSize = 8.f;
    CGFloat cornerRadius = 8.f;
    
    UIColor *tintColor = [UIColor whiteColor];
    if (tintColor) {
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    const CGFloat kEmbedFix = 3.f;
    
    const CGFloat arrowXM = frame.size.width/2;
    const CGFloat arrowX0 = arrowXM - arrowSize;
    const CGFloat arrowX1 = arrowXM + arrowSize;
    const CGFloat arrowY0 = Y0;
    const CGFloat arrowY1 = Y0 + arrowSize + kEmbedFix;
    
    [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
    
    [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
    
    Y0 += arrowSize;
    
    [arrowPath fill];
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:cornerRadius];
    [borderPath fill];
}
@end
