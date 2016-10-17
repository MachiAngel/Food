//
//  RestaurantInfo.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/17.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"
@import Firebase;

typedef void (^DoneHandler)(NSMutableArray * result);

@interface RestaurantInfo : NSObject

+(instancetype)sharedInstance;

-(void)getAllRestaurantArray:(DoneHandler)done;

@end
