//
//  TimeLineInfoViewController.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-15.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "TimeLineInfoViewController.h"
#import "TCDataManager.h"

@interface TimeLineInfoViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *subTimeLable;
- (IBAction)subTimeLineToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation TimeLineInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToggle:)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imgView.image = [UIImage imageNamed:@"new.png"] ;
    UIBarButtonItem *rightItem1 =[[UIBarButtonItem alloc] initWithCustomView:imgView];
    self.navItem.leftBarButtonItems=[NSArray arrayWithObjects:rightItem2,rightItem1, nil];
    self.navItem.title = @"@Lyuuma";
    
    self.tableView.scrollEnabled = NO;
    [_contentText.layer setCornerRadius:10];
    _contentText.layer.borderWidth = 1.0;
    _contentText.layer.borderColor = [UIColor grayColor].CGColor;
    TCDataManager *manager =[TCDataManager sharedInstance];
    _contentText.text = manager.timeLineInfo.content;
    [self countDownWithDate:[TCDataManager sharedInstance].timeLineInfo.subTime];
    _subTimeLable.text = manager.timeLineInfo.subTime;
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    [_contentText setInputAccessoryView:topView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)goBackToggle:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissKeyBoard{
    [_contentText resignFirstResponder];
}
//倒计时
-(void)countDownWithDate:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval time1 = [[formatter dateFromString:dateString] timeIntervalSince1970];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval time2 = [[formatter dateFromString:currentDate] timeIntervalSince1970];
    __block double timeout = time1-time2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _remainTimeLable.text = [NSString stringWithFormat:@"0日0時間0分0秒"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                int day = timeout/(24*60*60);
                int hour = ((int)timeout%(24*60*60))/(60*60);
                int minute =(((int)timeout%(24*60*60))%(60*60))/60;
                int seconds = (((int)timeout%(24*60*60))%(60*60))%60;
                _remainTimeLable.text = [NSString stringWithFormat:@"%d日%d時間%d分%d秒",day,hour,minute,seconds];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)subTimeLineToggle:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:@"投稿成功"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
                          ];
    alert.tag = 100;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
