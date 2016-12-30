//
//  CMHttpClient.m
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import "CMHttpClient.h"
#import "CMConfigure.h"
#import "AppDelegate.h"
#import "CMNetManger.h"

// 环境
static  NSString *const testingURL = @"https://testing100.yongche.org/greencar/driver_status.php";
static  NSString *const onlineURL = @"https://www.yongche.com/greencar/driver_status.php";
static  NSTimeInterval const kYCRequestTimeOut = 20;
//static NSString* const kYCTestHost = @"http://testing.d.yongche.org";

static NSString* const YC_HTTP_METHOD_GET = @"get";
static NSString* const YC_HTTP_METHOD_POST = @"post";
static NSString* const YC_HTTP_METHOD_DOWNLOADIMAGE = @"downloadImage";
static NSString* const YC_HTTP_METHOD_UPLOADIMAGE = @"uploadImage";

@interface CMHttpClient()
{
    AFHTTPSessionManager * _client;
}
@end

@implementation CMHttpClient

#pragma mark UserAgent
/**
 *  user-agent 拼接
 *
 *  @return
 */
+ (NSString *)getUserAgent
{
    //userAgent
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    
    NSString *appVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *deviceName;
    NSString *OSName;
    NSString *OSVersion;
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
    UIDevice *device = [UIDevice currentDevice];
    deviceName = [device model];
    OSName = [device systemName];
    OSVersion = [device systemVersion];
    
//    YCConfigure *config = [YCConfigure configure];
    //IOS端user-agent格式  iCarMaster/3.0/98/{channel_source}/{imei} (iPhone; iPhone OS 7.0.2; zh_CN)
    //  appName/version/内部版本号/渠道/imei/(设备名称;操作系统;本地语言)
    NSString *userAgent = [NSString stringWithFormat:@"i%@/%@/AppStore/(%@; %@; %@; %@)", appName, appVersion,deviceName, OSName, OSVersion, locale];
    return userAgent;
}


#pragma mark 构造

/**
 *  默认
 *
 *  @return
 */
+ (instancetype)defaultClient
{
    static dispatch_once_t onceToken;
    static CMHttpClient *client = nil;
    dispatch_once(&onceToken, ^{
        client = [[CMHttpClient alloc]initWithBaseURL:@"http://www.baidu.com"];
    });
    return client;
}

- (instancetype)init
{
    self  = [super init];
    if (self){
        _client = [[AFHTTPSessionManager alloc]init];
        [self customInit];
    }
    return self;
}

/**
 *  自定义client
 *
 *  @param baseURL 基本url
 *
 *  @return
 */
+ (instancetype)clientWithBaseUrl:(NSString *)baseURL
{
    static dispatch_once_t onceToken;
    static CMHttpClient *client = nil;
    dispatch_once(&onceToken, ^{
        client = [[CMHttpClient alloc] initWithBaseURL:baseURL];
    });
    return client;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    self = [super init];
    if (self) {
        _client = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];
        [self customInit];
    }
    return self;
}


/**
 *  初始化，请求超时,user-agent，返回序列化的设置
 */
- (void)customInit
{
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    [_client setResponseSerializer:responseSerializer];
    // 请求超时时间
    _client.requestSerializer.timeoutInterval = kYCRequestTimeOut;
    [_client.requestSerializer setValue:[CMHttpClient getUserAgent] forHTTPHeaderField:@"User-Agent"];
    _client.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
}

/**
 *  添加header
 *
 *  @param isCarOwner 是否是车主
 */
- (void)addHeader:(BOOL)isCarOwner
{
    int timestamp = (int)[[NSDate date] timeIntervalSince1970];
    
    NSMutableString *str = [NSMutableString string];
    
    //    [str appendFormat:@"OAuth oauth_consumer_key=\"2afdd89f5c6dbdc34542ab04933a091004eba18e2\","];线下
    //    [str appendFormat:@"OAuth oauth_consumer_key=\"4821726c1947cdf3eebacade98173939\","];线上
    
    [str appendFormat:@"oauth_signature_method=\"PLAINTEXT\","];
    [str appendFormat:@"oauth_timestamp=\"%d\",", timestamp];
    [str appendFormat:@"oauth_nonce=\"%d\",", timestamp + arc4random()];
    [str appendFormat:@"x_auth_mode=\"client_auth\","];
    [str appendFormat:@"oauth_version=\"1.0\","];
    //   [str appendFormat:@"oauth_signature=\"6b14621cf384c02091c010f315a35fc0\","];线下
    //   [str appendFormat:@"oauth_signature=\"6268582abcc19b05cc91bd764b33bcf8\","];线上
    
//    if ([YCTokenInfo isAuthoried]) {
//        [str appendFormat:@"oauth_token=\"%@\",", [YCTokenInfo token]];
//        [str appendFormat:@"oauth_token_secret=\"%@\"", [YCTokenInfo token_secret]];
//    }
    
    [_client.requestSerializer setValue:str
                     forHTTPHeaderField:@"Authorization"];
}

/**
 *  底层的参数传递
 *
 *  @param params     参数
 *  @param isCarOwner 是否是车主接口
 */
- (void)addCustomParms:(NSMutableDictionary *)params isCarOwner:(BOOL)isCarOwner
{
    CMConfigure *config = [CMConfigure configure];
    [params setObject:config.imei forKeyedSubscript:@"imei"];
    [params setObject:config.version forKeyedSubscript:@"version"];
    [params setObject:config.os_name forKeyedSubscript:@"os_name"]; //old
    [params setObject:config.os_name forKeyedSubscript:@"os_agent"]; //newV2.3.0
    [params setObject:config.os_version forKeyedSubscript:@"os_version"];
    [params setObject:config.device_type forKeyedSubscript:@"device_type"];
    if ([params valueForKey:@"city"]) {
        // 如果参数中city有值,则不对city参数进行处理
    } else if ([[NSUserDefaults standardUserDefaults] objectForKey:KLocationCity]) {
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KLocationCity] forKeyedSubscript:@"city"];
        
    }else{
        [params setObject:@"" forKeyedSubscript:@"city"];
        
    }
    DLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:KLocationCity]);
    
    
    if (CMAppDelegater.pushToken) {
        [params setObject:CMAppDelegater.pushToken forKeyedSubscript:@"push_token"];
        
    }
    DLog(@"params:::%@",params);
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark Req Custom
/**
 *  通用请求函数
 *
 *  @param method      请求方法
 *  @param path        url
 *  @param params      参数
 *  @param needOauth   是否需要认证   认证已经在底层处理，该参数已经没有任何意义，不会被读取
 *  @param filePath    文件名（用于上传接口）
 *  @param isCarOwner  是否是车主接口
 *  @param sucHandler  成功回调
 *  @param failHandler 失败回调
 */
-(void)reqWithMethod:(NSString*)method path:(NSString*)path params:(NSDictionary *)params needOauth:(BOOL)needOauth uploadFilePath:(NSString*)filePath isCarOwner:(BOOL)isCarOwner  sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler
{
    //没有网络
    if (![[CMNetManger instance] isNetworkRunning]) {
        //报错
        CMNetError *error = [[CMNetError alloc]init];
        error.errorMsg = ERROR_NOT_NET_MSG;
        if (failHandler) {
            failHandler(error);
        }
        return;
    }
    //添加header
    [self addHeader:isCarOwner];
    //可修改参数
    NSMutableDictionary * mutableDict;
    if (params == nil) {
        //没有参数创建参数字典
        mutableDict = [NSMutableDictionary dictionary];
    }
    else{
        mutableDict = [params mutableCopy];
    }
    //添加通用参数
    [self addCustomParms:mutableDict isCarOwner:isCarOwner];
    
    //如果是下载图片请求，返回序列化为图片
    if ([method isEqualToString:YC_HTTP_METHOD_DOWNLOADIMAGE])
    {
        AFImageResponseSerializer* responseSerializer = [AFImageResponseSerializer serializer];
        [_client setResponseSerializer:responseSerializer];
    }
    
    //请求成功回调
    void(^successHandler)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *operation, id responseObject) {
        
        //如果是下载图片，下载图片为image,返回成功
        if ([method isEqualToString:YC_HTTP_METHOD_DOWNLOADIMAGE] && [responseObject isKindOfClass:[UIImage class]]) {
            sucHandler(responseObject);
            return;
        }
        
        //如果不是字典类型 返回错误
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            CMNetError *error = [[CMNetError alloc]init];
            error.errorMsg = ERROR_REQUEST_ERROR_MSG;
            if (failHandler) {
                failHandler(error);
            }
            return;
        }
        
        NSDictionary *dict = responseObject;
        NSInteger code =  [dict[@"code"] integerValue];
        if (code == 200) {
            sucHandler(responseObject);
        }
        //code=0处理成连接超时
        else if (code == 0){
            CMNetError *error = [[CMNetError alloc]init];
            error.code = code;
            error.errorMsg = @"连接超时";
            failHandler(error);
        }
        else {
            //其他未知错误
            NSString *msg = dict[@"msg"];
            CMNetError *error = [[CMNetError alloc]init];
            if (msg.length) {
                error.errorMsg = msg;
            }else{
                //服务器正在偷懒
                error.errorMsg = ERROR_REQUEST_ERROR_MSG;
            }
            error.code = code;
            failHandler(error);
        }
    };
    
    //请求错误回调
    void(^errorHandler)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *operation, NSError *error){
        CMNetError *ycError = [CMNetError objectForError:error];
        ycError.errorMsg = ERROR_REQUEST_ERROR_MSG;
        if (ycError.code == -1003) {
            //无网络，用于解决断网的瞬间立刻请求的情况，isNetworkRunning检测不到
            ycError.errorMsg = ERROR_NOT_NET_MSG;
        }
        if (failHandler) {
            failHandler(ycError);
        }
    };
    
    //上传回调
    void(^uploadHandler)(id<AFMultipartFormData>) = ^(id<AFMultipartFormData> formData){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            //文件不存在
            DLog(@"post file is not exist");
        }
        [formData appendPartWithFileData:data name:@"photo"
                                fileName:filePath.lastPathComponent
                                mimeType:@"image/png"];
    };
    
    if ([method isEqualToString:YC_HTTP_METHOD_GET]) {
        [_client GET:path parameters:mutableDict progress:nil success:successHandler failure:errorHandler];
    }
    else if([method isEqualToString:YC_HTTP_METHOD_POST])
    {
        [_client POST:path parameters:mutableDict progress:nil success:successHandler failure:errorHandler];
    }
    else if ([method isEqualToString:YC_HTTP_METHOD_UPLOADIMAGE])
    {
        [_client POST:path parameters:mutableDict constructingBodyWithBlock:uploadHandler progress:nil success:successHandler failure:errorHandler];
    }
    else if ([method isEqualToString:YC_HTTP_METHOD_DOWNLOADIMAGE])
    {
        [_client GET:path parameters:mutableDict progress:nil success:successHandler failure:errorHandler];
    }
}

#pragma mark GET
-(void)get:(NSString *)path params:(NSDictionary *)params needOauth:(BOOL)needOauth  sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler;
{
    [self reqWithMethod:YC_HTTP_METHOD_GET path:path params:params needOauth:needOauth uploadFilePath:nil isCarOwner:NO sucHandler:sucHandler failHanlder:failHandler];
}

#pragma mark POST
- (void)post:(NSString *)path params:(NSDictionary *)params needOauth:(BOOL)needOauth sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler;
{
    [self reqWithMethod:YC_HTTP_METHOD_POST path:path params:params needOauth:needOauth uploadFilePath:nil isCarOwner:NO sucHandler:sucHandler failHanlder:failHandler];
}

-(void)downloadImage:(NSString *)path params:(NSDictionary *)params sucHandler:(void(^)(UIImage * image))sucHandler failHandler:(FailReqHandler)failHandler
{
    [self reqWithMethod:YC_HTTP_METHOD_DOWNLOADIMAGE path:path params:params needOauth:NO uploadFilePath:nil isCarOwner:NO sucHandler:sucHandler failHanlder:failHandler];
}

- (void)uploadImage:(NSString *)path params:(NSDictionary *)params constructingBodyWithPath:(NSString *)filePath sucHandler:(SucReqHandler)sucHandler failHanlder:(FailReqHandler)failHandler {
    [self reqWithMethod:YC_HTTP_METHOD_UPLOADIMAGE path:path params:params needOauth:NO uploadFilePath:filePath isCarOwner:NO sucHandler:sucHandler failHanlder:failHandler];
}




/**
 *  同步get请求（未完成）
 *
 *  @param params 参数
 *  @param path 路径
 *  @param error  错误
 *  @return 返回结果
 */
- (NSDictionary *)synGet:(NSString *)path params:(NSDictionary *)params error:(NSError *__autoreleasing *)error
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kYCRequestTimeOut];
    mutableRequest.HTTPMethod = @"GET";
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:&response error:error];
    
    //check error
    if (*error) {
        return nil;
    }
    
    NSInteger code = response.statusCode;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (code != 200) {
            return nil;
        }
    }
    else
    {
        NSError *jsonErr;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        if (jsonErr) {
            *error = jsonErr;
            return nil;
        }
        else
        {
            NSInteger code = [responseData[@"code"] integerValue];
            NSString *msg = responseData[@"msg"];
            if (code != 200) {
                NSError * authError = [NSError errorWithDomain:@"ycError" code:code userInfo:@{@"msg":msg}];
                *error = authError;
                return nil;
            }else {
                return responseData;
            }
        }
    }
    return nil;
}

@end
