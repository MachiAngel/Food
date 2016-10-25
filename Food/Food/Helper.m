//
//  Helper.m
//  FindMyFriend
//
//  Created by Shiang-Yu Huang on 2016/9/11.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//


#import "Helper.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


static Helper * _helper;

@implementation Helper

+(instancetype)sharedInstance{
    
    
    
    if (_helper == nil) {
        _helper = [Helper new];
    
    }
    
    return _helper;
    
}

#pragma mark - Login to Firebase


-(void)uploadUserData:(NSDictionary*)info{
    
    NSString * userInfo = @"userInfo";
    NSString * currentUserUid = [[[FIRAuth auth]currentUser]uid];
    
    [[[[[FIRDatabase database] reference]child:userInfo]child:currentUserUid]updateChildValues:info withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSLog(@"down upload userInfo");
    }];
    
}


//直接登入

-(void)signInWithEmail:(NSString *)email
              password:(NSString*)password{
    
    [[FIRAuth auth]signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"Email sign error");
            return ;
        }
        
        NSLog(@"Email sign in success");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"singInDone" object:nil];
        
    }];
    
}


//創帳號

-(void)signUpWithEmail:(NSString*)email
              password:(NSString*)password{
    
    [[FIRAuth auth]createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            //可以讓使用者知道為何失敗
            NSLog(@"%@",error);
            return ;
        }else{
            
            NSDictionary * userInfo = @{@"Email":email,@"Password":password};
            
            [self uploadUserData:userInfo];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"createAcc" object:nil];
            
        }
        
        
        
    }];
    
}

//FB登入
-(void)loginWithCredential:(NSString *)loginCredential{
    
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:loginCredential];
    
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error.description);
            return ;
        }else{
            NSLog(@"Firebase credential  ok");
            
           
            
        
        //picture.width(300).height(300)
            
            [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"name"} HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                if (error) {
                    
                    NSLog(@"%@", [error localizedDescription]);
                    
                }else{
                     //result 一個字典 , 可拿 id ,name , email
                    NSLog(@"%@",result);
                    NSString * name = [result objectForKey:@"name"];
                    NSString * email = [result objectForKey:@"email"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    if (!email) {
                        email = @"nil";
                    }
                    
                    
                    NSDictionary * userInfo = @{@"UserName":name,@"Email":email};
                    
                    [self uploadUserData:userInfo];
                    
                    
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"doneLogin" object:nil];;
                    
                    
                    
                }
                
            }];


            
        }
    
    }];
    
}

#pragma mark - Switch View

-(void)switchToMainView:(UIViewController *)view{
    

//    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarVC"];
//    
//    [view presentViewController:tabVC animated:true completion:nil];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController * myTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = myTabBarVC;
    [app.window makeKeyAndVisible];
    
}


#pragma mark - upload to Firebase

-(void)uploadRestaurantData:(NSDictionary*)RestaurantInfo
                  mainImage:(NSData*) mainImageData
                      child:(NSString*)childString{
    
    
    [[[self getDatabaseRefOfRestaurants]child:childString]updateChildValues:RestaurantInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSLog(@"down Info upload");
    }];
    
    
    [self uploadMainImageToStorage:mainImageData child:childString];
    
    
    
}

//inside method
-(void)uploadMainImageToStorage:(NSData*) mainImageData
                          child:(NSString*)childString{
    
    
    
    
    //ref restaurant
    
    FIRStorageReference *storageRef = [[self getStorageRefOfRestaurant]child:childString];
    
    
    
    //main pic position
    FIRStorageReference *mainPicRef = [storageRef child:@"MainPic.jpg"];
    
    //main pic update
    [mainPicRef putData:mainImageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        
        
        //拿到下載字串
        NSString * MainUrlstring = [metadata.downloadURL absoluteString];
        NSDictionary * mainImageDict = @{@"MainImage":MainUrlstring};
        
        //下載網址放到 database
        
        [[[self getDatabaseRefOfRestaurants]child:childString]updateChildValues:mainImageDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            
            if (error) {
                NSLog(@"%@",error);
                return ;
            }
            
            NSLog(@"down Main imageString upload");
            
            
        }];
        
       
    }];
}



-(void)uploadFoodItemsImageToStorage:(NSMutableArray*)imageDataArray child:(NSString*)childString{
    
    
    
    //ref restaurant
    
    FIRStorageReference *storageRef = [[self getStorageRefOfRestaurant]child:childString];
    
   
    for (int i = 0; i < imageDataArray.count; i ++) {
        
        NSDictionary * eachItem = imageDataArray[i];
        
        NSData * eachImageData = eachItem[DICT_FOOD_IMAGE_KEY];
        NSString * eachItemName = eachItem[DICT_FOOD_NAME_KEY];
        NSString * eachItemPrice = eachItem[DICT_FOOD_PRICE_KEY];
        
        NSString * fileName = [NSString stringWithFormat:@"%d.jpg",i+1];
        
        FIRStorageReference *nameRef =  [storageRef child:fileName];
        
        [nameRef putData:eachImageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"上傳照片失敗:%@",error);
                return ;
            }
            
            
            NSString * foodItemImageString = [metadata.downloadURL absoluteString];
            
            
            NSDictionary * FoodItemDict = @{@"FoodImageString":foodItemImageString,@"FoodName":eachItemName,@"FoodPrice":eachItemPrice};
            
           [[[[self getDatabaseRefOfFoodItems]child:childString]childByAutoId]updateChildValues:FoodItemDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
               
               if (error) {
                   NSLog(@"%@",error);
                   return ;
               }
               
               NSLog(@"down each imageString upload");
               [[NSNotificationCenter defaultCenter]postNotificationName:@"doneAddShop" object:nil];
               
           }];
            
            
        }];
        
     
    }
    
    
}



#pragma mark - Create Menu Method


-(void)createMenuWith:(NSString*)menuUid menuItialize:(NSDictionary *)menu{
    
    [[[self getDatabaseRefOfMenus]child:menuUid]updateChildValues:menu withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        
        if (error) {
            NSLog(@"create menu error:%@",error);
            return ;
        }
        
        [self createMenuUsersWith:menuUid];
        
        
    }];
    
    
}


-(void)changeStatusWithMenuUid:(NSString*)menuUid status:(NSString*)status{
    
    
    NSString * currentUserUid = [self uidOfCurrentUser];
    
    NSDictionary * userInfo = @{@"SelfStatus":status};
    
    
    
    [[[[self getDatabaseRefOfMenuUsers]child:menuUid]child:currentUserUid]updateChildValues:userInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            NSLog(@"create menu error:%@",error);
            return ;
        }
        
        
        
    }];
    
    
    
}

-(void)createMenuUsersWith:(NSString*)menuUid{
    
    NSString * currentUserUid = [self uidOfCurrentUser];
    
    NSString * userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSDictionary * userInfo = @{@"UserName":userName,@"SelfStatus":@"0"};
    
    
    
    [[[[self getDatabaseRefOfMenuUsers]child:menuUid]child:currentUserUid]updateChildValues:userInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            NSLog(@"create menu error:%@",error);
            return ;
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Created" object:nil];
  
    }];
    
    
}

//for OrderViewController
-(void)selectedMenuUsersWith:(NSString*)menuUid{
    
    NSString * currentUserUid = [self uidOfCurrentUser];
    
    NSString * userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSDictionary * userInfo = @{@"UserName":userName,@"SelfStatus":@"0"};
    
    
    
    [[[[self getDatabaseRefOfMenuUsers]child:menuUid]child:currentUserUid]updateChildValues:userInfo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            NSLog(@"create menu error:%@",error);
            return ;
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Selected" object:nil];
        
    }];
    
    
}





-(void)uploadUserOrderWithMenuUid:(NSString*)uid andOrder:(NSDictionary*)dict{
    
    NSString * userUid = [self uidOfCurrentUser];
    
    
    [[[[self getDatabaseRefOfMenuOrderList]child:uid]child:userUid]updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            NSLog(@"error: %@",error);
            return ;
        }else{
            NSLog(@"success upload");
        }

    }];
    
  
}

-(void)uploadtotalPriceWithUid:(NSString*)uid andPrice:(NSDictionary*)dict{
    
    [[[self getDatabaseRefOfMenus]child:uid]updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            NSLog(@"error: %@",error);
            return ;
        }else{
            NSLog(@"success upload");
        }
        
    }];
    
}




-(void)deleteUserOrderWithMenuUid:(NSString*)uid{
    
    NSString * userUid = [self uidOfCurrentUser];
    
    
    [[[[self getDatabaseRefOfMenuOrderList]child:uid]child:userUid]removeValue];
    
    
}




-(void)quitAndDeleteDataFromSelector:(NSString*)menuUid{
    
    NSString * currentUserUid = [self uidOfCurrentUser];
    
    [[[[self getDatabaseRefOfMenuUsers]child:menuUid]child:currentUserUid]removeValue];
   [[[[self getDatabaseRefOfMenuOrderList]child:menuUid]child:currentUserUid]removeValue];
}


-(void)quitAndDeleteDataFromCreater:(NSString*)menuUid{
    
    
    
    [[[self getDatabaseRefOfMenuOrderList]child:menuUid]removeValue];
    [[[self getDatabaseRefOfMenuUsers]child:menuUid]removeValue];
    [[[self getDatabaseRefOfMenus]child:menuUid]removeValue];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"createrLeave" object:nil];
}



-(void)createrUploadSendNotice:(NSString *)menuUid{
    
    NSDictionary * notice = @{@"Notice":@"1"};
    [[[self getDatabaseRefOfMenuNotice]child:menuUid]updateChildValues:notice];
    
}

-(void)createrSendBtnPressed:(NSString*)menuUid{
    
    [[[self getDatabaseRefOfMenuUsers]child:menuUid]removeValue];
    
    [[[self getDatabaseRefOfMenuOrderList]child:menuUid]removeValue];
    
    [[[self getDatabaseRefOfMenus]child:menuUid]removeValue];
    

    
    
}



#pragma mark - Get Firebase Ref

-(FIRDatabaseReference *)getDatabaseRefOfCurrentUser{
    
    
    return [[[[FIRDatabase database]reference]child:@"userInfo"]child:[FIRAuth auth].currentUser.uid];

}



-(FIRDatabaseReference *)getDatabaseRefOfUsersInfo{
    
    return [[[FIRDatabase database]reference]child:@"userInfo"];
}




-(FIRDatabaseReference *)getDatabaseRefOfRestaurants{
    
    
    return [[[FIRDatabase database]reference]child:@"Restaurants"];
    
}

         
-(FIRDatabaseReference *)getDatabaseRefOfFoodItems{

    return [[[FIRDatabase database]reference]child:@"FoodItems"];
    
}


-(FIRDatabaseReference *)getDatabaseRefOfMenus{
    
    
    return [[[FIRDatabase database]reference]child:@"Menus"];
    
}
-(FIRDatabaseReference *)getDatabaseRefOfMenuUsers{
    
    
    return [[[FIRDatabase database]reference]child:@"MenuUsers"];
    
}

-(FIRDatabaseReference *)getDatabaseRefOfMenuOrderList{
    
    
    return [[[FIRDatabase database]reference]child:@"OrderList"];
    
}

-(FIRDatabaseReference *)getDatabaseRefOfMenuNotice{
    
    
    return [[[FIRDatabase database]reference]child:@"MenuNotice"];
    
}

//storge

-(FIRStorageReference *)getStorageRefOfRestaurant{
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    FIRStorageReference *ref = [storageRef child:@"Restaurant"];
    
    
    return ref;
    
}


#pragma mark - Other Method

-(NSString *)uidOfCurrentUser{
    
    return [[[FIRAuth auth]currentUser]uid];
}

-(NSString *)getRandomChild{
    
    NSString *child = [[[FIRDatabase database]reference]childByAutoId].key;
    
    return child;
}

@end
