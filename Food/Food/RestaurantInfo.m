//
//  RestaurantInfo.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/17.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "RestaurantInfo.h"


static RestaurantInfo* _restaurantManager;

@implementation RestaurantInfo
{
    // 拿到資料裝在這邊
    NSMutableArray * restaurantArray;
    
}

+(instancetype)sharedInstance{
    
    if (_restaurantManager == nil) {
        
        _restaurantManager = [RestaurantInfo new];
        
    }
    
    return _restaurantManager;
    
}


-(void)getAllRestaurantArray:(DoneHandler)done{
    
    Helper * helper = [Helper sharedInstance];
    
    
    //拿到餐聽的ref 並觀察他底下的東西
    [[helper getDatabaseRefOfRestaurants]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        restaurantArray = [NSMutableArray new];
        
        NSDictionary * restaurantInfo = snapshot.value;
        
        
        for(NSString * uid in restaurantInfo){
            
            NSMutableDictionary * eachRestaurant = restaurantInfo[uid];
            
            [restaurantArray addObject:eachRestaurant];
            
        }
        
        done(restaurantArray);
        
    }];
    
    
    
    
    
}

@end
