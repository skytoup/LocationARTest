//
//  AppDelegate.m
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "AppDelegate.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "StoreNetManager.h"
#import "JHKey.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if([JH_ID isEqualToString:@"你的聚合id"]) {
        NSLog(@"请填写你的聚合id");
        abort();
    }
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:JH_ID];
    [StoreNetManager sharedInstance];

    return YES;
}

@end
