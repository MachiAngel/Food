//
//  AddMenuViewController.h
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/19.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    ToThisViewTypeFromSelected,
    ToThisViewTypeFromCreate
    
} ToThisViewType;

@interface AddMenuViewController : UIViewController

//for entire page
@property (nonatomic ,strong)NSString * selectedOrderKeyString;


//for food item
@property (nonatomic ,strong)NSString * SelectedRestaurantUid;


//for final send

@property (nonatomic,strong)NSDictionary * menuCreateInfo;

@end
