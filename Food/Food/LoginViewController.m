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

@interface LoginViewController ()< FBSDKLoginButtonDelegate,UITextFieldDelegate>
{
    Helper * helper;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FbLoginView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        // Sign-out succeeded
    }
    
    
    helper = [Helper sharedInstance];
    
    
    self.FbLoginView.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goMainView) name:@"doneLogin" object:nil];
    
    
    
}


-(void)goMainView{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    [self presentViewController:tabVC animated:true completion:nil];
}



-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
//    if ([FBSDKAccessToken currentAccessToken].tokenString) {
//        
//        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarVC"];
//        
//        [self presentViewController:tabVC animated:true completion:nil];
//    }
    
    
    if ([helper uidOfCurrentUser]) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        
        [self presentViewController:tabVC animated:true completion:nil];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)emailLoginBtn:(id)sender {
    
    NSString * emailString = self.emailTextField.text;
    NSString * passwordString = self.passwordTextField.text;
    
    [helper signInWithEmail:emailString password:passwordString];
    
    
}


- (IBAction)createAccBtn:(id)sender {
    
    NSString * emailString = self.emailTextField.text;
    NSString * passwordString = self.passwordTextField.text;
    
    [helper signUpWithEmail:emailString password:passwordString];
    
    [self setNameAlert];
    
}

-(void)setNameAlert{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"設定" message:@"請輸入名字" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.tag = 1;
        textField.enablesReturnKeyAutomatically = true;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"請輸入名字";
        textField.delegate = self;
        
    }];
    
    [self presentViewController:alert animated:true completion:nil];
    
    
    
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
        
        
        [helper loginWithCredential:[FBSDKAccessToken currentAccessToken].tokenString];
        
                //------------ for facebook------------//
       // self.FbLoginView.hidden = true;
        
    }
    
    
}


- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    NSLog(@"did tapped fb log out");
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
            //get new name
        NSString * userName = textField.text;
        
        
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    
        [self dismissViewControllerAnimated:true completion:nil];
    
    
    NSDictionary * userNameDict = @{@"UserName":userName};
    [helper uploadUserData:userNameDict];
    [helper switchToMainView:self];
    
}




@end
