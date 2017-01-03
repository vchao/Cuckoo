//
//  AppDelegate.h
//  iOSMall
//
//  Created by 任维超 on 2016/12/29.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Hyphenate/EMSDK.h>

#define CMAppDelegater [AppDelegate sharedDelegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *pushToken;

+ (AppDelegate *)sharedDelegate;

@end

