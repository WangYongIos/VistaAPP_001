//
//  CustomTableViewCell.h
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UILabel * pub_timeLabel;
@property (nonatomic, strong) UILabel * titleLabel;

-(void) configCellWithModel:(InformationModel *) model;

@end
