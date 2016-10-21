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

@property (nonatomic ,strong)NSString * selectedOrderKeyString;



@end
