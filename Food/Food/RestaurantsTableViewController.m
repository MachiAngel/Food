//
//  RestaurantsTableViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/13.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "RestaurantsTableViewController.h"
#import "Helper.h"
#import "RestaurantInfo.h"  //for 網路 model
#import "restaurantInfoCell.h"
#import "RestaurantModel.h"
#import "DetailTableViewController.h"


@interface RestaurantsTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //靠此manager 拿到網路資料
    RestaurantInfo * restaurantManager;
    
}

@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) NSArray *restaurantUids;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *tmpView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tmpAIV;

@end

@implementation RestaurantsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    self.tmpView.alpha = 1;
    [self.tmpAIV startAnimating];
    
    
    restaurantManager = [RestaurantInfo sharedInstance];
    //去網路拿資料 並且會回傳一個array 餐廳到我的block
    [restaurantManager getAllRestaurantArray:^(NSMutableArray *result) {
        
        _restaurantUids = [restaurantManager getAllRestaurantUids];
       
        NSLog(@"--------");
        NSLog(@"%@",_restaurantUids);
        
        //字典轉模型 到新的array
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:result.count];
        
        for (NSDictionary *dict in result) {
            RestaurantModel *tg = [RestaurantModel tgWithDict:dict];
            [models addObject:tg];
        }
        //自己array, 已經都是模型
        self.restaurants = [models copy];
        
        
        
        self.tmpView.alpha = 0;
        [self.tmpAIV stopAnimating];
        
        [self.myTableView reloadData];
        
    }];
    
    
    
    
}


- (IBAction)addOrderMenuBtn:(id)sender {
    
   // AddShopViewController
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * addShopVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddShopViewController"];
    
    [self presentViewController:addShopVC animated:true completion:nil];

    
    
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _restaurants.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    restaurantInfoCell *cell = [restaurantInfoCell cellWithTableView:tableView];
    
    // 取出對應模型
    RestaurantModel *tg = self.restaurants[indexPath.row];
    
    
    // 設置模型數據给cell 重寫set 方法
    cell.tg = tg;
    
    
    NSLog(@"%@",cell.tg);
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RestaurantModel *forDetail = self.restaurants[indexPath.row];
    
    NSString * selectedUid = self.restaurantUids[indexPath.row];
    
    
    
    DetailTableViewController * detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
    
    detailVC.detail = forDetail;
    detailVC.selectedUid = selectedUid;
    
   
    
    [self showViewController:detailVC sender:nil];
    
    
    
    
    
    
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
