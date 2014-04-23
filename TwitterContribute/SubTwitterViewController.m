//
//  SubTwitterViewController.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-15.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "SubTwitterViewController.h"

#import "TCDataManager.h"
#define KDayComponent 0
#define KHourComponent 1
#define KMinuteComponent 2

@interface SubTwitterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>{
    UIView *pickerView;
    UIDatePicker *datePicker;
    UIImagePickerController *imagePicker;
    TCDataManager *tcManager;
    UIPickerView *picView;
    UIView *picContentView;
    
    int day;
    int hour;
    int minute;
    NSDateFormatter *formatter;
}
@property (weak, nonatomic) IBOutlet UITextView *content;
- (IBAction)goToTimeLineToggle:(id)sender;
- (IBAction)followToggle:(id)sender;
- (IBAction)imgSelectToggle:(id)sender;
- (IBAction)subTimeToggle:(id)sender;
- (IBAction)minuteLaterToggle:(id)sender;
- (IBAction)subTimeLineToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *subTimeLable;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation SubTwitterViewController

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
    self.tableView.scrollEnabled = NO;
    tcManager = [TCDataManager sharedInstance];
    [_content.layer setCornerRadius:10];
    _content.layer.borderWidth = 1.0;
    _content.layer.borderColor = [UIColor grayColor].CGColor;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _subTimeLable.text = [formatter stringFromDate:[NSDate date]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 260)];
    UIToolbar*tb1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
    UIBarButtonItem *cBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelToggle:)];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *iBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleBordered target:self action:@selector(setTimeToggle:)];
    [tb1 setItems:[NSArray arrayWithObjects:cBtn1,space1,iBtn1,nil]];
    [pickerView addSubview:tb1];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, ScreenSize.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setDate:[NSDate date]];
    datePicker.minuteInterval = 10;
    datePicker.minimumDate = [NSDate date];
    datePicker.backgroundColor = [UIColor whiteColor];
    [pickerView addSubview:datePicker];
    [self.tableView addSubview:pickerView];
    
    picContentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 260)];
    UIToolbar*tb2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
    UIBarButtonItem *cBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel1Toggle:)];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *iBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleBordered target:self action:@selector(setTime1Toggle:)];
    [tb2 setItems:[NSArray arrayWithObjects:cBtn2,space2,iBtn2,nil]];
    [picContentView addSubview:tb2];
    picView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, ScreenSize.width, 216)];
    picView.dataSource = self;
    picView.delegate = self;
    picView.backgroundColor = [UIColor whiteColor];
    [picContentView addSubview:picView];
    [self.tableView addSubview:picContentView];
    NSArray *arr = [NSArray arrayWithObjects:@"日",@"时间",@"分", nil];
    for (int index = 0; index < 3; index++) {
        UILabel*leftTime1 = [[UILabel alloc] initWithFrame:CGRectZero];
        leftTime1.frame = CGRectMake(70+80*index, 145, 40, 20);
        leftTime1.backgroundColor = [UIColor clearColor];
        leftTime1.text = [arr objectAtIndex:index];
        leftTime1.font = [UIFont systemFontOfSize:14];
        leftTime1.textAlignment = NSTextAlignmentLeft;
        [picContentView addSubview:leftTime1];
    }
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    [_content setInputAccessoryView:topView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoSettingToggle:(id)sender{
    [self performSegueWithIdentifier:@"setting1" sender:self];
}
-(void)dismissKeyBoard{
    [_content resignFirstResponder];
}
-(void)cancelToggle:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        pickerView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
    }];
}
-(void)setTimeToggle:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        pickerView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
    }];
    NSComparisonResult result =[datePicker.date compare:[NSDate date]];
    if (result == NSOrderedAscending) {
        return;
    }
    _subTimeLable.text = [formatter stringFromDate:datePicker.date];
}

-(void)cancel1Toggle:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        picContentView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
    }];
}
-(void)setTime1Toggle:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        picContentView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
    }];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time = time +day*24*60*60 + hour*60*60 + minute*60;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    _subTimeLable.text = [formatter stringFromDate:date];
}

- (IBAction)goToTimeLineToggle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)followToggle:(id)sender {
}
- (IBAction)imgSelectToggle:(id)sender {
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"写真を撮る",@"写真を選択", nil];
    NSLog(@"%d",myActionSheet.numberOfButtons);
    myActionSheet.cancelButtonIndex = myActionSheet.numberOfButtons -1;
    [myActionSheet showInView:self.tableView];
}

- (IBAction)subTimeToggle:(id)sender {
    if ([_content isFirstResponder]) {
        [_content resignFirstResponder];
    }
    if (picContentView.frame.origin.y >= ScreenSize.height-260) {
        [UIView animateWithDuration:0.2 animations:^{
            picContentView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
        }];
    }
    if (pickerView.frame.origin.y <= ScreenSize.height-260) {
        return;
    }
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [UIView animateWithDuration:0.2 animations:^{
        pickerView.frame = CGRectMake(0, ScreenSize.height-260, ScreenSize.width, 260);
    }];
}

- (IBAction)minuteLaterToggle:(id)sender {
    if ([_content isFirstResponder]) {
        [_content resignFirstResponder];
    }
    if (pickerView.frame.origin.y >= ScreenSize.height-260) {
        [UIView animateWithDuration:0.2 animations:^{
            pickerView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, 260);
        }];
    }
    if (picContentView.frame.origin.y <= ScreenSize.height-260) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        picContentView.frame = CGRectMake(0, ScreenSize.height-260, ScreenSize.width, 260);
    }];
}

- (IBAction)subTimeLineToggle:(id)sender {
    if (_content.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"エラー"
                              message:@"メッセージが足りません"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil
                              ];
        [alert show];
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"ミライツイートして良いですか"
                              message:@"一度投稿したミライツイートは編集で きません!⼗十分ご注意ください。"
                              delegate:self
                              cancelButtonTitle:@"キャセンル"
                              otherButtonTitles:@"OK",nil
                              ];
        [alert show];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"拍照上传");
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            break;
        case 1:
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            break;
            
        }
        default:
            break;
    }
}
#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imgView.image = image;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int number = 0;
    if (component == KDayComponent) {
        number = 3;
    }else if(component == KHourComponent){
        number = 24;
    }else if (component == KMinuteComponent){
        number = 60;
    }else{
        number = 1;
    }
    return number;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = nil;
    switch (component) {
        case KDayComponent:
            title= [NSString stringWithFormat:@"%d",row];
            break;
        case KMinuteComponent:
            title= [NSString stringWithFormat:@"%d",row];
            break;
        case KHourComponent:
            title = [NSString stringWithFormat:@"%d",row];
            break;
        default:
            title = @"後";
            break;
    }
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case KDayComponent:
            day = row;
            break;
        case KHourComponent:
            hour = row;
            break;
        case KMinuteComponent:
            minute = row;
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        TimelineInfo *timeLineInfo = [[TimelineInfo alloc] init];
        timeLineInfo.content = _content.text;
        timeLineInfo.subTime = _subTimeLable.text;
        
        [tcManager addTimeLineData:timeLineInfo];
        BOOL saveSucceed = [tcManager save];
        if (saveSucceed) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
