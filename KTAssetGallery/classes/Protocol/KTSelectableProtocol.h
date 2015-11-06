//
//  KTSelectableProtocol.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/24.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTSelectableProtocol <NSObject>
@required
-(void)selectObjectAtIndexPath:(NSIndexPath *)indexPath;
-(void)deselectObjectAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)selectionCount;
-(NSArray<NSIndexPath *> *)selectedIndexPaths;
-(NSArray *)selections;
-(BOOL)isSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end

