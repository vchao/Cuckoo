//
//  CMNetError.m
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import "CMNetError.h"

@interface CMNetError()
{
    NSNumber* _code;
}

@end

@implementation CMNetError

+(instancetype)objectForError:(NSError *)error
{
    __autoreleasing CMNetError *ycError = [[CMNetError alloc]init];
    ycError.errorInfo = error;
    return ycError;
}

-(NSString *)description
{
    return _errorInfo.description;
}

-(NSString *)domain
{
    return _errorInfo.domain;
}

-(NSInteger)code
{
    if (_code) {
        return [_code integerValue];
    }
    else
    {
        return _errorInfo.code;
    }
}

-(void)setCode:(NSInteger)code
{
    if ([_code integerValue]!=code) {
        _code = [[NSNumber alloc]initWithInteger:code];
    }
}


-(NSDictionary *)userInfo
{
    return _errorInfo.userInfo;
}

-(NSString *)localizedDescription
{
    return _errorInfo.localizedDescription;
}

-(NSString *)localizedFailureReason
{
    return _errorInfo.localizedFailureReason;
}

-(NSString *)localizedRecoverySuggestion
{
    return _errorInfo.localizedRecoverySuggestion;
}

-(NSArray *)localizedRecoveryOptions
{
    return _errorInfo.localizedRecoveryOptions;
}

-(id)recoveryAttempter
{
    return _errorInfo.recoveryAttempter;
}

-(NSString *)helpAnchor
{
    return _errorInfo.helpAnchor;
}

@end
