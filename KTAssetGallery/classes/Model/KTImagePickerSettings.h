//
//  KTImagePickerSettings.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/5,
//  Copyright © 2015年 jayden, All rights reserved,
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KTSettingsProtocol.h"

@interface KTImagePickerSettings : NSObject<KTSettingsProtocol>
@property(assign,nonatomic)NSInteger maxNumberOfSelections;
@property(copy,nonatomic)NSString *selectionString;
@property(strong,nonatomic)UIColor *selectionFillColor;
@property(strong,nonatomic)UIColor *selectionStrokeColor;
@property(strong,nonatomic)UIColor *selectionShadowColor;
@property(strong,nonatomic)NSMutableDictionary<NSString * ,id> *selectionTextAttributes;
@property(copy,nonatomic)NSInteger (^cellsPerRow)(UIDeviceOrientation orientation);
@end
