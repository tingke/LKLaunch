//
//  LKWebViewController.m
//  LKLaunch
//
//  Created by dosn-001 on 2020/5/20.
//  Copyright © 2020 tinker. All rights reserved.
//

#import "LKWebViewController.h"
#import <WebKit/WebKit.h>

@interface LKWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

@end

@implementation UIViewController (LKPublic)

- (UINavigationController *)lk_navigationController {
    UINavigationController *navi = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navi = (UINavigationController *)self;
    }else if ([self isKindOfClass:[UITabBarController class]]) {
        navi = ((UITabBarController *)self).selectedViewController.lk_navigationController;
    }else {
        navi = self.navigationController;
    }
    return navi;
}

@end
