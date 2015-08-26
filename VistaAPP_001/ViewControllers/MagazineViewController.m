//
//  MagazineViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "MagazineViewController.h"
#import "MagazineTableViewCell.h"
#import "MagaDetailViewController.h"
#import "QFRequestManager.h"
#import "MagazineModel.h"
#import "MJRefresh.h"

#define kMAGAZINE_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=get_mags_list&sa=&uid=10067567&mobile=iphone5&offset=%d&count=15&&e=40dab97d773e7860febfc897c04824e2&uid=10067567&pid=10053&mobile=iphone5&platform=i"

@interface MagazineViewController ()
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
    BOOL _isPull;
    NSInteger _page;
}
@end

@implementation MagazineViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [[NSMutableArray alloc] init];
    _page = 0;
    [self creatNavigationBar];
    [self downloadData];
    [self creatTableView];
    [self refresh];
}

-(void) creatNavigationBar{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 46)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏底"]];
    
    [self.view addSubview:view];
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(10, 5, 35, 35);
    [changeBtn setImage:[UIImage imageNamed:@"切换_1"] forState:UIControlStateNormal];
    [view addSubview:changeBtn];
    
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
        //清空数据源
        [_dataArr setArray:nil];
    }
    NSString * url = [NSString stringWithFormat:kMAGAZINE_URL,_page];
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
        MagazineModel * model = [[MagazineModel alloc] init];
        [model setValuesForKeysWithDictionary:infoDic];
        model.magazineID = [infoDic objectForKey:@"id"];
        [_dataArr addObject:model];
    }
}

-(void) creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, 320, 359) style:UITableViewStylePlain];
    //设置数据源
    //数据源决定单元格
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [self.view addSubview:_tableView];
}

-(void) refresh{
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
-(void) headerRereshing{
    _page = 0;
    _isPull = YES;
    [self downloadData];
    [_tableView headerEndRefreshing];
    [_tableView reloadData];
}
-(void) footerRereshing{
    _page += 15;
    _isPull = NO;
    [self downloadData];
    [_tableView footerEndRefreshing];
    [_tableView reloadData];
}


#pragma mark --数据源方法--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    MagazineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MagazineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MagazineModel * model = _dataArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MagaDetailViewController * detail = [[MagaDetailViewController alloc] init];
    MagazineModel * model = _dataArr[indexPath.row];
    detail.magaID = model.magazineID;
    detail.desc = model.desc;
    detail.titletext = model.title;
    detail.pub_time = model.pub_time;
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
