//
//  ViewController.m
//
//
//  Copyright © 2016年 cd. All rights reserved.
//

#import "ViewController.h"
#import "RestaurantsTableViewController.h"


#import "Helper.h"
#import "RestaurantInfo.h"
#import "restaurantInfoCell.h"
#import "RestaurantModel.h"
#import "DetailTableViewController.h"
#import "FavoriteViewController.h"
#import "ManagerViewController.h"



@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootScrollView.delegate = self;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"trytrytry");
    
}


- (IBAction)addShopBtn:(UIBarButtonItem *)sender {
    
    // AddShopViewController
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * addShopVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddShopViewController"];
    
    [self presentViewController:addShopVC animated:true completion:nil];
    
}





//第一個按钮
- (IBAction)FirstBI:(id)sender {
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 0, 0);
    self.lineLabel.frame = CGRectMake(self.view.frame.size.width * 0
                                      , self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    
   
}
//第二個按钮
- (IBAction)SecondBI:(id)sender {
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width *1 , 0);
    self.lineLabel.frame = CGRectMake((self.view.frame.size.width/3) * 1
                                      , self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    
}
//第三個按钮
- (IBAction)ThirdBI:(id)sender {
    self.rootScrollView.contentOffset = CGPointMake(self.view.frame.size.width *2 , 0);
    self.lineLabel.frame = CGRectMake((self.view.frame.size.width/3) * 2
                                      , self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
   
}





//scrollerView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    //只要有偏移量 就取消收尋
    RestaurantsTableViewController *  vc = self.childViewControllers[0];
    vc.searchController.active = false;
    //[vc.searchController.searchBar resignFirstResponder];
    
    
//    NSLog(@"%lf",scrollView.contentOffset.x);
    self.lineLabel.frame = CGRectMake( scrollView.contentOffset.x / 3
                                      , self.lineLabel.frame.origin.y, self.lineLabel.frame.size.width, self.lineLabel.frame.size.height);
    
    
    
    
//    if (scrollView.contentOffset.x == self.view.frame.size.width *1 ) {
//        FavoriteViewController * FVC = self.childViewControllers[1];
//        
//    }else if(scrollView.contentOffset.x == self.view.frame.size.width *2){
//    
//    }

    
    if (scrollView.contentOffset.x == self.view.frame.size.width *2) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBtnPressed)];
        
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        
        ManagerViewController * mVC = self.childViewControllers[2];
        
        if (mVC.managerTableView.editing == true) {
            [mVC.managerTableView setEditing:false animated:true];
        }
        
        
        
    }
    
    
}

-(void)editBtnPressed{
    
    ManagerViewController * mVC = self.childViewControllers[2];
    
    [mVC.managerTableView setEditing:true animated:true];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed)];
    
    
}


-(void)doneBtnPressed{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBtnPressed)];
    
    ManagerViewController * mVC = self.childViewControllers[2];
    
    [mVC.managerTableView setEditing:false animated:true];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}





@end
