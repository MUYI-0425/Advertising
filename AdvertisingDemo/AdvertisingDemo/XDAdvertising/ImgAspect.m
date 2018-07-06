//
//  ImgAspect.m
//  AdvertisingDemo
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import "ImgAspect.h"

@implementation ImgAspect
+ (CGFloat)remoteImgAspectWithUrl:(NSString *)remoteUrl {
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:remoteUrl]];
    UIImage *img = [UIImage imageWithData:imgData];
    return [ImgAspect localImgAspectWithImg:img];
}

+ (CGFloat)localImgAspectWithImg:(UIImage *)img {
    return img.size.width / img.size.height;
}
@end
