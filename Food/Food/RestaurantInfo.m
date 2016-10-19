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
    NSMutableArray * restaurantUidArray;
    
    //for detail
    NSMutableArray * foodItems;
    
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
        
        //each restaurant value
        restaurantArray = [NSMutableArray new];
        
        //each restaurant key (aka uid)
        restaurantUidArray = [NSMutableArray new];
        
        NSDictionary * restaurantInfo = snapshot.value;
        
        
        for(NSString * uid in restaurantInfo){
            
            NSMutableDictionary * eachRestaurant = restaurantInfo[uid];
            
            [restaurantArray addObject:eachRestaurant];
            
            [restaurantUidArray addObject:uid];
        }
        //when finish for loop , go block
        done(restaurantArray);
        
    }];
    

    
}


-(void)getRestaurantFoodItemArrayWithUid:(NSString*)uid handler:(DoneHandler)done{
    
    Helper * helper = [Helper sharedInstance];
    
    foodItems = [NSMutableArray new];
    
    [[[helper getDatabaseRefOfFoodItems]child:uid]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        // restaurant of uid -> food item dict
        
        
        
        NSDictionary * foodItemsDict = snapshot.value;
        
        for (NSString * foodItemUid in foodItemsDict) {
            
            NSDictionary * fooditem = foodItemsDict[foodItemUid];
            
            [foodItems addObject:fooditem];
            
        }
        
       
        
        done(foodItems);
        
    }];
    
    
    
    
    
    
    
}





-(NSMutableArray *)getAllRestaurantUids{
    
    NSLog(@"all restaurant uid : %@",restaurantUidArray);
    return restaurantUidArray;
}


@end
