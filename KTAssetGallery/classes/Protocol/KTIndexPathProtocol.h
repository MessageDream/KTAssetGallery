//
//  KTIndexPathProtocol.h
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/5.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTIndexPathProtocol <NSObject>
-(void)setIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPath;
@end
