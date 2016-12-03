//
//  DialView.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/12/2.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "DialView.h"

@implementation DialView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)okBtn:(UIButton *)sender {
    
    
    
    
    
//    NSString *finalDeviceToken = deviceToken.description;
//    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
//    finalDeviceToken = [finalDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * tmpPhoneString = self.phoneNumberLabel.text;
    
    tmpPhoneString = [tmpPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString * finalPhoneNumber = [NSString stringWithFormat:@"tel:%@",tmpPhoneString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalPhoneNumber]];
    
    self.dialBlock(@"go");
    
    [self removeFromSuperview];
}

- (IBAction)cancelBtn:(UIButton *)sender {
    
    self.dialBlock(@"go");
    
    [self removeFromSuperview];
    
}

@end
