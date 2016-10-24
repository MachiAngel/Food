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
    
    //for addMenu
    NSMutableArray * orderList;
    NSDictionary * createMenuInfo;
    
    FIRDatabaseHandle  _handleWithTotalPrice;
    FIRDatabaseHandle  _handleWithOrderList;
    
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


-(void)getCreateMenuInfo:(NSString*)uid handler:(DoneHandlerDict)done{
    
     Helper * helper = [Helper sharedInstance];
    createMenuInfo = [NSDictionary new];
    
    [[[helper getDatabaseRefOfMenus]child:uid]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        createMenuInfo = snapshot.value;
        
        done(createMenuInfo);
    }];
    
}



-(void)getOrderListArrayWithUid:(NSString*)uid handler:(DoneHandler)done{
    
    Helper * helper = [Helper sharedInstance];
    
    _handleWithOrderList = [[[helper getDatabaseRefOfMenuOrderList]child:uid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        orderList = [NSMutableArray new];
        
        NSDictionary * orderListDict = snapshot.value;
        
        if ([orderListDict isEqual: [NSNull null]]) {
            NSLog(@"沒值");
        }else{
            
            for (NSString * userUid in orderListDict) {
                
                NSDictionary *eachOrderList = orderListDict[userUid];
                
                [orderList addObject:eachOrderList];
                
            }
            
        }
        
        done(orderList);
        
    }];
    
    
}




-(void)getTotalPriceWithMenuUid:(NSString*)uid handler:(DoneHandlerString)done{
    
    Helper * helper = [Helper sharedInstance];
    
   _handleWithTotalPrice = [[[helper getDatabaseRefOfMenus]child:uid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
       
        
        NSDictionary * menuInfo = snapshot.value;
        
        if ([menuInfo isEqual:[NSNull null]]) {
            NSLog(@"total null");
        }else{
            
            NSString * totalPrice = menuInfo[@"TotalPrice"];
            
            done(totalPrice);
            
        }
        
        
       
        
    }];

    
    
}




-(NSMutableArray *)getAllRestaurantUids{
    
    NSLog(@"all restaurant uid : %@",restaurantUidArray);
    return restaurantUidArray;
}

-(void)removeHandlerWithMenuUid:(NSString*)uid{
    
    Helper * helper = [Helper sharedInstance];
    
    [[[helper getDatabaseRefOfMenuOrderList]child:uid]removeObserverWithHandle:_handleWithOrderList];
    
    [[[helper getDatabaseRefOfMenus]child:uid]removeObserverWithHandle:_handleWithTotalPrice];
    
    
}


@end
