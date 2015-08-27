//
//  JHAPISDK.h
//  JuheApisSDK
//
//  Created by Bill.Fang on 14-11-3.
//  Copyright (c) 2014年 thinkland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAPISDK : NSObject

+ (instancetype)shareJHAPISDK;

/**
 @brief  执行聚合数据请求, 操作请求返回的数据
 
 @param api           聚合数据服务接口，可以在聚合数据官网的数据接口API，接口地址中找到，如IP地址API接口：http://apis.juhe.cn/ip/ip2addr
 
 @param api_id        聚合数据服务接口，可以在聚合数据官网的数据接口API，URL地址中找到，如IP地址URL：http://www.juhe.cn/docs/api/id/1，则api_id:1
 
 @param paras         对应于服务类型的一些参数, 是Objective-C的NSDictionary类型，可以在IP地址API接口中“请求参数”
 
 @param success       请求得到处理, 并且返回有效数据时, 对返回的数据, 在主线程, 执行自定义的行为
 
 @param failure       没有网络, 或者服务器没有响应, 或者服务器没有返回有效数据, 对返回的NSError对象, 在主线程, 执行自定义的行为
 
 @discuss
 a. 数据服务类型的选择, 对应可用的HTTP请求方法, 对应可用的请求参数, 执行请求返回的Objective-C对象, 请参考SDK文档
 
 b. 执行数据请求是异步的, 开发者直接调用即可.
 */

- (void)executeWorkWithAPI:(NSString *)api
                     APIID:(NSString *)api_id
                Parameters:(NSDictionary *)paras
                    Method:(NSString *)method
                   Success:(void (^)(id responseObject))success
                   Failure:(void (^)(NSError *error))failure;

@end
