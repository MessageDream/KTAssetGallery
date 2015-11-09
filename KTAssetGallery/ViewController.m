//
//  ViewController.m
//  KTAssertGallery
//
//  Created by Jayden Zhao on 15/11/2.
//  Copyright © 2015年 jayden. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+KTAssertGallery.h"
#import "KTImagePickerController.h"

@interface ViewController ()
@property(strong,nonatomic)NSArray<id<KTAssetProtocol>> *assets;
@property(strong,nonatomic)KTImagePickerController *vc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)videos_click:(id)sender {
    
    [self kt_assetPickerCustomShow:^(UIViewController *vc) {
        [self presentViewController:vc animated:YES completion:nil];
    } hide:^(UIViewController *vc) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } mediaType:KTAssetMediaTypeVideo settings:nil hasSelected:self.assets whenSelect:^(id<KTAssetProtocol> asset) {
        NSLog(@"%@",asset);
    } deSelect:^(id<KTAssetProtocol> asset) {
        NSLog(@"%@",asset);
    } tapToPreview:^(id<KTAssetProtocol> asset){
       NSLog(@"%@",asset);
    } cancel:^(NSArray<id<KTAssetProtocol>> *assets) {
        NSLog(@"%@",assets);
    } finish:^(NSArray<id<KTAssetProtocol>> *assets) {
        self.assets = assets;
        NSLog(@"%@",assets);
    }];
}

- (IBAction)photos_click:(id)sender {
    
    [self kt_assetPickerCustomShow:^(UIViewController *vc) {
        [self presentViewController:vc animated:YES completion:nil];
    } hide:^(UIViewController *vc) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } mediaType:KTAssetMediaTypeImage settings:nil hasSelected:self.assets whenSelect:^(id<KTAssetProtocol> asset) {
        
        NSLog(@"%@",asset);
    } deSelect:^(id<KTAssetProtocol> asset) {
        NSLog(@"%@",asset);
    } tapToPreview:^(id<KTAssetProtocol> asset){
        NSLog(@"%@",asset);
    } cancel:^(NSArray<id<KTAssetProtocol>> *assets) {
        NSLog(@"%@",assets);
    } finish:^(NSArray<id<KTAssetProtocol>> *assets) {
        self.assets = assets;
        NSLog(@"%@",assets);
    }];
}

@end
