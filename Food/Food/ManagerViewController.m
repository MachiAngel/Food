//
//  ManagerViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/11/16.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "ManagerViewController.h"
#import "Helper.h"
#import "RestaurantInfo.h"
#import "restaurantInfoCell.h"
#import "RestaurantModel.h"
#import "DetailTableViewController.h"

@interface ManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //靠此manager 拿到網路資料
    RestaurantInfo * restaurantManager;
    
}
@property (weak, nonatomic) IBOutlet UITableView *managerTableView;

@property (nonatomic, strong) NSArray *myRestaurants;
@property (nonatomic, strong) NSArray *myRestaurantUids;


@end

@implementation ManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    restaurantManager = [RestaurantInfo sharedInstance];
    
    [restaurantManager getMyRestaurantArray:^(NSMutableArray *result) {
        
        self.myRestaurantUids = [restaurantManager getMyRestaurantUids];
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:result.count];
        
        for (NSDictionary *dict in result) {
            RestaurantModel *tg = [RestaurantModel tgWithDict:dict];
            [models addObject:tg];
        }
        
        self.myRestaurants = [models copy];
        
        
        [self.managerTableView reloadData];
        
    }];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.myRestaurants.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    restaurantInfoCell *cell = [restaurantInfoCell cellWithTableView:tableView];
    
    
    // 取出對應模型
    RestaurantModel *tg = self.myRestaurants[indexPath.row];
    // 設置模型數據给cell 重寫set 方法
    cell.tg = tg;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    RestaurantModel *forDetail = self.myRestaurants[indexPath.row];
    
    NSString * selectedUid = self.myRestaurantUids[indexPath.row];
    
    DetailTableViewController * detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
    
    detailVC.detail = forDetail;
    detailVC.selectedUid = selectedUid;
    
    
    
    [self showViewController:detailVC sender:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
