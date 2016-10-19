//
//  DetailTableViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/18.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "DetailTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FoodView.h"
#import "RestaurantInfo.h"

@interface DetailTableViewController ()
{
    RestaurantInfo * restaurantManager;
    //NSArray * foodItemsArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPhone;
@property (weak, nonatomic) IBOutlet UIScrollView *foodItemsScrollView;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    restaurantManager = [RestaurantInfo sharedInstance];
    
    //拿到foodItem 列表
    [restaurantManager getRestaurantFoodItemArrayWithUid:self.selectedUid handler:^(NSMutableArray *result) {
        
        //NSLog(@"%@",result);
        
        //------------------------------------------
        CGFloat width = 130;
        CGFloat height = 240;
       
        //取出 每個item 字典
        for (int i = 0; i < result.count; i++) {
            
            NSDictionary * each = result[i];
           
            
            NSString * foodName = each[@"FoodName"];
            NSString * foodPrice = each[@"FoodPrice"];
            NSString * foodImageString = each[@"FoodImageString"];
            
            
            
            NSURL * imageUrl = [NSURL URLWithString:foodImageString];
            
            
            //創出一個imageView
            UIImageView * eachimage = [[UIImageView alloc]init];
            eachimage.frame = CGRectMake(width * i, 0, width, height);
            
            //圖檔大可在加入 placeholder??
            [eachimage sd_setImageWithURL:imageUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //下載完成圖片後 在創出自己類別的組合view 並加入 scroll view
                FoodView * view1 = [[FoodView alloc]initWithFoodView:eachimage.image fdname:foodName fdPrice:foodPrice];
                
                view1.frame = CGRectMake(width * i, 0, width, height);
                
                
                [self.foodItemsScrollView addSubview:view1];
                
                
            }];
            
            
        }
        
        //可滑動的長度
        self.foodItemsScrollView.contentSize = CGSizeMake(result.count * width, 0);
        //-----------------------------------------
        
        
    }];
    
    
    
    
    
    
    //-------------------------傳值可解決的區--------------------------------//
    _restaurantName.text = self.detail.ShopName;
    _restaurantAddress.text = self.detail.ShopAddress;
    _restaurantPhone.text = self.detail.ShopPhone;
    
    NSURL *mainImageURL = [NSURL URLWithString:self.detail.MainImage];
    
    [_mainImageView setShowActivityIndicatorView:YES];
    [_mainImageView setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [_mainImageView sd_setImageWithURL:mainImageURL placeholderImage:[UIImage imageNamed:@"unknow.png"]];
    
    NSLog(@"%@",self.selectedUid);
    //---------------------------------------------------------------------//
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
