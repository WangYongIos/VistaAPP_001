//
//  CustomTableViewCell.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatCell];
    }
    return self;
}
-(void) creatCell{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(3, 5, 313, 100)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"列表底2_1"]];
    [self.contentView addSubview:view];
    
    /*
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    imgView.image = [UIImage imageNamed:@"缺省图阴影"];
     */
    self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [view addSubview:self.iconImgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 190, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:self.titleLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 190, 50)];
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.numberOfLines = 0;
    [view addSubview:self.descLabel];
    
    self.pub_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 85, 180, 15)];
    self.pub_timeLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:self.pub_timeLabel];
    
    UIImageView * imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(290, 42, 15, 15)];
    imgView2.image = [UIImage imageNamed:@"三角"];
    [view addSubview:imgView2];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 85, 15, 15)];
    imgView.image = [UIImage imageNamed:@"时间"];
    [view addSubview:imgView];
}

-(void)configCellWithModel:(InformationModel *)model{
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    self.pub_timeLabel.text = model.pub_time;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
}





- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
