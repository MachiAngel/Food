//
//  OrdersTableViewCell.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/21.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderRestaurantName;
@property (weak, nonatomic) IBOutlet UILabel *createrName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;

@end
