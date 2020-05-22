#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LKLaunchUtils.h"
#import "LKWebViewController.h"

FOUNDATION_EXPORT double LKLaunchVersionNumber;
FOUNDATION_EXPORT const unsigned char LKLaunchVersionString[];

