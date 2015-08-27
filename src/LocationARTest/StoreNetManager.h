//
//  StoreNetManager.h
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreModule.h"

@interface StoreNetManager : NSObject
+ (instancetype)sharedInstance;
- (void)getAroundStoreWithBlock:(void(^)(NSArray* storeDatas))block;
@end
