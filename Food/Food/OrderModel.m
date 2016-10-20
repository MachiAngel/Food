//
//  OrderModel.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/21.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "OrderModel.h"

static OrderModel * _orderManager;

@implementation OrderModel
{
    
    //for tableView
    NSMutableArray * ordersArray;
    
    //for did selected cell use
    NSMutableArray * ordersKeyArray;
    
//    //for detail
//    NSMutableArray * foodItems;
    
}


+(instancetype)sharedInstance{
    
    if (_orderManager == nil) {
        
        _orderManager = [OrderModel new];
        
    }
    
    return _orderManager;
    
}



-(void)getOrdersArray:(DoneHandler)done{
    
    Helper * helper = [Helper sharedInstance];
    
    
   //observeEventType
    //observeSingleEventOfType
    
    [[helper getDatabaseRefOfMenus]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        
        
        ordersArray = [NSMutableArray new];
        ordersKeyArray = [NSMutableArray new];
        
            
        NSDictionary * ordersDict = snapshot.value;
        
        NSLog(@"CC%@",ordersDict);
        NSLog(@"CC%@",ordersDict);
        NSLog(@"CC%@",ordersDict);
        
        if ([ordersDict isEqual: [NSNull null]]) {
            NSLog(@"沒值");
        }else{
            
            for (NSString * orderUid in ordersDict) {
                
                NSDictionary * eachOrder = ordersDict[orderUid];
                
                [ordersArray addObject:eachOrder];
                [ordersKeyArray addObject:orderUid];
            }
        
            
        }
        
        done(ordersArray);
        
        
    }];
    
    
    
    
}

// use it in outside block
-(NSMutableArray*)getOrdersKeyArray{
    return ordersKeyArray;
}


@end
