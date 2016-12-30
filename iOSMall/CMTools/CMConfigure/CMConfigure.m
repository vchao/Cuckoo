//
//  CMConfigure.m
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import "CMConfigure.h"
#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import "sys/utsname.h"

@implementation CMConfigure

/**
 *  单例
 *
 *  @return
 */
+(instancetype)configure
{
    static dispatch_once_t onceToken;
    static CMConfigure *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

-(NSString *)version
{
    return kServerVersion;
}

-(NSString *)device_type
{
    return kDevice_Type;
}

-(NSString *)os_name
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPodTouch5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad2(GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad2(32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPadmini(WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPadmini(GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPadmini(CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad4(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad4(4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad4(CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPadAir2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPadAir2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPadmini2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPadmini3";
    
    return deviceString;
    //    return [[UIDevice currentDevice] systemName];
}

-(NSString *)os_version
{
    return [[UIDevice currentDevice] systemVersion];
}

void callback() { }


//-(NSString *)imei
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.imeiUUID;
//}

@end
