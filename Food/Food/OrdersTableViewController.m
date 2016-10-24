//
//  OrdersTableViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/13.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "OrdersTableViewCell.h"
#import "Helper.h"
#import "OrderModel.h"
#import "AddMenuViewController.h"


@interface OrdersTableViewController ()
{
    OrderModel * orderManager;
    Helper *helper;
    
    NSMutableArray * ordersArray;
    NSMutableArray * ordersKeyArray;
}

@property (nonatomic ,strong)NSString * selectedOrderKeyString;
@property (nonatomic ,strong)NSString * selectedRestaurantString;

@end

@implementation OrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goAddMenu) name:@"Selected" object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    orderManager = [OrderModel sharedInstance];
    helper = [Helper sharedInstance];
    
    //會持續監聽 有nil判斷
    [orderManager getOrdersArray:^(NSMutableArray *result) {
        
        ordersArray = result;
        ordersKeyArray = [orderManager getOrdersKeyArray];
        
        [self.tableView reloadData];
        
    }];

    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [orderManager deleteFirebaseObserve];
  
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ordersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    NSDictionary * eachOrderDict = ordersArray[indexPath.row];
    
    cell.orderRestaurantName.textColor = [UIColor orangeColor];
    
    NSString * RtName = [NSString stringWithFormat:@"訂購店家: %@",eachOrderDict[@"ShopName"]];
    
    cell.orderRestaurantName.text = RtName;
    
    NSString * nameString = [NSString stringWithFormat:@"訂單建立者:%@",eachOrderDict[@"Creater"]];
    
    cell.createrName.text = nameString;
    
    NSString * createTimeString = [NSString stringWithFormat:@"建立時間:%@",eachOrderDict[@"CreateTime"]];
    cell.createTime.text = createTimeString;
    
    
    
    cell.orderImageView.image = [UIImage imageNamed:@"order.jpg"];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    //轉場時需拿到的資料 , 一個是該訂單 key , 一個是該餐廳 uid (才能做品項array)
    self.selectedOrderKeyString = ordersKeyArray[indexPath.row];
    
    NSDictionary * eachOrderDict = ordersArray[indexPath.row];
    _selectedRestaurantString = eachOrderDict[@"SelectedRestaurant"];
    
    //完成時會發通知
    [helper selectedMenuUsersWith:self.selectedOrderKeyString];
    
    
}

-(void)goAddMenu{
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddMenuViewController * addMenuVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddMenuViewController"];
    
    addMenuVC.selectedOrderKeyString = self.selectedOrderKeyString;
    addMenuVC.SelectedRestaurantUid = self.selectedRestaurantString;
    
    [self presentViewController:addMenuVC animated:true completion:nil];
    
    
}




// 再判斷是否需要
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    
//    [[helper getDatabaseRefOfMenus]removeAllObservers];
//    
//}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
