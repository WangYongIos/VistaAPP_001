//
//  PicDetailViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/26.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "PicDetailViewController.h"
#import "QFRequestManager.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#define kPICDETAIL_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=picture&sa=&uid=10067567&mobile=iphone5&offset=0&count=15&gid=%@&moblie=iphone5&e=40dab97d773e7860febfc897c04824e2&uid=10067567&pid=10053&mobile=iphone5&platform=i"

@interface PicDetailViewController ()

@end

@implementation PicDetailViewController

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
    [self creatNavigationBar];
    [self creatView];
    [self downloadData];
}

-(void) creatNavigationBar{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 46)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏底2"]];
    
    [self.view addSubview:view];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(20, 7, 55, 32);
    [setBtn setImage:[UIImage imageNamed:@"返回2_1"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:setBtn];
}

-(void) backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) downloadData{
    NSString * url = [NSString stringWithFormat:kPICDETAIL_URL,self.gid];
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
        [self creatUIView:infoDic];
    }
}


-(void) creatUIView:(NSDictionary *) myDic{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UIScrollView * myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, 320, 373)];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, 225)];
    [imgView sd_setImageWithURL:[myDic objectForKey:@"icon"]];
    [myScroll addSubview:imgView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 245, 300, 30)];
    titleLabel.text = [myDic objectForKey:@"title"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [myScroll addSubview:titleLabel];
    
    NSString * str = [myDic objectForKey:@"des"];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 285, 300, rect.size.height)];
    descLabel.text = str;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:14];
    [myScroll addSubview:descLabel];
    
    myScroll.contentOffset = CGPointZero;
    myScroll.contentSize = CGSizeMake(320, 300+rect.size.height);
    [self.view addSubview:myScroll];
}

-(void) creatView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 439, 320, 41)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"导航底"]];
    [self.view addSubview:view];
    
    NSArray * btnArr = @[@"上一章",@"评论",@"收藏",@"内页转发",@"下一章"];
    for (int i = 0; i<5; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+60*i, 5, 40, 30);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_1",btnArr[i]]] forState:UIControlStateNormal];
        if (i == 2) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",btnArr[i]]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"收藏成功"] forState: UIControlStateSelected];
        }
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [view addSubview:btn];
    }
}

-(void) click:(UIButton *) button{
    if (button.tag == 2) {
        button.selected = !button.selected;
    }
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
