//
//  AddMenuViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/19.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "AddMenuViewController.h"
#import "UserCollectionViewCell.h"
#import "Helper.h"
#import "RestaurantInfo.h" //拿到點餐列表

@import Firebase;


@interface AddMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    //顯示當下裡面使用者
    NSMutableArray * usersArray;
    Helper * helper;
    RestaurantInfo * restaurantManager;
}
@property (weak, nonatomic) IBOutlet UICollectionView *usersCollectionView;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString * createdMenuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
    
    restaurantManager = [RestaurantInfo sharedInstance];
    helper = [Helper sharedInstance];
    
    
    //顯示當下使用者用
    [[[helper getDatabaseRefOfMenuUsers]child:createdMenuUid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        usersArray = [NSMutableArray new];
        
        NSDictionary * resultDict = snapshot.value;
        
        for (NSString * userUid in resultDict) {
            
            NSDictionary * eachUser = resultDict[userUid];
            
            [usersArray addObject:eachUser];
            
            
        }
        
        [self.usersCollectionView reloadData];
        
    }];
    
    
    //顯示當下餐廳用
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return usersArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.userImage.image = [UIImage imageNamed:@"user1.jpeg"];
    
    NSDictionary * each = usersArray[indexPath.row];
    
    cell.userNameLabel.text = each[@"UserName"];
    
    
    NSString * status = each[@"SelfStatus"];
    
    if ([status isEqualToString:@"0"]) {
         cell.userImage.layer.borderColor = [UIColor redColor].CGColor;
    }else if ([status isEqualToString:@"1"]){
        cell.userImage.layer.borderColor = [UIColor greenColor].CGColor;
    }
    
    
    
    
   
    
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)okBtn:(id)sender {
    
    NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
    
    NSString * okPressed = @"1";
    
    
    [helper changeStatusWithMenuUid:menuUid status:okPressed];
    
}
- (IBAction)cancelBtn:(id)sender {
    
    NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
    
    NSString * cancelPress = @"0";
    
    
    [helper changeStatusWithMenuUid:menuUid status:cancelPress];
    
}

@end
