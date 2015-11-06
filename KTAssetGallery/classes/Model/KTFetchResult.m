//
//  KTFetchResult.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTFetchResult.h"

@interface KTFetchResult()
@property(strong,nonatomic)NSMutableArray *constructionData;
@end

@implementation KTFetchResult
-(NSInteger)count{
    return self.constructionData.count;
}

-(id)objectAtIndex:(NSUInteger)index{
    return self.constructionData[index];
}

-(NSInteger)indexOfObject:(id)obj{
    return [self.constructionData indexOfObject:obj];
}

-(void)addConstructionData:(NSArray *)data{
    self.constructionData = [[NSMutableArray alloc] initWithArray:data];
}
@end
