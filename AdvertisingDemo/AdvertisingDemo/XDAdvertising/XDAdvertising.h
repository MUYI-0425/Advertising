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
 图片广告

 @param imageURLS 图片个数
 @param container 跟图片容器赋值
 @param flag 点击哪个图片
 */
+ (void)createXDAdvertisingWithImageURLS:(NSArray *)imageURLS
                       imageUrlContainer:(ImageUrlsContainer)container
                            tapImageFlag:(TapImageFlag)flag;

@end
