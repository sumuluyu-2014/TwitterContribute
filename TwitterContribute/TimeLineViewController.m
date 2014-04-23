//
//  TimeLineViewController.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-15.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TCDataManager.h"
@interface TimeLineViewController ()<UIAlertViewDelegate>
{
    TCDataManager *tcManager;
    NSArray *contentArr;
}
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@end

@implementation TimeLineViewController

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
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"设定" style:UIBarButtonItemStylePlain target:self action:@selector(gotoSettingToggle:)];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imgView.image = [UIImage imageNamed:@"new.png"] ;
    UIBarButtonItem *rightItem1 =[[UIBarButtonItem alloc] initWithCustomView:imgView];
    self.navItem.leftBarButtonItems=[NSArray arrayWithObjects:rightItem2,rightItem1, nil];
    self.navItem.title = @"@Lyuuma";
    tcManager = [TCDataManager sharedInstance];
    [tcManager load];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    contentArr = [[NSArray alloc] initWithArray:tcManager.timeLineDatas];
    [self.tableView reloadData];
}
-(void)gotoSettingToggle:(id)sender{
    [self performSegueWithIdentifier:@"setting" sender:self];
}
//倒计时
-(void)countDown:(NSIndexPath*)indexPath withDate:(NSString*)dateString{
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
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UILabel *lable = (UILabel*)[cell.contentView viewWithTag:101];
                lable.text =[NSString stringWithFormat:@"0日0時間0分0秒"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 25日5時間30分30秒
                int day = timeout/(24*60*60);
                int hour = ((int)timeout%(24*60*60))/(60*60);
                int minute =(((int)timeout%(24*60*60))%(60*60))/60;
                int seconds = (((int)timeout%(24*60*60))%(60*60))%60;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UILabel *lable = (UILabel*)[cell.contentView viewWithTag:101];
                lable.text = [NSString stringWithFormat:@"%d日%d時間%d分%d秒",day,hour,minute,seconds];
            });
            timeout--;
        }  
    });  
    dispatch_resume(_timer);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNeedsDisplay];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    TimelineInfo *timeLineInfo = (TimelineInfo*)[contentArr objectAtIndex:indexPath.row];
    UIButton*moveInBtn = [[UIButton alloc ] init];
    moveInBtn.backgroundColor = [UIColor yellowColor];
    moveInBtn.frame = CGRectMake(5, 5, ScreenSize.width-5*2, 30);
    [moveInBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [moveInBtn setTitle:timeLineInfo.content forState:UIControlStateNormal];
    moveInBtn.tag = 200+indexPath.row;
    [moveInBtn addTarget:self action:@selector(moveInToggle:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:moveInBtn];
    
    UILabel*leftTime = [[UILabel alloc] initWithFrame:CGRectZero];
    leftTime.frame = CGRectMake(5, 35, ScreenSize.width-5*2, 20);
    leftTime.textColor = [UIColor redColor];
    leftTime.backgroundColor = [UIColor clearColor];
    leftTime.numberOfLines = 1;
    leftTime.tag = 101;
    leftTime.textAlignment = NSTextAlignmentCenter;
    [self countDown:indexPath withDate:timeLineInfo.subTime];
    [cell.contentView addSubview:leftTime];
    
    UILabel*detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.frame = CGRectMake(5, 35+20, ScreenSize.width-5*2, 20);
    detailLabel.textColor = [UIColor redColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.numberOfLines = 1;
    detailLabel.tag = 102;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = [NSString stringWithFormat:@"着信日時%@",timeLineInfo.subTime];
    [cell.contentView addSubview:detailLabel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)moveInToggle:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"有料版アップグレードのご案内￼"
                          message:@"一度投稿したミライツイートを編集するにはアップグレードが必要です！￥200で今すぐアップグレード！"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
                          ];
    [alert show];
    
    UIButton *btn  = (UIButton*)sender;
    int tag = btn.tag-200;
    tcManager.timeLineInfo = (TimelineInfo*)[contentArr objectAtIndex:tag];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"timeLineInfo" sender:self];
    }
}
@end
