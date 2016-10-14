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

//-(void)loginAnonymously:(UIViewController*)view{
//    
//    NSLog(@"按了登入");
//    
//    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
//        
//        if (error) {
//            NSLog(@"%@",error.localizedDescription);
//            return ;
//        }else{
//           
//           
//            NSString * currentUserUid = [[[FIRAuth auth]currentUser]uid];
//            NSLog(@"%@",currentUserUid);
//            
//           
//            
//            
//            
//            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            UITabBarController * myTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
//            
//           
//
//            
//        } //end if
//        
//        
//    }]; //end sign in
//    
//}

-(void)loginWithCredential:(NSString *)loginCredential{
    
    FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                     credentialWithAccessToken:loginCredential];
    
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error.description);
            return ;
        }else{
            NSLog(@"credential  ok");
            
           
            
        
        //picture.width(300).height(300)
            
            [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"name"} HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                if (error) {
                    
                    NSLog(@"%@", [error localizedDescription]);
                    
                }else{
                    NSLog(@"11111111111111");
                    NSLog(@"%@",result);
                    NSString * name = [result objectForKey:@"name"];
                    
                    NSLog(@"11111111111111");
                    NSLog(@"name:%@",name);
                    NSLog(@"name:%@",name);
                    NSLog(@"name:%@",name);
                    NSLog(@"name:%@",name);
                    
                }
                
            }];

            
            
            
            
            
            
        }
    
    }];
    
}

#pragma mark - Switch View

-(void)switchToMainView:(UIViewController *)view{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController * myTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    
   
    
    //[view presentViewController:myTabBarVC animated:true completion:nil];
    
}


-(void)switchToLoginView:(UIViewController *)view{
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController * loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginVeiw"];
    
    
    
   //[view presentViewController:myTabBarVC animated:true completion:nil];
    
    
}



#pragma mark - upload to Firebase


-(void)setDataToDatabase:(NSString *)key andValue:(NSString *)value{
    NSString * userInfo = @"userInfo";
    NSString * currentUserUid = [[[FIRAuth auth]currentUser]uid];
    NSLog(@"%@",currentUserUid);
    
    //設定到firebase
    
    [[[[[[FIRDatabase database] reference]child:userInfo]child:currentUserUid]child:key ] setValue:value];
    
}




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



-(void)setUserLoginWay:(NSString*)loginWay{
    
   
  
}


#pragma mark - Delete anonymous user acc or logout

-(void)deleteAnonymousAccount{
    [[self getDatabaseRefOfCurrentUser]removeAllObservers];
    
    [[self getDatabaseRefOfCurrentUser]setValue:nil];
    
    
    [[FIRAuth auth].currentUser deleteWithCompletion:^(NSError * _Nullable error) {
        
    }];
    
    
    
}


-(void)logoutWithAnonymously:(UIViewController*)view{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"警告" message:@"登出後你所儲存的資料將會消失" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"確定登出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Group"];
        //移除觀察 , 不然會當機
        [[_helper getDatabaseRefOfCurrentUser]removeAllObservers];
        
        //移除匿名使用者資料
        [[_helper getDatabaseRefOfCurrentUser] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            NSLog(@"remove ok");
        }];
        
        //移除照片
        [[_helper getStorageRefOfCurrentUser] deleteWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error.description);
                return ;
            }
            
        }];
        
        
        
        //移除匿名使用者帳號並跳回畫面
        [[FIRAuth auth].currentUser deleteWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error.description);
                return ;
            }else{
                [_helper switchToLoginView:nil];
            }
            
        }];
        
        
    }];
    //取消action
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [view presentViewController:alertVC animated:true completion:nil];
    
    
}


-(void)logoutWithFacebook{
    
    
    [_helper setDataToDatabase:@"IsOnline" andValue:@"0"];
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (error) {
        NSLog(@"%@",error.description);
        return;
        
        
    }else{
        NSLog(@"登出");
        
    
        
        
        //[[[_helper getDatabaseRefOfUsersInfo]child:@"IsOnline"]setValue:@"0"];
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        [_helper switchToLoginView:nil];
        
    }
    
    
}


#pragma mark - Get Firebase Ref

-(FIRDatabaseReference *)getDatabaseRefOfCurrentUser{
    
    
    return [[[[FIRDatabase database]reference]child:@"userInfo"]child:[FIRAuth auth].currentUser.uid];

}

-(FIRDatabaseReference *)getDatabaseRefOfUsersInfo{
    
    return [[[FIRDatabase database]reference]child:@"userInfo"];
}



-(FIRStorageReference *)getStorageRefOfCurrentUser{
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    
    
    FIRStorageReference *ref = [storageRef child:[FIRAuth auth].currentUser.uid];
    
    FIRStorageReference *picRef = [ref child:@"image/pic.jpg"];
    
    return picRef;
    
}


-(NSString *)uidOfCurrentUser{
    
    return [[[FIRAuth auth]currentUser]uid];
}

@end
