//
//  DetailViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

#define kDETAIL_URL @"http://ktx.cms.palmtrends.com/api_v2.php?action=article&uid=10067567&id=%@&mobile=iphone5&e=40dab97d773e7860febfc897c04824e2&fontsize=m!"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"资讯背景底"]];
    [self creatNavigationBar];
    [self creatWebView];
    [self creatView];
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

-(void) backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) creatWebView{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66, 320, 373)];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kDETAIL_URL,self.infoID]]];
    NSLog(@"%@",request);
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

-(void) creatView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 439, 320, 41)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MicroBlog_ToolBar"]];
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
