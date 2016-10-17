//
//  Helper.h
//  FindMyFriend
//
//  Created by Shiang-Yu Huang on 2016/9/11.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//shop info dict
#define DICT_SHOP_NAME_KEY  @"FoodName"
#define DICT_SHOP_ADDRESS_KEY  @"ShopAddress"
#define DICT_SHOP_PHONE_KEY  @"ShopPhone"



//food dict
#define DICT_FOOD_NAME_KEY  @"FoodName"
#define DICT_FOOD_PRICE_KEY  @"FoodPrice"
#define DICT_FOOD_IMAGE_KEY  @"FoodImage"

@import Firebase;


@interface Helper : NSObject






+(instancetype)sharedInstance;


-(void)loginWithCredential:(NSString *)loginCredential;


-(void)uploadRestaurantData:(NSDictionary*)RestaurantInfo
                  mainImage:(NSData*) mainImageData
                      child:(NSString*)childString;



-(void)uploadFoodItemsImageToStorage:(NSMutableArray *)imageDataArray
                               child:(NSString*)childString;

-(NSString *)getRandomChild;


//--------------------------------------------------------------//


-(void)switchToMainView:(UIViewController*)view;

-(void)switchToLoginView:(UIViewController*)view;



-(void)putImageToStorage:(NSData*)imageData;


-(void)deleteAnonymousAccount;
    
-(FIRDatabaseReference *)getDatabaseRefOfCurrentUser;



-(FIRDatabaseReference *)getDatabaseRefOfUsersInfo;


-(NSString*)uidOfCurrentUser;




@end
