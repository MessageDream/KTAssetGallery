//
//  KTAssetsDelegate.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTAssetsDelegate <NSObject>
-(void)didUpdateAssets:(id)sender incrementalChange:(BOOL)incrementalChange insert:(NSArray *)insert delete:(NSArray *)delete andChange:(NSArray *)change;
@end