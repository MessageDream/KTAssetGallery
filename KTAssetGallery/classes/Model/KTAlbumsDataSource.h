//
//  KTAlbumsDataSource.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/2.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KTAssetsDelegate.h"
#import "KTAlbumProtocol.h"
#import "KTSelectableProtocol.h"

@interface KTAlbumsDataSource : NSObject<UITableViewDataSource, KTSelectableProtocol>
@property(weak,nonatomic)id<KTAssetsDelegate> delegate;
- (void)setTableView:(UITableView *)tableView cellClass:(Class)cellClass loadContentBlock:(void (^)(id cell, id<KTAlbumProtocol> album))block;
- (id<KTAlbumProtocol>)valueOfIndexPath:(NSIndexPath *)indexPath;
@end
