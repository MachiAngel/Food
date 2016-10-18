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
        
        [self switchToMainView:nil];
        
        
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
        }
        
        
        NSDictionary * userInfo = @{@"Email":email,@"Password":password};
        
        [self uploadUserData:userInfo];
        
    }];
    
}

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
                    
                    
                    NSDictionary * userInfo = @{@"UserName":name,@"Email":email};
                    
                    [self uploadUserData:userInfo];
                    
                    
                    
                }
                
            }];


            
        }
    
    }];
    
}

#pragma mark - Switch View

-(void)switchToMainView:(UIViewController *)view{
    

    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    [view presentViewController:tabVC animated:true completion:nil];
    
    
}


-(void)switchToLoginView:(UIViewController *)view{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   // UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginVeiw"];
    
    
    
   //[view presentViewController:myTabBarVC animated:true completion:nil];
    
    
}



#pragma mark - upload to Firebase


//可能還要存放使用者資訊的方法
//還要改 存放餐廳資訊之類的參數



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
               
               
           }];
            
            
        }];
        
    
        
        
    }
    
    
    
    
}











//還要改 存放地點改參數  才能存不同區圖片
-(void)putImageToStorage:(NSData*)imageData{
    
    
    
    NSString * uid = [[[FIRAuth auth]currentUser] uid];

    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    
    FIRStorageReference *ref = [storageRef child:uid];
    
    FIRStorageReference *picRef = [ref child:@"image/pic.jpg"];
    
    [picRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        
       
        NSString * picUrlstring = [metadata.downloadURL absoluteString];
        
        //下載網址放到 database
        [[[self getDatabaseRefOfCurrentUser]child:@"pic" ] setValue:picUrlstring];
    
    }];
}






#pragma mark - Delete anonymous user acc or logout

-(void)deleteAnonymousAccount{
    [[self getDatabaseRefOfCurrentUser]removeAllObservers];
    
    [[self getDatabaseRefOfCurrentUser]setValue:nil];
    
    
    [[FIRAuth auth].currentUser deleteWithCompletion:^(NSError * _Nullable error) {
        
    }];
    
    
    
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
         

         
         
         

//storge

-(FIRStorageReference *)getStorageRefOfRestaurant{
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    FIRStorageReference *ref = [storageRef child:@"Restaurant"];
    
    
    return ref;
    
}


-(NSString *)uidOfCurrentUser{
    
    return [[[FIRAuth auth]currentUser]uid];
}

-(NSString *)getRandomChild{
    
    NSString *child = [[[FIRDatabase database]reference]childByAutoId].key;
    
    return child;
}

@end
