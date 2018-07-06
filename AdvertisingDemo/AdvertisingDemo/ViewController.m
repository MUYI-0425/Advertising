//
//  ViewController.m
//  AdvertisingDemo
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import "ViewController.h"
#import "XDAdvertising.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()
@property (nonatomic,assign)CGFloat aspectRatio;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *img = [UIImage imageNamed:@"1"];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.aspectRatio = img.size.width / img.size.height;
}

/**
 本地图片
 */
- (IBAction)local:(id)sender {
    NSArray *temp = [NSArray arrayWithObjects:[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"], nil];
    [XDAdvertising createXDAdvertisingWithImageURLS:temp  imageUrlContainer:^(NSArray<UIImageView *> *imageViews) {
        for (int i = 0; i < imageViews.count; i++) {
            imageViews[i].image = temp[i];
        }
    } tapImageFlag:^(NSInteger imageFlag) {
        NSLog(@"%ld",imageFlag);
    }];
}

/**
 远程图片
 */
- (IBAction)remote:(id)sender {
    
    NSArray *tempUrls = [NSArray arrayWithObjects:@"https://img3.doubanio.com/view/subject/l/public/s1166805.jpg",@"https://img3.doubanio.com/view/subject/s/public/s1747553.jpg",@"https://img3.doubanio.com/view/subject/l/public/s1299171.jpg", nil];
    
    [XDAdvertising createXDAdvertisingWithImageURLS:tempUrls
                                  imageUrlContainer:^(NSArray<UIImageView *> *imageViews) {
        //这里以sdwebimage为例
        for (int i = 0; i < imageViews.count; i++) {
            [imageViews[i] sd_setImageWithURL:[NSURL URLWithString:tempUrls[i]]];
        }
                                      
    } tapImageFlag:^(NSInteger imageFlag) {
        NSLog(@"%ld",imageFlag);
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
