//
//  ImgAspect.h
//  AdvertisingDemo
//
//  Created by apple on 2018/7/6.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImgAspect : NSObject

+ (CGFloat)remoteImgAspectWithUrl:(NSString *)remoteUrl;

+ (CGFloat)localImgAspectWithImg:(UIImage *)img;

@end
