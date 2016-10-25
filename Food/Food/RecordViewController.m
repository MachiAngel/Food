//
//  RecordViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/25.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *ordersTextView;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;


@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//   NSArray * records = [[NSUserDefaults standardUserDefaults]objectForKey:@"recordArray"];
//    NSLog(@"-------------cc");
//    NSLog(@"%@",records);
//    NSLog(@"%@",records[0]);
//    NSLog(@"-------------cc");
    
//    NSDictionary * record = @{@"createrName":createrNameString,
//                              @"createTime":createTimeString,
//                              @"restaurantName":restaurantName,
//                              @"restaurantPhone":restaurantPhone,
//                              @"totalPrice":totalPriceString,
//                              @"orderArray":orderArray};
    
    NSLog(@"EEEEE%@",self.recordDict);
    
    
//    @property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *createrNameLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
//    @property (weak, nonatomic) IBOutlet UITextView *ordersTextView;
//    @property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;
    
    self.restaurantNameLabel.text = self.recordDict[@"restaurantName"];
    self.createrNameLabel.text = self.recordDict[@"createrNameString"];
    self.shopPhoneLabel.text = self.recordDict[@"restaurantPhone"];
    
    NSArray * orderArray = self.recordDict[@"orderArray"];
    for (int i = 0; i < orderArray.count; i++) {
        NSString * eachOrderString = orderArray[i];
        
        self.ordersTextView.text = [self.ordersTextView.text stringByAppendingFormat:@"%@\n",eachOrderString];
    }
    
    self.ordersTextView.text = [self.ordersTextView.text stringByAppendingFormat:@"總計:%@元\n",self.recordDict[@"totalPrice"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leaveBtnPressed:(id)sender {
    
    UIViewController *vc = self.presentingViewController;
    
    while (vc.presentingViewController) {
        
        vc = vc.presentingViewController;
        
    }
    
    [vc dismissViewControllerAnimated:YES completion:NULL];
    
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
