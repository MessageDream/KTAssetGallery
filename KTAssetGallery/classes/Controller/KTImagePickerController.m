//
//  KTImagePickerController.m
//  KTAlbumController
//
//  Created by Jayden Zhao on 15/11/5.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "KTImagePickerController.h"
#import "KTImagePickerSettings.h"
#import "KTPhotosController.h"

@interface KTImagePickerController()
@property(strong,nonatomic)KTImagePickerSettings *settings;
@property(strong,nonatomic)KTPhotosController *photoController;

@property(copy,nonatomic)void (^selectionBlock)(id<KTAssetProtocol> asset);
@property(copy,nonatomic)void (^deSelectionBlock)(id<KTAssetProtocol> asset);
@property(copy,nonatomic)void (^cancelBlock)(NSArray<id<KTAssetProtocol>> *assets);
@property(copy,nonatomic)void (^finishBlock)(NSArray<id<KTAssetProtocol>> *assets);
@end

@implementation KTImagePickerController

+ (KTImagePickerController *)imagePickerControllerWithHasSelected:(NSArray<id<KTAssetProtocol>> *) hasSelected
                                                       whenSelect:(void (^)(id<KTAssetProtocol> asset)) selectionBlock
                                                         deSelect:(void (^)(id<KTAssetProtocol> asset)) deSelectionBlock
                                                           cancel:(void (^)(NSArray<id<KTAssetProtocol>> *assets)) cancelBlock
                                                           finish:(void (^)(NSArray<id<KTAssetProtocol>> *assets))finishBlock{
    
    KTImagePickerController *vc = [[self alloc] init];
    vc.photoController.lastTimeSelections = hasSelected;
    vc.selectionBlock = selectionBlock;
    vc.deSelectionBlock = deSelectionBlock;
    vc.cancelBlock = cancelBlock;
    vc.finishBlock = finishBlock;
    return vc;
}

+ (void)authorize:(UIViewController *)fromViewController completion:(void (^)())completion{
    [self authorize:[KTAssetManager authorizationStatus] fromViewController:fromViewController completion:completion];
}

+ (void)authorize:(KTAuthorizationStatus) status fromViewController:(UIViewController *)fromViewController completion:(void (^)())completion {
    switch (status) {
        case KTAuthorizationStatusAuthorized:
            if (completion) {
                completion();
            }
            break;
        case KTAuthorizationStatusNotDetermined:{
            [KTAssetManager requestAuthorization:^(KTAuthorizationStatus st) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self authorize:st fromViewController:fromViewController completion:completion];
                });
            }];
        }
            break;
        default:
            break;
    }
}

-(instancetype)init{
    if (self = [super init]) {
        _settings = [[KTImagePickerSettings alloc] init];
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([KTAssetManager authorizationStatus] == KTAuthorizationStatusAuthorized) {
       [self setViewControllers:@[self.photoController] animated:NO];
    }
}


-(KTPhotosController *)photoController{
    if (!_photoController) {
        _photoController =  [[KTPhotosController alloc] init];
    }
    return _photoController;
}

-(void)setMaxNumberOfSelections:(NSInteger)maxNumberOfSelections{
    self.settings.maxNumberOfSelections = maxNumberOfSelections;
}

-(NSInteger)maxNumberOfSelections{
    return  self.settings.maxNumberOfSelections;
}

-(void)setSelectionString:(NSString *)selectionString{
    self.settings.selectionString = selectionString;
}

-(NSString *)selectionString{
    return self.settings.selectionString;
}

-(void)setSelectionFillColor:(UIColor *)selectionFillColor{
     self.settings.selectionFillColor = selectionFillColor;
}

-(UIColor *)selectionFillColor{
    return self.settings.selectionFillColor;
}

-(void)setSelectionStrokeColor:(UIColor *)selectionStrokeColor{
     self.settings.selectionStrokeColor = selectionStrokeColor;
}

-(UIColor *)selectionStrokeColor{
    return self.settings.selectionStrokeColor;
}

-(void)setSelectionShadowColor:(UIColor *)selectionShadowColor{
     self.settings.selectionShadowColor = selectionShadowColor;
}

-(UIColor *)selectionShadowColor{
    return self.settings.selectionShadowColor;
}

-(void)setSelectionTextAttributes:(NSMutableDictionary<NSString * ,id> *)selectionTextAttributes{
     self.settings.selectionTextAttributes = selectionTextAttributes;
}

-(NSMutableDictionary<NSString * ,id> *)selectionTextAttributes{
    return self.settings.selectionTextAttributes;
}

-(void)setCellsPerRow:(NSInteger (^)(UIInterfaceOrientationMask))cellsPerRow{
     self.settings.cellsPerRow = cellsPerRow;
}

-(NSInteger (^)(UIInterfaceOrientationMask))cellsPerRow{
     return self.settings.cellsPerRow;
}

-(void)setSelectionBlock:(void (^)(id<KTAssetProtocol>))selectionBlock{
    self.photoController.selectionBlock = selectionBlock;
}

-(void (^)(id<KTAssetProtocol>))selectionBlock{
    return self.photoController.selectionBlock;
}

-(void)setDeSelectionBlock:(void (^)(id<KTAssetProtocol>))deSelectionBlock{
    self.photoController.deSelectionBlock = deSelectionBlock;
}

-(void (^)(id<KTAssetProtocol>))deSelectionBlock{
    return  self.deSelectionBlock;
}

-(void)setCancelBlock:(void (^)(NSArray<id<KTAssetProtocol>> *))cancelBlock{
    self.photoController.cancelBlock = cancelBlock;
}

-(void (^)(NSArray<id<KTAssetProtocol>> *))cancelBlock{
    return self.photoController.cancelBlock;
}

-(void)setFinishBlock:(void (^)(NSArray<id<KTAssetProtocol>> *))finishBlock{
    self.photoController.finishBlock = finishBlock;
}

-(void (^)(NSArray<id<KTAssetProtocol>> *))finishBlock{
    return self.photoController.finishBlock;
}

@end
