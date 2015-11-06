//
//  KTAssetsModel.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSelectableProtocol.h"
#import "KTAssetsDelegate.h"

@class KTFetchResult;

@interface KTAssetsModel : NSObject<KTSelectableProtocol>
@property(weak,nonatomic)id<KTAssetsDelegate> delegate;
@property(assign, nonatomic)NSInteger count;
-(instancetype)initWithResults:(NSArray *)results;
-(KTFetchResult *)objectAtIndex:(NSUInteger)index;
-(id)valueOfIndexPath:(NSIndexPath *)indexPath;
-(void)removeSelections;
-(void)setSelections:(NSArray *)selections;
@end
