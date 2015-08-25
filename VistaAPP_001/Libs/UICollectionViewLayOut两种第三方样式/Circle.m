//
//  Circle.m
//  UICollectionView
//
//  Created by llz on 14-5-7.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import "Circle.h"

@implementation Circle

-(void)prepareLayout//每次布局变化执行这个
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];//当前只有一个段，所以section的参数为0,前面的[self collectionView]会返回调用本类的collectionview对象,整个返回collectionview有多少个cell
    self.center = CGPointMake(size.width/2, size.height/2);
    self.redius = MIN(size.width, size.height)/2.5;//屏幕最短侧大小除2.5得出半径
}

-(CGSize)collectionViewContentSize//返回collectionview的大小
{
    return [self collectionView].frame.size;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath//设置每一个cell的，属性都在Attributes中
{
    UICollectionViewLayoutAttributes *attribut = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];//找到当前的cell的属性
    attribut.size = CGSizeMake(60, 60);//cell的大小
    attribut.center = CGPointMake(self.center.x +self.redius*cosf(2*indexPath.item*M_PI/self.cellCount), self.center.y +self.redius*sinf(2*indexPath.item*M_PI/self.cellCount));//设置cell 的位置
    return attribut;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0;i<self.cellCount;i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];//找到当前段0里的每一个cell
        [array addObject:[self layoutAttributesForItemAtIndexPath:index]];//把所有的cell保存到array中
    }
    return array;
}

@end







