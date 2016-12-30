//
//  CMNetManger.m
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import "CMNetManger.h"
#import <Reachability/Reachability.h>
#import <AFNetworkReachabilityManager.h>

static CMNetManger *netWorkManger = nil;

@implementation CMNetManger

+ (CMNetManger *)instance
{
    @synchronized(self){
        if (netWorkManger == nil) {
            netWorkManger = [[[self class] alloc] init];
        }
        return netWorkManger;
    }
}
+(NETWORK_TYPE)networkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (netWorkManger == nil) {
            netWorkManger = [super allocWithZone:zone];
        }
        return netWorkManger;
    }
}

+ (id)copyWithZone:(NSZone *)zone
{
    return netWorkManger;
}



- (BOOL)isNetworkRunning
{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus state = reachability.currentReachabilityStatus;
    BOOL result = NO;
    switch (state) {
        case NotReachable: {
            result = NO;
        }
            break;
        case ReachableViaWiFi: {
            result = YES;
        }
            break;
        case ReachableViaWWAN: {
            result = YES;
        }
            break;
        default: {
            result = YES;
        }
            break;
    }
    return result;
}

+ (void)detectWorking:(void(^)(BOOL hasNet))netHandler
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                netHandler(NO);
                break;
                
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                netHandler(YES);
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                netHandler(YES);
                break;
            }
            default:
                break;
        }
    }];
}

@end
