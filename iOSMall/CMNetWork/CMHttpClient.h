//
//  CMHttpClient.h
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CMNetError.h"
#import "MJExtension.h"

typedef void(^YCBoolReqHandler) (CMNetError *error,BOOL suc);
typedef void(^SucReqHandler) (id responseObject);
typedef void(^FailReqHandler) (CMNetError * error);

@interface CMHttpClient : NSObject

#pragma mark 构造

/**
 *  默认
 *
 *  @return
 */
+(instancetype)defaultClient;

/**
 *  自定义client
 *
 *  @param baseURL 基本url
 *
 *  @return
 */
+(instancetype)clientWithBaseUrl:(NSString *)baseURL;

#pragma mark 请求
#pragma mark GET
/**
 *  get请求
 *
 *  @param path       路径
 *  @param params 参数
 *  @param needOauth  是否需要认证
 *  @param sucHandler 成功
 *  @param failHandler 失败
 */
-(void)get:(NSString *)path params:(NSDictionary *)params needOauth:(BOOL)needOauth  sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler;

#pragma mark POST
/**
 *  post请求
 *
 *  @param path    路径
 *  @param params  参数
 *  @param needOauth 是否需要认证
 *  @param needOauth  是否需要认证
 *  @param sucHandler 成功
 *  @param failHandler 失败
 */
-(void)post:(NSString *)path params:(NSDictionary *)params needOauth:(BOOL)needOauth sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler;

/**
 *  下载图片
 *
 *  @param path        路径
 *  @param params      参数
 *  @param sucHandler  成功
 *  @param failHandler 失败
 */
-(void)downloadImage:(NSString *)path params:(NSDictionary *)params sucHandler:(void(^)(UIImage * data))sucHandler failHandler:(FailReqHandler)failHandler;

/**
 *  上传图片
 *
 *  @param path        路径
 *  @param params      参数
 *  @param filePath    文件本地路径
 *  @param sucHandler  成功
 *  @param failHandler 失败
 */
- (void)uploadImage:(NSString *)path params:(NSDictionary *)params constructingBodyWithPath:(NSString *)filePath sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler;

/**
 *  同步get请求
 *
 *  @param params 参数
 *  @param path 路径
 *  @param error  错误
 *  @return 返回结果
 */
-(NSDictionary *)synGet:(NSString *)path params:(NSDictionary *)params error:(NSError **)error;

@end
