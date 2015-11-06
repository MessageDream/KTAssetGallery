//
//  KTSelectableProtocol.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTSettingsProtocol <NSObject>
@property(assign,nonatomic)NSInteger maxNumberOfSelections;
@property(copy,nonatomic)NSString *selectionString;
@property(strong,nonatomic)UIColor *selectionFillColor;
@property(strong,nonatomic)UIColor *selectionStrokeColor;
@property(strong,nonatomic)UIColor *selectionShadowColor;
@property(strong,nonatomic)NSMutableDictionary<NSString * ,id> *selectionTextAttributes;
@property(copy,nonatomic)NSInteger (^cellsPerRow)(UIInterfaceOrientationMask orientation);
@end

