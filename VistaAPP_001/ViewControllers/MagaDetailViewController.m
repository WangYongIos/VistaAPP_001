//
//  MagaDetailViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "MagaDetailViewController.h"
#import "AppDelegate.h"
#import "QFRequestManager.h"

#define kMAGADETAIL_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=get_mags_detail&sa=&uid=10067567&mobile=iphone5&offset=0&count=1000&magid=%@&e=40dab97d773e7860febfc897c04824e2&uid=10067567&pid=10053&mobile=iphone5&platform=i!"

@interface MagaDetailViewController ()
{
    UIScrollView * _myScroll;
    NSInteger _flag;
    CGFloat _header;
    CGFloat _total;
}
@end

@implementation MagaDetailViewController

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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _flag = 0;
    _total = 0;
    [self creatScrollView];
    [self creatNavigationBar];
    [self downloadData];
    
    _myScroll.contentSize = CGSizeMake(320, _total);
}
-(void)creatScrollView{
    _myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, 320, 414)];
    _myScroll.contentOffset = CGPointZero;
    [self.view addSubview:_myScroll];
    
    CGRect rect = [self.desc boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    _header = 100+rect.size.height;
    _total = _header;
    NSLog(@"%@",self.desc);
    NSLog(@"%f-------------",_header);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, _header)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
    titleLabel.font = [UIFont systemFontOfSize:24];
    titleLabel.text = self.titletext;
    [view addSubview:titleLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 280, 20)];
    timeLabel.font = [UIFont systemFontOfSize:18];
    timeLabel.text = self.pub_time;
    [view addSubview:timeLabel];
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, rect.size.height)];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = self.desc;
    textLabel.numberOfLines = 0;
    [view addSubview:textLabel];
    
    [_myScroll addSubview:view];
}

-(void) creatNavigationBar{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 46)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏底"]];
    
    [self.view addSubview:view];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(20, 7, 55, 32);
    [setBtn setImage:[UIImage imageNamed:@"返回_1"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:setBtn];
}


-(void) downloadData{
    NSString * url = [NSString stringWithFormat:kMAGADETAIL_URL,self.magaID];
    NSLog(@"%@",url);
    [QFRequestManager requestWithUrl:url IsCache:YES Finish:^(NSData *data) {
        [self parseData:data];
    } Failed:^{
        NSLog(@"下载失败");
    }];
}

-(void) parseData:(NSData *) data{
    NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray * listArr = [rootDic objectForKey:@"cats"];
    

    for (NSDictionary * catDic in listArr) {
        [self creatView:catDic];
        _flag ++;
    }
    NSLog(@"%@",listArr);
    
}

-(void) creatView:(NSDictionary *) catDic{
    id object = [catDic objectForKey:@"list"];
    int height;
    if([object isKindOfClass:[NSString class]]){
        _flag --;
        return;
    }
    else if ([object isKindOfClass:[NSArray class]]){
        NSArray * detailArr = (NSArray *) object;
        height = detailArr.count;
    }
    _total = _total+70+30*height;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, _header+(70+30*height)*_flag, 300, 50+30*height)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"列表底2_2"]];
    [_myScroll addSubview:view];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.text = [catDic objectForKey:@"cat_name"];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor redColor];
    [view addSubview:titleLabel];
    
    
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray * detailArr = (NSArray *) object;
        for (int j = 0; j<detailArr.count; j++) {
            NSDictionary * detailDic = detailArr[j];
            NSString * str = [detailDic objectForKey:@"title"];
            UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 50+30*j, 280, 20)];
            detailLabel.text = str;
            NSLog(@"%@",str);
            [view addSubview:detailLabel];
            
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50+30*j, 15, 15)];
            imgView.image = [UIImage imageNamed:@"五角星_2"];
            [view addSubview:imgView];
        }
    }
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50+30*height - 3, 300, 1)];
    imgView.image = [UIImage imageNamed:@"分割线"];
    [view addSubview:imgView];

}


-(void) backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.myTabBarView.hidden = YES;
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.myTabBarView.hidden = NO;
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
