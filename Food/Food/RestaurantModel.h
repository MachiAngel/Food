//
//  RestaurantModel.h
//  listRestaurant
//
//  Created by Shiang-Yu Huang on 2016/10/17.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJGlobal.h"

@interface RestaurantModel : NSObject

// 餐廳圖標
@property (nonatomic, copy) NSString *MainImage;

// 餐廳名稱
@property (nonatomic, copy) NSString *ShopName;

// 餐廳地址
@property (nonatomic, copy) NSString *ShopAddress;

// 餐廳電話
@property (nonatomic, copy) NSString *ShopPhone;

//餐廳上傳者 還沒用到
@property (nonatomic, copy) NSString *UploadUser;



NJInitH(tg)

@end
