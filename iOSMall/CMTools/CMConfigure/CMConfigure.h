//
//  CMConfigure.h
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMConfigure : NSObject

/**
 *  单例
 *
 *  @return
 */
+(instancetype)configure;
//版本号
@property(nonatomic,readonly) NSString *version;
//设备唯一标示
@property(nonatomic,readonly) NSString *imei;
//设备型号
@property(nonatomic,readonly) NSString *device_type;
//系统版本
@property(nonatomic,readonly) NSString *os_version;
//系统名字
@property(nonatomic,readonly) NSString *os_name;

@end
