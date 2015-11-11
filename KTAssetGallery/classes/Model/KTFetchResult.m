//
//  KTFetchResult.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTFetchResult.h"

@interface KTFetchResult()
@property(strong,nonatomic)NSArray *constructionData;
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

-(void)setData:(NSArray *)data{
    self.constructionData = data;
}
@end
