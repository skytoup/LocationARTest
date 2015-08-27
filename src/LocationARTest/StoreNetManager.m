//
//  StoreNetManager.m
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "StoreNetManager.h"
#import "JHAPISDK.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface StoreNetManager () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *lm;
@property (strong, nonatomic) CLGeocoder *gc;
@property (strong, nonatomic) CLLocation *curLc;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *lBlocks;
@end

@implementation StoreNetManager

+ (instancetype)sharedInstance {
    static StoreNetManager *s;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [StoreNetManager new];
    });
    return s;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lBlocks = [NSMutableArray new];
        
        CLGeocoder *gc = [CLGeocoder new];
        _gc = gc;
        
        CLLocationManager *lm = [[CLLocationManager alloc] init];
        _lm = lm;
        lm.delegate = self;
        lm.distanceFilter = 10000; // 10 km
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
        {
            [lm requestWhenInUseAuthorization];
        } else {
            [lm startUpdatingLocation];
        }
    }
    return self;
}

- (void)getAroundStoreWithBlock:(void(^)(NSArray* storeDatas))block {
    if(_curLc) {
        [[JHAPISDK shareJHAPISDK] executeWorkWithAPI:@"http://apis.juhe.cn/catering/query" APIID:@"45" Parameters:@{@"lat":@(_curLc.coordinate.latitude), @"lng":@(_curLc.coordinate.longitude)} Method:@"post" Success:^(NSDictionary *responseObject) {
            NSNumber *code = responseObject[@"resultcode"];
            if(code.integerValue == 200) {
                NSArray *data = responseObject[@"result"];
                NSMutableArray *md = [NSMutableArray new];
                for(NSDictionary *d in data) {
                    StoreModule *m = [StoreModule new];
                    [m setValuesForKeysWithDictionary:d];
                    [md addObject:m];
                }
                block(md);
            } else {
                block(nil);
            }
        } Failure:^(NSError *error) {
                block(nil);
        }];
    } else {
        [_lBlocks addObject:[block copy]  ];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_lm startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _curLc = [locations lastObject];
    void (^block)(NSArray *storeDatas);
    for(block in _lBlocks) {
        [self getAroundStoreWithBlock:block];
    }
    
    [_lm stopUpdatingLocation];
    [_gc reverseGeocodeLocation:_curLc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *p = [placemarks lastObject];
        _name = p.locality;
    }];
}

@end
