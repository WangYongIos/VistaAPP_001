//
//  MainViewController.m
//  VistaAPP_001
//
//  Created by qianfeng on 15/8/25.
//  Copyright (c) 2015年 柳德智. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [self creatView];
    [self.tabBar removeFromSuperview];
    [self creatTabBar];
}
-(void) creatView {
    NSMutableArray * myArr = [[NSMutableArray alloc] init];
    NSArray * classArr = @[@"Information",@"Magazine",@"Respectable",@"Picture"];
    for (int i = 0; i<classArr.count; i++) {
        NSString * ClassName = [NSString stringWithFormat:@"%@ViewController",classArr[i]];
        
        //根据字符串来寻找该工程下以字符串命名的viewcontroller
        Class viewcontroller = NSClassFromString(ClassName);
        //实例化
        UIViewController * controller = [[viewcontroller alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:controller];
        [myArr addObject:navi];
    }
    self.viewControllers = myArr;
}

-(void) creatTabBar{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 425, 320, 55)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"列表底_2"]];
    [self.view addSubview:view];
    
    NSArray * imgArr = @[@"资讯",@"杂志",@"微言",@"酷图"];
    for (int i = 0; i<4; i++) {
        UIButton * imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = CGRectMake(i*80, 0, 80, 55);
        [imgBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_1",imgArr[i]]] forState:UIControlStateNormal];
        [imgBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_2",imgArr[i]]] forState:UIControlStateSelected];

        imgBtn.tag = i;
        if (i == 0) {
            imgBtn.selected = YES;
            self.selectBtn = imgBtn;
        }
        [imgBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imgBtn];
    }
    
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.myTabBarView = view;
}

-(void) changeView:(UIButton *) button{
    
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectedIndex = button.tag;
    self.selectBtn = button;
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
