//
//  XDAdvertising.h
//  AdvertisingDemo
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapImageFlag)(NSInteger imageFlag);

typedef void(^ImageUrlsContainer)(NSArray <UIImageView *>*imageViews);

@interface XDAdvertising : UIView


/**
 本地图片广告

 @param images 本地图片数组
 @param aspectRatio 图片宽高比
 @param flag 点击哪个图片
 */
+ (void)createXDAdvertisingWithImages:(NSArray <UIImage*>*)images
                          aspectRatio:(CGFloat)aspectRatio
                         tapImageFlag:(TapImageFlag)flag;


/**
 远程图片广告

 @param imageURLS 远程图片个数
  @param aspectRatio 图片宽高比
 @param container 跟图片容器赋值
 @param flag 点击哪个图片
 */
+ (void)createXDAdvertisingWithImageURLS:(NSInteger)imageURLS
                             aspectRatio:(CGFloat)aspectRatio
                       imageUrlContainer:(ImageUrlsContainer)container
                            tapImageFlag:(TapImageFlag)flag;

@end
