//
//  Helper.h
//  FindMyFriend
//
//  Created by Shiang-Yu Huang on 2016/9/11.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@import Firebase;


@interface Helper : NSObject






+(instancetype)sharedInstance;

-(void)setDataToDatabase:(NSString*)key andValue:(NSString*)value;




-(void)switchToMainView:(UIViewController*)view;

-(void)switchToLoginView:(UIViewController*)view;



-(void)putImageToStorage:(NSData*)imageData;


-(void)deleteAnonymousAccount;
    
-(FIRDatabaseReference *)getDatabaseRefOfCurrentUser;

-(FIRStorageReference *)getStorageRefOfCurrentUser;

-(FIRDatabaseReference *)getDatabaseRefOfUsersInfo;


-(NSString*)uidOfCurrentUser;



-(void)loginWithCredential:(NSString *)loginCredential;

-(void)logoutWithAnonymously:(UIViewController*)view;

-(void)logoutWithFacebook;



@end
