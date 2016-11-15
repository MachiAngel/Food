//
//  FavoriteViewController.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/11/14.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;

@property (nonatomic, strong) NSArray *favorRestaurants;
@property (nonatomic, strong) NSArray *favorRestaurantUids;

@end
