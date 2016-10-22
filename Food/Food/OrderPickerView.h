//
//  OrderPickerView.h
//  GuWeiDatePicker
//
//  Created by Shiang-Yu Huang on 2016/10/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickerBlock)(NSString *);

@interface OrderPickerView : UIView

@property(nonatomic,copy)PickerBlock pickerBlock;

@property(nonatomic,strong) NSMutableArray * MArray;


@end
