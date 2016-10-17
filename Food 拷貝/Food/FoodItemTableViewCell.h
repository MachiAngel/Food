//
//  FoodItemTableViewCell.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/15.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *queue;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodPrice;

@end
