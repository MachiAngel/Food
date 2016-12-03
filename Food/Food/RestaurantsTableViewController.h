//
//  RestaurantsTableViewController.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/13.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantsTableViewController : UIViewController

@property (nonatomic,strong) UISearchController * searchController;


@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) NSArray *restaurantUids;

@property (nonatomic,strong) NSMutableArray * searchList;
@property (nonatomic,strong) NSMutableArray * searchUidList;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
