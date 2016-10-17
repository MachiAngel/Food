//
//  restaurantInfoCell.m
//  listRestaurant
//
//  Created by Wei on 2016/10/17.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "restaurantInfoCell.h"



@interface restaurantInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;


@end

@implementation restaurantInfoCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"tg";

    restaurantInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        // 如果找不到就從xib中創建cell
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"restaurantInfoCell" owner:nil options:nil] firstObject];
        NSLog(@"創建一個新的cell");
    }
    return cell;
}


- (void)setTg:(RestaurantModel *)tg
{
    _tg = tg;
    
    // 設置餐廳
    
    self.iconView.image = [UIImage imageNamed:@"unknow.png"];
    
    
   
    
    // 設置餐廳標題
    self.titleLabel.text = tg.ShopName;
    // 設置餐廳地址
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@", tg.ShopAddress];
    // 設置餐廳電話
    self.telNumLabel.text = [NSString stringWithFormat:@"電話:%@", tg.ShopPhone];
}




@end
