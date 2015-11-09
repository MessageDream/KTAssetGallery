//
//  KTImagePickerSettings.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/5.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTImagePickerSettings.h"

@implementation KTImagePickerSettings
-(instancetype)init{
    if (self = [super init]) {
        _maxNumberOfSelections = 9;
        _selectionString = @"✓";
        _selectionFillColor = [[UIView alloc] init].tintColor;
        _selectionStrokeColor = [UIColor whiteColor];
        _selectionShadowColor = [UIColor blackColor];
        _selectionTextAttributes = [NSMutableDictionary dictionary];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [_selectionTextAttributes setObject:[UIFont boldSystemFontOfSize:35.f] forKey:NSFontAttributeName];
        [_selectionTextAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [_selectionTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        
        _cellsPerRow = ^ NSInteger (UIDeviceOrientation orientation){
            return UIDeviceOrientationIsLandscape(orientation)? 7:5;
            
        };
    }
    return self;
}
@end
