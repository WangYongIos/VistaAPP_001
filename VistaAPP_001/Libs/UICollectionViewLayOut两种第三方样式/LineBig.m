//
//  LineBig.m
//  UICollectionView
//
//  Created by llz on 14-5-7.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import "LineBig.h"
#define ITEMSIZE 200.0//设置cell的大小
#define DISTANCE 200//响应变大的距离
#define ZOOMVALUE 0.3//变大的比例

@implementation LineBig

-(id)init
{
    self = [super init];
    if(self)
    {
        self.itemSize = CGSizeMake(ITEMSIZE, ITEMSIZE);//设置cell大小
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置滚动方向
        self.sectionInset = UIEdgeInsetsMake(200, 0, 200, 0);//设置边界
        self.minimumLineSpacing = 50.0;//设置行距
        
    }
    return self;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds//当我们的布局发生变化的时候想要改变我们的显示，就要用yes
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect//返回相应布局变化的cell们
{
    CGRect visibleRect;//屏幕可见区域
    visibleRect.origin = self.collectionView.contentOffset;//可见区域的左上角坐标是collectionview已经滚动过的contentOffset
    visibleRect.size = self.collectionView.bounds.size;//可见区域的大小就是collectionview的大小
    NSArray *array = [super layoutAttributesForElementsInRect:rect];//找到所有的cell
    for(UICollectionViewLayoutAttributes *attribut in array)//遍历cell，为了找达到响应距离200这个位置的cell
    {
        if(CGRectIntersectsRect(attribut.frame, rect))//判断两个frame是否有重叠的地方
        {
            CGFloat distance = CGRectGetMidX(visibleRect)-attribut.center.x;//减号前的函数计算了屏幕中点的横坐标，减号后面的是cell的中点横坐标，结果就是cell距离中点的横坐标距离
            CGFloat normalDistance = distance/DISTANCE;
            if(ABS(distance) <DISTANCE)//当cell距离中点的横坐标小于200时，认为达到了相应变化的位置
            {
                CGFloat zoom = 1+ZOOMVALUE*(1-ABS(normalDistance));//随着移动，离中点越近括号里面减号后面的值就越小,zoom就越大
                attribut.transform3D = CATransform3DMakeScale(zoom, zoom, 0);//X、Y变大
            }
        }
    }
    return array;//把所有变大的cell返回
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity//找到滚动停止的点
{
    CGFloat offSet = MAXFLOAT;//假设滚动距离无限,慢慢缩小范围
    CGFloat widCenter = proposedContentOffset.x +(CGRectGetWidth(self.collectionView.bounds)/2);//找到屏幕横向中点,proposedContentOffset是滚过以后屏幕的最左侧的X
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);//找到当前可见视图
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];//找到视图里的cell
    for(UICollectionViewLayoutAttributes *attribut in array)
    {
        CGFloat cellHorizonCenter = attribut.center.x;//找到cell的中点横坐标
        if(ABS(cellHorizonCenter- widCenter) < ABS(offSet))//如果cell中点减去屏幕中点的距离绝对值小于offset
        {
            offSet = cellHorizonCenter - widCenter;//重置offset，offset就越来越小，知道找到距离屏幕中点最近的一个offset
        }
    }
    return CGPointMake(proposedContentOffset.x+offSet, proposedContentOffset.y);//把距离屏幕中点最近的cell的位置返回
}

@end