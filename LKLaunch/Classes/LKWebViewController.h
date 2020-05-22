//
//  LKWebViewController.h
//  LKLaunch
//
//  Created by dosn-001 on 2020/5/20.
//  Copyright © 2020 tinker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKWebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;

@end

@interface UIViewController (LKPublic)

- (UINavigationController *)lk_navigationController;

@end

NS_ASSUME_NONNULL_END
