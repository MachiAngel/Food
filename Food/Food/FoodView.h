//
//  FoodView.h
//  trytrytry
//
//  Created by Shiang-Yu Huang on 2016/10/14.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodView : UIView

//@property(nonatomic,strong) UIImage * foodImage;
//@property(nonatomic,strong) UILabel * foodNameLabel;


-(instancetype) initWithFoodView:(UIImage*)image
                          fdname:(NSString*)name
                         fdPrice:(NSString*)price;

@end
