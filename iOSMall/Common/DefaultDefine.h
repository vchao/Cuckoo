//
//  DefaultDefine.h
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#ifndef DefaultDefine_h
#define DefaultDefine_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - ERROR
static NSString *const ERROR_NOT_NET_MSG = @"网络异常，请检查您的网络设置";
static NSString *const ERROR_REQUEST_ERROR_MSG = @"服务器正在偷懒，请稍候重试";
static NSString *const ERROR_REQUEST_TIMEOUT_MSG = @"连接超时,请稍后重试!";
#pragma mark - 通知
#define YCNotificationCenter [NSNotificationCenter defaultCenter]

// 屏幕尺寸
#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth SCREEN_WIDTH
#define kScreenHeight SCREEN_HEIGHT
#define kNavHeight          [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0 ? 64.0f : 44.0f

#define is_iphone4          (([UIScreen mainScreen].bounds.size.height)==480)
#define is_iphone5          (([UIScreen mainScreen].bounds.size.height)==568)
#define is_iphone6          (([UIScreen mainScreen].bounds.size.height)==667)
#define is_iphone6Plus      (([UIScreen mainScreen].bounds.size.height)==736)

#define DeviceIsIphone4 is_iphone4
#define DeviceIsIphone5 is_iphone5
#define DeviceIsIphone6 is_iphone6
#define DeviceIsIphone6plus is_iphone6Plus

#pragma mark - 内存
#define WEAK_SELF __weak typeof (self) weakself = self; weakself//bolck内用self

#pragma mark - 系统

/** 当前版本*/
#define CurrentVersion [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleShortVersionString"]

//系统版本
#define IOS10                [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0
#define IOS9                [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0
#define IOS8                [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS7                [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

//与服务器对应的版本号
static NSString * const kServerVersion = @"1";
static NSString * const kDevice_Type = @"2";

/**
 *  定位城市
 */
static NSString * const KLocationCity = @"KLocationCity";

#endif /* DefaultDefine_h */
