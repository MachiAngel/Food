//
//  UserCollectionViewCell.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/19.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//

#import "UserCollectionViewCell.h"

@implementation UserCollectionViewCell


-(UIImageView *)userImage{
    
    _userImage.layer.borderWidth = 1.5;
    
    _userImage.layer.cornerRadius = _userImage.frame.size.width / 2 ;
    
    _userImage.clipsToBounds = true;
    
    return _userImage;
}

@end
