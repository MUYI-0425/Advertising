//
//  XDAdvertising.m
//  AdvertisingDemo
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 SXD. All rights reserved.
//

#import "XDAdvertising.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
static XDAdvertising *xdAdvertising;

@interface XDAdvertising()<UIScrollViewDelegate>

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,strong)UIView *animationView;

@property (nonatomic,strong)UIButton *dismissBtn;

@property (nonatomic,copy)TapImageFlag localTapImage;

@property (nonatomic,copy)TapImageFlag remoteTapImage;
@end

@implementation XDAdvertising

+ (void)createXDAdvertisingWithImages:(NSArray <UIImage*>*)images
                          aspectRatio:(CGFloat)aspectRatio
                         tapImageFlag:(TapImageFlag)flag {

    
    NSArray <UIImageView *>*imgViews = [XDAdvertising initXDAdvertisingWithImagesCount:images.count  tapImageFlag:flag aspectRatio:aspectRatio isLocalImgs:YES];
    
    for (int i = 0; i < images.count; i++) {
        imgViews[i].image = images[i];
    }
    
}

+ (void)createXDAdvertisingWithImageURLS:(NSInteger)imageURLS
                             aspectRatio:(CGFloat)aspectRatio
                       imageUrlContainer:(ImageUrlsContainer)container
                            tapImageFlag:(TapImageFlag)flag {
    NSArray <UIImageView *>*imgViews = [XDAdvertising initXDAdvertisingWithImagesCount:imageURLS  tapImageFlag:flag aspectRatio:aspectRatio isLocalImgs:NO];
    
    if (container) {
        container(imgViews);
    }
    
}

/**
 初始化各个控件

 @param imagesCount 图片个数
 @param flag 点击图片
 @param isLocalImgs 是否是本地图片
 @return 图片容器数组
 */
+ (NSArray <UIImageView *>*)initXDAdvertisingWithImagesCount:(NSInteger)imagesCount
                                                tapImageFlag:(TapImageFlag)flag
                                                 aspectRatio:(CGFloat)aspectRatio
                                                 isLocalImgs:(BOOL)isLocalImgs{
    
    xdAdvertising = [[XDAdvertising alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    xdAdvertising.backgroundColor = [UIColor lightGrayColor];
    
    xdAdvertising.alpha = 0.1;
    
    if (isLocalImgs) {
        xdAdvertising.localTapImage = flag;
    }else {
        xdAdvertising.remoteTapImage = flag;
    }
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:xdAdvertising];
    
    xdAdvertising.animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 - HEIGHT, WIDTH, HEIGHT - 180)];
    
    [keyWindow addSubview:xdAdvertising.animationView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, xdAdvertising.animationView.frame.size.height - 30)];
    
    scrollView.pagingEnabled = YES;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.contentSize = CGSizeMake(WIDTH * imagesCount, scrollView.frame.size.height);
    
    scrollView.delegate = xdAdvertising;
    
    [xdAdvertising.animationView addSubview:scrollView];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat imgWidth = aspectRatio * scrollView.frame.size.height;
    
    CGFloat spacing = (WIDTH - imgWidth) / 2;
    
    if (spacing < 0) {
        spacing = 0;
    }
    
    for (int i = 0; i < imagesCount; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(spacing + (i * WIDTH), 0, WIDTH-2*spacing, scrollView.frame.size.height)];
        imgView.tag = 100+i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:xdAdvertising action:@selector(tapGes:)];
        [imgView addGestureRecognizer:tap];
        [scrollView addSubview:imgView];
        [temp addObject:imgView];
    }
    
    xdAdvertising.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH/2-50, CGRectGetMaxY(scrollView.frame), 100, 30)];
    
    xdAdvertising.pageControl.numberOfPages = imagesCount;
    
    [xdAdvertising.animationView addSubview:xdAdvertising.pageControl];
    
    xdAdvertising.dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2 - 25, HEIGHT, 50, 50)];
    
    [xdAdvertising.dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [xdAdvertising.dismissBtn addTarget:xdAdvertising action:@selector(dismissXdAdvertising) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:xdAdvertising.dismissBtn];
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        xdAdvertising.animationView.transform = CGAffineTransformMakeTranslation(0, HEIGHT - 100);
        xdAdvertising.dismissBtn.transform = CGAffineTransformMakeTranslation(0, -95);
    } completion:nil];
    
    
    return [temp copy];
}

- (void)dismissXdAdvertising {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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
    if (xdAdvertising.localTapImage) {
        xdAdvertising.localTapImage(tapInteger);
    }
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
