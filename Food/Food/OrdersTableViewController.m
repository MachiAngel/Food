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


@interface OrdersTableViewController ()
{
    OrderModel * orderManager;
    Helper *helper;
    
    NSMutableArray * ordersArray;
    NSMutableArray * ordersKeyArray;
}

@end

@implementation OrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderManager = [OrderModel sharedInstance];
    helper = [Helper sharedInstance];
    
    
    [orderManager getOrdersArray:^(NSMutableArray *result) {
        
        ordersArray = result;
        ordersKeyArray = [orderManager getOrdersKeyArray];
        
        [self.tableView reloadData];
        
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
//    // get Current orders
//    
//    [[helper getDatabaseRefOfMenus]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        
//        NSDictionary * orders = snapshot.value;
//        
//        ordersArray = [NSMutableArray new];
//        ordersKeyArray = [NSMutableArray new];
//        
//        for (NSString * orderKey in orders) {
//            
//            NSDictionary * eachOrder = orders[orderKey];
//            
//            [ordersKeyArray addObject:orderKey];
//            [ordersArray addObject:eachOrder];
//            
//            
//        }
//        [self.tableView reloadData];
//        
//        NSLog(@"TT:%@",ordersArray);
//        NSLog(@"CC:%@",ordersKeyArray);
//        
//    }];
//    
    
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
    cell.orderRestaurantName.text = eachOrderDict[@"ShopName"];
    
    NSString * nameString = [NSString stringWithFormat:@"創建者:%@",eachOrderDict[@"Creater"]];
    
    cell.createrName.text = nameString;
    
    cell.orderImageView.image = [UIImage imageNamed:@"order.jpg"];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    
    
    
}

-(void)goAddMenu{
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * addMenuVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddMenuViewController"];
    
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
