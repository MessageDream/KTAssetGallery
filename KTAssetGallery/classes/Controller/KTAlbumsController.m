//
//  AlbumController.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/6/23.
//  Copyright (c) 2015年 jayden. All rights reserved.
//

#import "KTAlbumsController.h"
#import "KTAlbumsDataSource.h"
#import "KTAlbumCell.h"
#import "KTAlbumsContainerView.h"
#import "KTFetchResult.h"

@interface KTAlbumsController()<UITableViewDelegate>
{
    KTAlbumCell *_heighCell;
    void (^_loadContentBlock)(id cell, id<KTAlbumProtocol> album);
    void (^_albumChangedBlock)(id<KTAlbumProtocol> album);
}
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *containerView;
@property (strong, nonatomic) KTAlbumsDataSource *dataSource;
@property (weak, nonatomic) NSLayoutConstraint *showLayout;
@end

@implementation KTAlbumsController

-(instancetype)initWithMediaType:(KTAssetMediaType)mediaType albumChangedBlock:(void (^)(id<KTAlbumProtocol> album))block{
    if (self = [super init]) {
        _albumChangedBlock = block;
        self.dataSource = [[KTAlbumsDataSource alloc] initWithMediaType:mediaType];
        [self changeSelection:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return self;
}

-(void)loadView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    KTAlbumsContainerView *containerView = [[KTAlbumsContainerView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:containerView];
    _containerView = containerView;
    
   NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
    [view addConstraint:layout];
    self.showLayout = layout;
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0/1.5 constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0/4 constant:0.0]];
    
    self.view = view;
    
   self.tableView = containerView.tableView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _loadContentBlock = ^(KTAlbumCell *cell, id<KTAlbumProtocol> album) {
        cell.title = [NSString stringWithFormat:@"%@(%ld)", album.title, (long)[album numberOfAssets]];
        
        [album enumerateAssetsUsingBlock:^(id<KTAssetProtocol> result, NSUInteger index, BOOL *stop) {
            switch (index) {
                case 0:{
                    [result thumbnail:^(UIImage *image) {
                        cell.firstImage = image;
                        cell.secondImage = image;
                        cell.thirdImage = image;
                    }];
                }
                    break;
                case 1:{
                    [result thumbnail:^(UIImage *image) {
                        cell.secondImage = image;
                    }];
                }
                    break;
                case 2:{
                    [result thumbnail:^(UIImage *image) {
                        cell.thirdImage = image;
                    }];
                }
                    break;
                default:
                    *stop = YES;
                    break;
            }
        }];
    };
    
}


-(void)showInViewController:(UIViewController *)viewController fromView:(UIView *)fromView{
    [viewController addChildViewController:self];
    
    UIView *superView = viewController.view;
    UIView *currentView = self.view;
    
    [superView addSubview:currentView];
    
    CGRect rect = [fromView.superview convertRect:fromView.frame toView:currentView];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:currentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[currentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(currentView)]];
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[currentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(currentView)]];
    
    self.showLayout.constant = CGRectGetMaxY(rect)+10;
    
    self.tableView.delegate = self;
    [self.dataSource setTableView:self.tableView cellClass:[KTAlbumCell class] loadContentBlock:_loadContentBlock];
    
    currentView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        currentView.alpha = 1.0;
    } completion:nil];
}

- (void)changeSelection:(NSIndexPath *)indexPath{
    [self.dataSource selectObjectAtIndexPath:indexPath];
    id fetchResult =  [self.dataSource selections].firstObject;
    if (_albumChangedBlock) {
        _albumChangedBlock(fetchResult);
    }
    [self hidden];
}

- (void)hidden{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (!_heighCell) {
        _heighCell = [[KTAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    id<KTAlbumProtocol> album = [self.dataSource valueOfIndexPath:indexPath];
    
    if (_loadContentBlock) {
        _loadContentBlock(_heighCell,album);
    }
    CGFloat height = [_heighCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self changeSelection:indexPath];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
}

-(void)dealloc{
    
}
@end
