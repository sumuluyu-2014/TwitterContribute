//
//  UseMethodViewController.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-16.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "UseMethodViewController.h"

@interface UseMethodViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *pageControl;
    UIButton *moveInBtn;
}


@end
//moveIn
@implementation UseMethodViewController

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
    self.navigationController.navigationBar.hidden = YES;
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    CGSize contentSize = CGSizeMake(ScreenSize.width * 4, ScreenSize.height);
    [_scrollView setContentSize:contentSize];
    [self.view addSubview:_scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    pageControl.center = CGPointMake(ScreenSize.width/2, ScreenSize.height-40);
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [self.view  addSubview:pageControl];
    
    moveInBtn = [[UIButton alloc ] init];
    moveInBtn.backgroundColor = [UIColor yellowColor];
    moveInBtn.frame = CGRectMake(0, 0, 200, 40);
    moveInBtn.center = CGPointMake(ScreenSize.width/2, ScreenSize.height-80);
    [moveInBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [moveInBtn setTitle:@"start" forState:UIControlStateNormal];
    [moveInBtn addTarget:self action:@selector(moveInToggle:) forControlEvents:UIControlEventTouchUpInside];
    moveInBtn.hidden= YES;
    [self.view  addSubview:moveInBtn];
	// Do any additional setup after loading the view.
}
-(void)moveInToggle:(id)sender{
    [_scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    [self performSegueWithIdentifier:@"moveIn" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
    pageControl.currentPage = index;
    if (index == 3) {
        moveInBtn.hidden = NO;
    }else{
        moveInBtn.hidden = YES;
    }
}
@end
