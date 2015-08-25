//
//  InformationViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "InformationViewController.h"
#import "QFRequestManager.h"
#import "MJRefresh.h"
#import "InformationModel.h"
#import "CustomTableViewCell.h"
#import "DetailViewController.h"

#define kINFORMATION_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=home_list&sa=&uid=10067566&mobile=iphone5&offset=%d&count=15&&e=b7849d41b00bbacc9a62544402abed9e&uid=10067566&pid=10053&mobile=iphone5&platform=i"


@interface InformationViewController ()
{
    UITableView * _tableView;
    NSMutableArray * _dataArr;
    NSInteger _page;
    BOOL _isPull;
}
@end

@implementation InformationViewController

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
    NSString * url = [NSString stringWithFormat:kINFORMATION_URL,_page];
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
        InformationModel * model = [[InformationModel alloc] init];
        [model setValuesForKeysWithDictionary:infoDic];
        model.informationID = [infoDic objectForKey:@"id"];
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
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    InformationModel * model = _dataArr[indexPath.row];
    [cell configCellWithModel:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController * detail = [[DetailViewController alloc] init];
    InformationModel * model = _dataArr[indexPath.row];
    detail.infoID = model.informationID;
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
