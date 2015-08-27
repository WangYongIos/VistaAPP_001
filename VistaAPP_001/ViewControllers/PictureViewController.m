//
//  PictureViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "PictureViewController.h"
#import "QFRequestManager.h"
#import "PictureModel.h"
#import "PictureCollectionViewCell.h"
#import "PicDetailViewController.h"

#define kPICTURE_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=piclist&sa=&uid=10067567&mobile=iphone5&offset=%d&count=9&&e=40dab97d773e7860febfc897c04824e2&uid=10067567&pid=10053&mobile=iphone5&platform=i!"

@interface PictureViewController ()
{
    UICollectionView * _collection;
    NSMutableArray * _dataArr;
    NSInteger _page;
    BOOL _isPull;
}
@end

@implementation PictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    _page = 9;
    _dataArr = [[NSMutableArray alloc] init];
    [self creatNavigationBar];
    [self downloadData];
    [self creatCollectionView];
}

-(void) creatNavigationBar{
    UIView * myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    myview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myview];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 46)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏底"]];
    
    [self.view addSubview:view];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(280, 5, 35, 35);
    [setBtn setImage:[UIImage imageNamed:@"设置_1"] forState:UIControlStateNormal];
    [view addSubview:setBtn];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(108, 7, 103, 32)];
    imgView.image = [UIImage imageNamed:@"logo"];
    [view addSubview:imgView];
}

-(void) downloadData{
    if (_isPull) {
        [_dataArr setArray:nil];
    }
    
    NSString * url = [NSString stringWithFormat:kPICTURE_URL,_page];
    NSLog(@"%@",url);
    [QFRequestManager requestWithUrl:url IsCache:YES Finish:^(NSData *data) {
        [self parseData:data];
    } Failed:^{
        NSLog(@"下载失败");
    }];
}

-(void) parseData:(NSData *) data{
    NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray * listArr = [rootDic objectForKey:@"list"];
    for (NSDictionary * infoDic in listArr) {
        PictureModel * model = [[PictureModel alloc] init];
        [model setValuesForKeysWithDictionary:infoDic];
        [_dataArr addObject:model];
    }
    NSLog(@"%@",_dataArr);
}


-(void) creatCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 76, 306, 349) collectionViewLayout:layout];
    _collection.dataSource = self;
    _collection.delegate = self;
    
    [_collection registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cell";
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"酷图底2"]];
    }
    else{
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"酷图底1"]];
    }
    PictureModel * model = _dataArr[indexPath.item];
    [cell configCellWithModel:model];
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(102, 115);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PicDetailViewController * detail = [[PicDetailViewController alloc] init];
    NSMutableArray * idArr =[[NSMutableArray alloc] init];
    for (int i = 0; i<_dataArr.count; i++) {
        PictureModel * model = _dataArr[i];
        [idArr addObject:model.gid];
    }
    NSLog(@"%@",idArr);
    detail.idArr = idArr;
    PictureModel * model = _dataArr[indexPath.row];
    detail.gid = model.gid;
    detail.index = indexPath.row;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y>140) {
        _page += 9;
        _isPull = NO;
        [self downloadData];
        [_collection reloadData];
    }
    else if (scrollView.contentOffset.y<-40) {
        _page = 0;
        _isPull = YES;
        [self downloadData];
        [_collection reloadData];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
