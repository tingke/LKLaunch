//
//  LKLaunchUtils.m
//  LKLaunch
//
//  Created by dosn-001 on 2020/5/19.
//  Copyright © 2020 tinker. All rights reserved.
//

#import "LKLaunchUtils.h"
#import "LKWebViewController.h"
#import <UIKit/UIKit.h>

@interface LKLaunchUtils()

@property (nonatomic, strong) UIWindow *adWindow;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, weak) UIButton *countDownBtn;
// 广告展示时长，默认3s
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LKLaunchUtils

static NSTimeInterval duration = 0;

+ (void)registerLaunchAdWithDuration:(NSTimeInterval)duration {
    LKLaunchUtils *utils = [LKLaunchUtils singleton];
    utils.duration = duration > 0?duration:3.0;
}

+ (void)registerLaunchAd {
    [LKLaunchUtils registerLaunchAdWithDuration:3.0];
}

#pragma mark - ————— 单例 —————

+ (instancetype)singleton {
    static LKLaunchUtils *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[super allocWithZone:NULL] init];
    });
    return utils;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LKLaunchUtils singleton];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [LKLaunchUtils singleton];
}
// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [LKLaunchUtils singleton];
}

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 3.0;
        
        // 监听app启动通知
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            NSLog(@"UIApplicationDidFinishLaunchingNotification");
            [self checkAd];
        }];
        
        // 监听app进入后台通知
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            [self requstAd];
        }];
        
        // 监听app进入前台通知
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            NSLog(@"UIApplicationWillEnterForegroundNotification");
            [self checkAd];
        }];
    }
    return self;
}

- (void)requstAd {
    // 请求广告数据
}

- (void)checkAd {
    // 检查广告
    BOOL hasAd = true;
    if(hasAd) {
        [self showAd];
    }else {
        [self requstAd];
    }
}

- (void)showAd {
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [self lauchViewController];
    ///广告布局
    [self setupSubviews:window];
    
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    
    ///防止释放，显示完后  要手动设置为 nil
    self.adWindow = window;
}

- (void)hiddenAd {
    [self stopTimer];
    [UIView animateWithDuration:0.3 animations:^{
        self.adWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.adWindow.hidden = YES;
        self.adWindow = nil;
    }];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)changeBtnTitle {
    NSLog(@"timer");

    NSString *title = [NSString stringWithFormat:@"跳过：%ld", (long)duration];
    [self.countDownBtn setTitle:title
                           forState:(UIControlStateNormal)];
    if(duration <= 0) {
        [self hiddenAd];
        [self.timer invalidate];
    }
    duration--;
}

- (void)lookAd {
    
    LKWebViewController *web = [LKWebViewController new];
    web.url = [NSURL URLWithString:@"https://www.baidu.com"];
    UINavigationController *rootVC = [self rootViewController].lk_navigationController;
    [rootVC pushViewController:web animated:YES];

    [self hiddenAd];
}

- (void)lookAd1 {
    [self stopTimer];
    
    LKWebViewController *web = [LKWebViewController new];
    web.url = [NSURL URLWithString:@"https://www.baidu.com"];
    self.adWindow.rootViewController = web;
    
    self.closeBtn.frame = CGRectMake(self.adWindow.bounds.size.width - 100 - 20, 20, 100, 60);
    self.closeBtn.hidden = NO;
    [self.adWindow.rootViewController.view addSubview:self.closeBtn];
}


///初始化显示的视图， 可以挪到具
- (void)setupSubviews:(UIWindow*)window {
    UIView *rootView = window.rootViewController.view;
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height * 0.8)];
    imageView.image = [UIImage imageNamed:@"000.jpg"];
    imageView.userInteractionEnabled = YES;
    
    ///给非UIControl的子类，增加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(lookAd1)];
    [imageView addGestureRecognizer:tap];
    [rootView addSubview:imageView];
    
    UIButton * goout = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 100 - 20, 20, 100, 60)];
    [goout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [goout addTarget:self
              action:@selector(hiddenAd)
    forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:goout];
    self.countDownBtn = goout;
    
    duration = self.duration;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
}


- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (UIViewController *)lauchViewController {
    UIStoryboard *launchScreen = [UIStoryboard storyboardWithName:@"LaunchScreen"
                                                           bundle:nil];
    UIViewController *vc = [launchScreen instantiateInitialViewController]?:[UIViewController new];
    return vc;
}

- (UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _closeBtn.hidden = YES;
        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn addTarget:self
                      action:@selector(hiddenAd)
            forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

@end
