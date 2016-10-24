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
#define DICT_SHOP_NAME_KEY  @"ShopName"
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


-(void)signUpWithEmail:(NSString*)email
              password:(NSString*)password;


-(void)signInWithEmail:(NSString *)email
              password:(NSString*)password;



-(void)uploadUserData:(NSDictionary*)info;


// detailTableView method for add menu
-(void)createMenuWith:(NSString*)menuUid menuItialize:(NSDictionary *)menu;

//  addMenuViewController method for  test cancel
-(void)changeStatusWithMenuUid:(NSString*)menuUid status:(NSString*)status;


// detailTableView method for add menu
// ordersViewController method for join the order
-(void)createMenuUsersWith:(NSString*)menuUid;
-(void)selectedMenuUsersWith:(NSString*)menuUid;


//  addMenuViewController method for quit and delete
-(void)quitAndDeleteDataFromSelector:(NSString*)menuUid;
-(void)quitAndDeleteDataFromCreater:(NSString*)menuUid;


// AddMenuViewController method for "user choose order and ok"
-(void)uploadUserOrderWithMenuUid:(NSString*)uid andOrder:(NSDictionary*)dict;
-(void)uploadtotalPriceWithUid:(NSString*)uid andPrice:(NSDictionary*)dict;


// AddmenuViewController method for cancel order
-(void)deleteUserOrderWithMenuUid:(NSString*)uid;



-(FIRDatabaseReference *)getDatabaseRefOfRestaurants;

-(FIRDatabaseReference *)getDatabaseRefOfFoodItems;

-(FIRDatabaseReference *)getDatabaseRefOfCurrentUser;

-(FIRDatabaseReference *)getDatabaseRefOfMenus;

-(FIRDatabaseReference *)getDatabaseRefOfMenuUsers;

-(FIRDatabaseReference *)getDatabaseRefOfMenuOrderList;

//--------------------------------------------------------------//


-(void)switchToMainView:(UIViewController*)view;



-(FIRDatabaseReference *)getDatabaseRefOfUsersInfo;


-(NSString*)uidOfCurrentUser;




@end
