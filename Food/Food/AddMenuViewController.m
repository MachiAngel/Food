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
#import "OrderPickerView.h"
#import "orderListTableViewCell.h"




@interface AddMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //顯示當下裡面使用者
    NSMutableArray * usersArray;
    
    //拿到最後整理好的品項array
    NSMutableArray * menuArray;
    
    //判斷是否status 全部都ok
    NSMutableArray * statusOkArray;
    
    //拿到使用者點餐資訊array
    NSMutableArray * usersOrderArray;
    
    
    Helper * helper;
    RestaurantInfo * restaurantManager;
    
    //未用
    //FIRDatabaseHandle * _refHandle;
}

@property (nonatomic,assign) ToThisViewType typeVar;

@property (weak, nonatomic) IBOutlet UICollectionView *usersCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCreaterLabel;


@property (weak, nonatomic) IBOutlet UIButton *sendOrderBtnView;
@property (weak, nonatomic) IBOutlet UIButton *chooseOrderBtnView;



@property (weak, nonatomic) IBOutlet UITableView *orderlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *showFinishLabel;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showFinishLabel.text = @"";
    
    // selecter listen if creater leave
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitThisPage) name:@"noUser" object:nil];
    // listen creater leave
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitThisPage) name:@"createrLeave" object:nil];
    
    
    restaurantManager = [RestaurantInfo sharedInstance];
    helper = [Helper sharedInstance];
    
    //判斷從哪邊進來的
    if (self.selectedOrderKeyString) {
        self.typeVar = ToThisViewTypeFromSelected;
    }else{
        self.typeVar = ToThisViewTypeFromCreate;
    }
    
    
    //執行方法拿到所有進來的人 持續監控~
    [self getUserArray:self.typeVar];
    

    //執行方法拿到當下餐廳餐點用的品項array
    [self getFoodItems:self.typeVar];
    
    //handle sender btn
    
    if (self.typeVar == ToThisViewTypeFromSelected) {
        self.sendOrderBtnView.alpha = 0;
    }else{
        self.sendOrderBtnView.userInteractionEnabled = false;
        self.sendOrderBtnView.alpha = 0.5;
    }
    
    //持續觀察totalPrice
    [self observeTotalPriceLabel:self.typeVar];
    
    //持續觀察orderList
    [self observeOrderListForTableView:self.typeVar];
    
    
}

-(void)getFoodItems:(ToThisViewType)type{
    
    if (type == ToThisViewTypeFromSelected){
        
        [restaurantManager getRestaurantFoodItemArrayWithUid:self.SelectedRestaurantUid handler:^(NSMutableArray *result) {
            
            menuArray = [NSMutableArray new];
            
            
            for (int i = 0; i < result.count; i++) {
                NSDictionary * eachItem = result[i];
                
                NSString * foodName = eachItem[@"FoodName"];
                NSString * foodPrice = eachItem[@"FoodPrice"];
                
                NSString * showItem = [NSString stringWithFormat:@"%@ %@元",foodName,foodPrice];
                
                [menuArray addObject:showItem];
                
            }
            
        }];

        
        
    }else{
        
        NSString * RestaurantUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedRestaurant"];
        
        [restaurantManager getRestaurantFoodItemArrayWithUid:RestaurantUid handler:^(NSMutableArray *result) {
            
            menuArray = [NSMutableArray new];
            
            NSLog(@"QQQQQ%@",result);
            for (int i = 0; i < result.count; i++) {
                NSDictionary * eachItem = result[i];
                
                NSString * foodName = eachItem[@"FoodName"];
                NSString * foodPrice = eachItem[@"FoodPrice"];
                
                NSString * showItem = [NSString stringWithFormat:@"%@ %@元",foodName,foodPrice];
                
                [menuArray addObject:showItem];
                
            }
            
        }];
        
        
        
        
    }
    
}



-(void)observeOrderListForTableView:(ToThisViewType)type{
    
    if (type == ToThisViewTypeFromSelected) {
        
        //拿到使用者點餐資訊array
        //NSMutableArray * usersOrderArray;
        [restaurantManager getOrderListArrayWithUid:self.selectedOrderKeyString handler:^(NSMutableArray *result) {
            
            usersOrderArray = result;
            
            [self.orderlistTableView reloadData];
            
            
        }];
       
        
    }else{
        NSString * createdMenuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [restaurantManager getOrderListArrayWithUid:createdMenuUid handler:^(NSMutableArray *result) {
            
            usersOrderArray = result;
            
            [self.orderlistTableView reloadData];
            
            
        }];
        
        
        
    }
    
    
}



-(void)observeTotalPriceLabel:(ToThisViewType)type{
    
    if (type == ToThisViewTypeFromSelected) {
        
        [restaurantManager getTotalPriceWithMenuUid:self.selectedOrderKeyString handler:^(NSString *result) {
            
            NSString * totalPriceFinal = [NSString stringWithFormat:@"%@",result];
            
            self.totalPriceLabel.text = totalPriceFinal;
            
        }];
        
    }else{
         NSString * createdMenuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [restaurantManager getTotalPriceWithMenuUid:createdMenuUid handler:^(NSString *result) {
            
            NSString * totalPriceFinal = [NSString stringWithFormat:@"%@",result];
            
            self.totalPriceLabel.text = totalPriceFinal;
            
        }];

    }
    
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
            
            statusOkArray = [NSMutableArray new];
            
            NSDictionary * resultDict = snapshot.value;
            
            if ([resultDict isEqual:[NSNull null]]) {
                NSLog(@"沒用戶了");
                NSLog(@"沒用戶了");
            }else{
                
                for (NSString * userUid in resultDict) {
                    
                    NSDictionary * eachUser = resultDict[userUid];
                    [usersArray addObject:eachUser];
                    
                    //算綠燈
                    NSString * eachStatus = eachUser[@"SelfStatus"];
                    if ([eachStatus isEqualToString:@"1"]) {
                        [statusOkArray addObject:eachStatus];
                    }
                    
                    
                }
                //判斷是否全部按ok的時候
                if (usersArray.count == statusOkArray.count) {
                    self.sendOrderBtnView.alpha = 1;
                    self.sendOrderBtnView.userInteractionEnabled = true;
                }else{
                    self.sendOrderBtnView.alpha = 0.5;
                    self.sendOrderBtnView.userInteractionEnabled = false;
                    
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


#pragma mark - CollectionView Delegate Medthod

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

#pragma mark - TableView Delegate Medthod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return usersOrderArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary * eachOrder = usersOrderArray[indexPath.row];
    
    NSString * orderString = eachOrder[@"Order"];
    NSString * userName = eachOrder[@"UserName"];
    
    cell.singleOrderLabel.text = [NSString stringWithFormat:@"%@  點了 %@",userName,orderString];
    
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

#pragma mark - Button Pressed Method
- (IBAction)orderBtnPressed:(id)sender {
    
    _orderLabel.text = @"尚未點餐";
    self.progressView.image = [UIImage imageNamed:@"progress1"];
    
    OrderPickerView *pickerView =  [[OrderPickerView alloc] initWithFrame:CGRectMake(100, 200, 200, 300)];
    
    pickerView.pickerBlock = ^(NSString *selectedOrder){
        
        _orderLabel.text = selectedOrder;
        NSLog(@"******%@*******",selectedOrder);
        
        self.progressView.image = [UIImage imageNamed:@"progress2"];
        
    };
    
    //將餐點資料灌入下載到的array;
    pickerView.MArray = menuArray;
    
    [self.view addSubview:pickerView];
    
}



- (IBAction)okBtn:(id)sender {
    
    if ([_orderLabel.text isEqualToString:@"尚未點餐"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未選擇餐點" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
        
    }else{
         //點ok後  上傳清單到 table view
        [self uploadSelfOrder:self.typeVar];
        
         //計算完後 上傳final Price到該地點
        [self uploadFinalPriceFromAdd:self.typeVar];
        
        
        //自己頁面調整
        self.showFinishLabel.text =@"點餐完成，請等待其他人";
        
        self.progressView.image = [UIImage imageNamed:@"progress3"];
        
        //小綠人
        NSString * okStatusString = @"1";
        [self changeStauts:okStatusString];
        
        //按確定後不給點了
        self.chooseOrderBtnView.alpha = 0.5;
        self.chooseOrderBtnView.userInteractionEnabled = false;
        
        
    }
    
    
}



-(void)uploadFinalPriceFromAdd:(ToThisViewType)type{
    
    NSString * finalTotalString = [self countTotalPriceFromAdd:self.totalPriceLabel.text add:self.orderLabel.text];
    
    NSDictionary * totalPrice =@{@"TotalPrice":finalTotalString};
    
    
    if (type == ToThisViewTypeFromSelected) {
       
        
        [helper uploadtotalPriceWithUid:self.selectedOrderKeyString andPrice:totalPrice];
        
    }else{
        
         NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper uploadtotalPriceWithUid:menuUid andPrice:totalPrice];

        
    }
    
    
    
    
}


-(void)uploadFinalPriceFromDeleteOrder:(ToThisViewType)type{
    
    NSString * finalTotalString = [self countTotalPriceFromDelete:self.totalPriceLabel.text DeleteString:self.orderLabel.text];
    
    NSDictionary * totalPrice =@{@"TotalPrice":finalTotalString};
    
    
    if (type == ToThisViewTypeFromSelected) {
        
        
        [helper uploadtotalPriceWithUid:self.selectedOrderKeyString andPrice:totalPrice];
        
    }else{
        
        NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper uploadtotalPriceWithUid:menuUid andPrice:totalPrice];
       
    }
    
    
}




-(void)uploadSelfOrder:(ToThisViewType)type{
    
    
    NSString * userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * orderString = self.orderLabel.text;
    
    NSDictionary * orderDict = @{@"UserName":userName,@"Order":orderString};
    
    
    
    if (type == ToThisViewTypeFromSelected) {
        
        [helper uploadUserOrderWithMenuUid:self.selectedOrderKeyString andOrder:orderDict];
        
    
    }else{
        
        NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper uploadUserOrderWithMenuUid:menuUid andOrder:orderDict];
        
        
    }
    
}


-(void)deleteSelfOrder:(ToThisViewType)type{
    
    if (type == ToThisViewTypeFromSelected) {
        
        [helper deleteUserOrderWithMenuUid:self.selectedOrderKeyString];
        
        
    }else{
        
        NSString * menuUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"menuUid"];
        
        [helper deleteUserOrderWithMenuUid:menuUid];
        
    }
    
}




-(NSString*)countTotalPriceFromAdd:(NSString *)CurrentTotal add:(NSString*)add{
    
    NSArray *array = [add componentsSeparatedByString:@" "];
    
    NSString * priceString = array[1];
    
    NSString * currentTotalString = CurrentTotal;
    
    NSInteger priceInt = [priceString integerValue];
    NSInteger currentTotalInt = [currentTotalString integerValue];
    
    currentTotalInt = currentTotalInt + priceInt;
    
    NSString *finalTotalString = [NSString stringWithFormat:@"%ld", (long)currentTotalInt];
    
    return finalTotalString;
    
    
}

-(NSString*)countTotalPriceFromDelete:(NSString *)CurrentTotal DeleteString:(NSString*)deleteString
{
    
    NSArray *array = [deleteString componentsSeparatedByString:@" "];
    
    NSString * priceString = array[1];
    
    NSString * currentTotalString = CurrentTotal;
    NSLog(@"NUmber %@",currentTotalString);
    
    NSInteger priceInt = [priceString integerValue];
    NSInteger currentTotalInt = [currentTotalString integerValue];
    
    currentTotalInt = currentTotalInt - priceInt;
    NSLog(@"NUmber %ld",currentTotalInt);
    
    NSString *finalTotalString = [NSString stringWithFormat:@"%ld", (long)currentTotalInt];
    
    return finalTotalString;
    
    
}











- (IBAction)cancelBtn:(id)sender {
    

    
    NSString * cancelStatusString = @"0";
    
    [self changeStauts:cancelStatusString];
    
    
    
    
    //按下取消開啟可選擇餐點
    self.chooseOrderBtnView.alpha = 1;
    self.chooseOrderBtnView.userInteractionEnabled = true;
    self.progressView.image = [UIImage imageNamed:@"progress1.png"];
    
    //取消馬上刪除資料 更新total price
    
    [self uploadFinalPriceFromDeleteOrder:self.typeVar];
    [self deleteSelfOrder:self.typeVar];
    
    self.orderLabel.text = @"尚未點餐";
    
}







- (IBAction)sendOrderBtnPressed:(id)sender {
    
}





-(void)changeStauts:(NSString *)statusString{
    
    //一樣判斷從哪邊進來, 才能改 狀態
    
    if (self.typeVar == ToThisViewTypeFromSelected) {
        //from selected order
        
        
        
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
        
        //need remove observe
        
        
        
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
   
}

@end
