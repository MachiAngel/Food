//
//  LoginViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/12.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginViewController.h"
#import "Helper.h"

@interface LoginViewController ()< FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FbLoginView;
@property (strong,nonatomic) Helper * helper;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _helper = [Helper sharedInstance];
    
    
    self.FbLoginView.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)emailLoginBtn:(id)sender {
}
- (IBAction)createAccBtn:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - FaceBook login Delegate



- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error{
    
    
    if (error) {
        NSLog(@"error: %@",error.description);
    }else if (result.isCancelled){
        NSLog(@"user cancel");
    }else{
        
        //-------------for firebase-------------//
        NSLog(@"%@",[FBSDKAccessToken currentAccessToken].tokenString);
        
        
        [_helper loginWithCredential:[FBSDKAccessToken currentAccessToken].tokenString];
        
                //------------ for facebook------------//
       // self.FbLoginView.hidden = true;
        
    }
    
    
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    NSLog(@"did tapped fb log out");
    
}



@end