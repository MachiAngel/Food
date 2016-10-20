//
//  OrderModel.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/21.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"
@import Firebase;

typedef void (^DoneHandler)(NSMutableArray * result);

@interface OrderModel : NSObject

+(instancetype)sharedInstance;

-(void)getOrdersArray:(DoneHandler)done;

-(NSMutableArray*)getOrdersKeyArray;


@end
