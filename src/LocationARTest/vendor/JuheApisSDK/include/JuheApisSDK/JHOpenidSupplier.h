//
//  JHOpenidSupplier.h
//  JuheApisSDK
//
//  Created by Edward.Shi on 8/8/14.
//  Copyright (c) 2014 ThinkLand. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface JHOpenidSupplier  : NSObject

+(JHOpenidSupplier *)shareSupplier;

/**
 注册API数据服务所需要的openId
 @param openId  申请的有效openId
 @discuss          
 a. openId通过聚合官网( http://www.juhe.cn )申请, openId的相关说明参考官网
 b. 可以多次register, 最后register的openId最先获取
 */
- (void)registerJuheAPIByOpenId:(NSString *)openId;

/**
 注销API数据服务所需要的openId
 @param openId  申请的有效openId
 @dicuss           
 a. openId通过聚合官网( http://www.juhe.cn )申请
 b. 没有API数据服务所需要的openId, 将无法获得API数据服务
 */
- (void)unregisterJuheAPIByOpenId:(NSString *)openId;

/**
 获取最后注册API数据服务所需要的openId
 @discuss          
 没有注册，或者取消所有注册的数据服务的openId, 返回nil
 */
- (NSString *)getLatestJuheAPIOpenId;

@end
