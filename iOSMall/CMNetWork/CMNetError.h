//
//  CMNetError.h
//  iOSMall
//
//  Created by 任维超 on 2016/12/30.
//  Copyright © 2016年 vchao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  错误类，主要添加errorMsg字段
 */
@interface CMNetError : NSObject
//错误信息
@property(nonatomic,copy) NSString *errorMsg;
@property(nonatomic,strong) NSError *errorInfo;
-(NSString *)domain;
-(NSInteger)code;
-(void)setCode:(NSInteger)code;
-(NSDictionary *)userInfo;
-(NSString *)localizedDescription;
-(NSString *)localizedFailureReason;
-(NSString *)localizedRecoverySuggestion;
-(NSArray *)localizedRecoveryOptions;
-(id)recoveryAttempter;
-(NSString *)helpAnchor;
+(instancetype)objectForError:(NSError *)error;

@end
