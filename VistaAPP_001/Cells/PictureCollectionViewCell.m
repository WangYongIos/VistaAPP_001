//
//  PictureCollectionViewCell.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PictureCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self creatCell];
    }
    return self;
}

-(void) creatCell{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 102, 115)];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 7, 90, 69)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 76, 90, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.imgView];
    [view addSubview:self.titleLabel];
    
    [self.contentView addSubview:view];
}

-(void)configCellWithModel:(PictureModel *)model{
    self.titleLabel.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
