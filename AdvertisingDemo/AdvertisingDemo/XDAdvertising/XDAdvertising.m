//
//  XDAdvertising.m
//  AdvertisingDemo
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import "XDAdvertising.h"
#import "ImgAspect.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
static XDAdvertising *xdAdvertising;

@interface XDAdvertising()<UIScrollViewDelegate>

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,strong)UIView *animationView;

@property (nonatomic,strong)UIButton *dismissBtn;

@property (nonatomic,copy)TapImageFlag remoteTapImage;

@end

@implementation XDAdvertising


+ (void)createXDAdvertisingWithImageURLS:(NSArray *)imageURLS
                       imageUrlContainer:(ImageUrlsContainer)container
                            tapImageFlag:(TapImageFlag)flag {
    
    BOOL isLocal = NO;
    
    if ([imageURLS[0] isKindOfClass:[UIImage class]]) {
        isLocal = YES;
    }
    
    NSArray <UIImageView *>*imgViews = [XDAdvertising initXDAdvertisingWithImagesCount:imageURLS  tapImageFlag:flag isLocal:isLocal];
    
    if (container) {
        container(imgViews);
    }
    
}

/**
 初始化各个控件

 @param imagesCount 图片个数
 @param flag 点击图片
 @return 图片容器数组
 */
+ (NSArray <UIImageView *>*)initXDAdvertisingWithImagesCount:(NSArray *)imagesCount
                                                tapImageFlag:(TapImageFlag)flag isLocal:(BOOL)isLocal{
    
    xdAdvertising = [[XDAdvertising alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    xdAdvertising.backgroundColor = [UIColor lightGrayColor];
    
    xdAdvertising.alpha = 0.1;
    
    xdAdvertising.remoteTapImage = flag;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:xdAdvertising];
    
    xdAdvertising.animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 - HEIGHT, WIDTH, HEIGHT - 180)];
    
    [keyWindow addSubview:xdAdvertising.animationView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, xdAdvertising.animationView.frame.size.height - 30)];
    
    scrollView.pagingEnabled = YES;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(WIDTH * imagesCount.count, scrollView.frame.size.height);
    
    scrollView.delegate = xdAdvertising;
    
    [xdAdvertising.animationView addSubview:scrollView];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    
    //视图宽高比
    CGFloat originWidth = WIDTH - 60;
    
    CGFloat originHeight = scrollView.frame.size.height;
    
    CGFloat frameAspect = originWidth / originHeight;
    
    CGFloat spacing = 30;
    
    for (int i = 0; i < imagesCount.count; i++) {
        
        CGFloat imgAspect;
        
        if (isLocal) {
            imgAspect = [ImgAspect localImgAspectWithImg:imagesCount[i]];
        } else {
            imgAspect = [ImgAspect remoteImgAspectWithUrl:imagesCount[i]];
        }
        
        CGRect imgViewFrame = CGRectZero;
        
        if (frameAspect >= imgAspect) {
            CGFloat imgWidth = originHeight * imgAspect;
            spacing = (WIDTH - imgWidth) / 2;
            imgViewFrame = CGRectMake(spacing + (i * WIDTH), 0, imgWidth, originHeight);
        }else {
            CGFloat imgHeight = originWidth / imgAspect;
            imgViewFrame = CGRectMake(spacing + (i * WIDTH), (originHeight - imgHeight) / 2, originWidth, imgHeight);
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewFrame];
        imgView.tag = 100+i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:xdAdvertising action:@selector(tapGes:)];
        [imgView addGestureRecognizer:tap];
        [scrollView addSubview:imgView];
        [temp addObject:imgView];
    }
    
    xdAdvertising.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH/2-50, CGRectGetMaxY(scrollView.frame), 100, 30)];
    
    xdAdvertising.pageControl.numberOfPages = imagesCount.count;
    
    [xdAdvertising.animationView addSubview:xdAdvertising.pageControl];
    
    xdAdvertising.dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2 - 25, HEIGHT, 50, 50)];
    
    [xdAdvertising.dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [xdAdvertising.dismissBtn addTarget:xdAdvertising action:@selector(dismissXdAdvertising) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:xdAdvertising.dismissBtn];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        xdAdvertising.animationView.transform = CGAffineTransformMakeTranslation(0, HEIGHT - 100);
        xdAdvertising.dismissBtn.transform = CGAffineTransformMakeTranslation(0, -95);
    } completion:nil];
    
    
    return [temp copy];
}

- (void)dismissXdAdvertising {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        xdAdvertising.animationView.transform = CGAffineTransformMakeTranslation(0, 100-HEIGHT);
        xdAdvertising.dismissBtn.transform = CGAffineTransformMakeTranslation(0, 95);
    } completion:^(BOOL finish){
        [xdAdvertising removeFromSuperview];
        [xdAdvertising.animationView removeFromSuperview];
        [xdAdvertising.dismissBtn removeFromSuperview];
    }];
}

- (void)tapGes:(UITapGestureRecognizer *)tapSend {
    [self dismissXdAdvertising];
    NSInteger tapInteger = tapSend.view.tag - 100;
    if (xdAdvertising.remoteTapImage) {
        xdAdvertising.remoteTapImage(tapInteger);
    }
}

#pragma mark - scrollView-delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offSet = scrollView.contentOffset;
    
    xdAdvertising.pageControl.currentPage = offSet.x / WIDTH;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
