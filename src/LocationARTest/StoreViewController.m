//
//  StoreViewController.m
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tv.text = [NSString stringWithFormat:@""
    "店名：%@\n"
    "类导航：%@\n"
    "所属城市：%@\n"
    "所属区域：%@\n"
    "详细地址：%@\n"
    "联系电话：%@\n"
    "星级：%@\n"
    "人均消费：%@\n"
    "标签：%@\n"
    "推荐产品：%@\n"
    "推荐菜色：%@\n"
    "周边美食：%@",
    _module.name, _module.navigation, _module.city, _module.area, _module.address, _module.phone, _module.stars, _module.avg_price, _module.tags, _module.recommended_products, _module.recommended_dishes, _module.nearby_shops];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
