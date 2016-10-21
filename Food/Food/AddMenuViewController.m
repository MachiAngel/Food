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
    
    //未用
    //FIRDatabaseHandle * _refHandle;
}

@property (nonatomic,assign) ToThisViewType typeVar;

@property (weak, nonatomic) IBOutlet UICollectionView *usersCollectionView;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // selecter listen if creater leave
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitThisPage) name:@"noUser" object:nil];
    //creater leave
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitThisPage) name:@"createrLeave" object:nil];
    
    
    restaurantManager = [RestaurantInfo sharedInstance];
    helper = [Helper sharedInstance];
    
    //判斷從哪邊進來的
    if (self.selectedOrderKeyString) {
        self.typeVar = ToThisViewTypeFromSelected;
    }else{
        self.typeVar = ToThisViewTypeFromCreate;
    }
    
    
    //執行拿到所有進來的人 持續監控~
    [self getUserArray:self.typeVar];
    
   
    
    
    
    
    
    
    //顯示當下餐廳用
    
    
    
    
}


-(void)getUserArray:(ToThisViewType)type{
    
    if (type == ToThisViewTypeFromSelected) {
        
        //顯示當下使用者用 (包含自己)
        [[[helper getDatabaseRefOfMenuUsers]child:self.selectedOrderKeyString]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            usersArray = [NSMutableArray new];
            
            
            NSDictionary * resultDict = snapshot.value;
            
            if ([resultDict isEqual:[NSNull null]]) {
                NSLog(@"沒用戶了");
                NSLog(@"沒用戶了");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noUser" object:nil];
                
            }else{
                
                for (NSString * userUid in resultDict) {
                    
                    NSDictionary * eachUser = resultDict[userUid];
                    
                    [usersArray addObject:eachUser];
                    
                }
                
                [self.usersCollectionView reloadData];
                
            }
            
           
            
        }];
        
        
    }else{
        //從 create menu
        
        NSString * createdMenuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        //顯示當下使用者用 (包含自己)
        [[[helper getDatabaseRefOfMenuUsers]child:createdMenuUid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            usersArray = [NSMutableArray new];
            
            NSDictionary * resultDict = snapshot.value;
            
            if ([resultDict isEqual:[NSNull null]]) {
                NSLog(@"沒用戶了");
                NSLog(@"沒用戶了");
            }else{
                
                for (NSString * userUid in resultDict) {
                    
                    NSDictionary * eachUser = resultDict[userUid];
                    
                    [usersArray addObject:eachUser];
                    
                    
                }
                
                [self.usersCollectionView reloadData];
                
            }
            
            
            
            
        }];
        
        
    }
    
    
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
    
    
    
    NSString * cancelStatusString = @"1";
    
    [self changeStauts:cancelStatusString];
    
    
}



- (IBAction)cancelBtn:(id)sender {
    
    
    NSString * cancelStatusString = @"0";
    
    [self changeStauts:cancelStatusString];
    

    
}

-(void)changeStauts:(NSString *)statusString{
    
    //一樣判斷從哪邊進來, 才能改 狀態
    
    if (self.typeVar == ToThisViewTypeFromSelected) {
        //from selected order
        
        //NSString * cancelPress = @"0";
        
        [helper changeStatusWithMenuUid:self.selectedOrderKeyString status:statusString];
    }else{
        //from create
        
        
        NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper changeStatusWithMenuUid:menuUid status:statusString];
        
    }
    
    
    
    
    
}








- (IBAction)quitThisPageBtnPressed:(id)sender {
    
    //刪除記錄 , 分創建者 與 加入者
    if (_typeVar == ToThisViewTypeFromSelected) {
        // selecter leave
        [helper quitAndDeleteDataFromSelector:self.selectedOrderKeyString];
        
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        // creater leave
         NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper quitAndDeleteDataFromCreater:menuUid];
        
    }
    
    
}

-(void)quitThisPage{
    
    if (self.typeVar == ToThisViewTypeFromSelected) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"創立訂單者取消此訂單" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        
                [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
   
}

@end
