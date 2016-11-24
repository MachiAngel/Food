//
//  FoodItemsCell.m
//  myOrderCellClass
//
//  Created by Shiang-Yu Huang on 2016/11/21.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "FoodItemsCell.h"

@implementation FoodItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)plusBtnPressed:(UIButton *)sender {
    
    NSInteger buyCount = [self.countTextField.text integerValue];
    
    if (buyCount >= 0 && buyCount < 1000)
    {
        
        buyCount++;
        self.countTextField.text = [NSString stringWithFormat:@"%ld",buyCount];
        self.minusBtn.enabled = YES;
        
        NSString * foodName = self.foodNameLabel.text;
        NSString * foodPrice = self.foodPriceLabel.text;
        NSDictionary * foodItem = @{@"foodName":foodName,@"foodPrice":foodPrice};
        
        [self.foodItemsdelegate FoodItemsCellView:self WithPlus:foodItem];
        
    
    }
    else
    {
        self.plusBtn.enabled = NO;
        
    }
    
    
    
}


- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    NSInteger buyCount = [self.countTextField.text integerValue];
    
    //NSInteger foodPrice = [self.foodPriceLabel.text integerValue];
    
    //NSInteger total = buyCount * foodPrice;
    
    if (buyCount>0){
        
        //self.minusBtn.enabled = YES;
        buyCount--;
        
        if (buyCount == 0) {
            self.minusBtn.enabled = NO;
        }
        
        //當下數量
        self.countTextField.text = [NSString stringWithFormat:@"%ld",buyCount];
        self.minusBtn.enabled = YES;
        
        NSString * foodName = self.foodNameLabel.text;
        NSString * foodPrice = self.foodPriceLabel.text;
        NSDictionary * foodItem = @{@"foodName":foodName,@"foodPrice":foodPrice};
        
        //傳數據出去
        [self.foodItemsdelegate FoodItemsCellView:self WithMinus:foodItem];
    }
//    else
//    {
//        self.minusBtn.enabled = NO;
//        
//    }
    
    
}

@end
