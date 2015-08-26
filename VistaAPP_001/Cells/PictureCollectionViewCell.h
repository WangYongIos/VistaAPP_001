//
//  PictureCollectionViewCell.h
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureModel.h"

@interface PictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * titleLabel;

-(void)configCellWithModel:(PictureModel *)model;

@end
