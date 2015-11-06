//
//  KTFetchResult.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KTFetchResult : NSObject

@property(assign,nonatomic,readonly)NSInteger count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSInteger)indexOfObject:(id)obj;
- (void)addConstructionData:(NSArray *)data;
@end
