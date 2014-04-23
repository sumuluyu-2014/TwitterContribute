//
//  LoginViewController.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-15.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL isSavePass;
    UIImageView *agreenFlagImg;
    
}
@property (weak, nonatomic) IBOutlet UITextView *condition;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *savePass;
- (IBAction)savePassToggle:(id)sender;
- (IBAction)loginToggle:(id)sender;

@end

@implementation LoginViewController

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
    _condition.editable = NO;
    agreenFlagImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
    agreenFlagImg.frame = CGRectMake(0, 0, 18, 18);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)savePassToggle:(id)sender {
    
    isSavePass = !isSavePass;
    if (isSavePass) {
        [_savePass addSubview:agreenFlagImg];
    }else{
        [agreenFlagImg removeFromSuperview];
    }
}
- (IBAction)loginToggle:(id)sender {
    if (isSavePass) {
        [[NSUserDefaults standardUserDefaults] setObject:_passWord.text forKey:@"passWord"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_userName.text forKey:@"userName"];
}
@end
