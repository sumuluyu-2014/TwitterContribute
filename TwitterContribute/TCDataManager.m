//
//  TCDataManager.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-16.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "TCDataManager.h"

static TCDataManager *_dataManger = nil;

@implementation TCDataManager
@synthesize timeLineInfo = _timeLineInfo;
@synthesize timeLineDatas = _timeLineDatas;
+(TCDataManager*)sharedInstance{
    if (!_dataManger) {
        _dataManger = [[TCDataManager alloc] init];
    }
    return _dataManger;
}

-(id)init{
    self = [super init];
    if (self) {
        _timeLineInfo = [[TimelineInfo alloc] init];
        _timeLineDatas = [[NSMutableArray alloc] init];
    }
    return self;
}
-(NSString*)_userInformationDir{
    NSArray* paths;
    NSString* path;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count] < 1){
        return nil;
    }
    path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/TwitterContribute"];
    return path;
}

-(NSString*)_userInformationPath
{
    NSString* path;
    path = [[self _userInformationDir] stringByAppendingString:@"/timeLineDatas.dat"];
    
    return path;
}
-(BOOL)save
{
    NSFileManager* fileMgr;
    fileMgr = [NSFileManager defaultManager];
    
    NSString* userInformationDir;
    userInformationDir= [self _userInformationDir];
    if(![fileMgr fileExistsAtPath:userInformationDir]){
        NSError* error;
        [fileMgr createDirectoryAtPath:userInformationDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    }
    
    NSString *userInformationPath;
    userInformationPath = [self _userInformationPath];
    BOOL successful = [NSKeyedArchiver archiveRootObject:_timeLineDatas toFile:userInformationPath];
  
    return successful;
}
-(void)load{
    
    NSLog(@"userinfo log");
    NSString* userInformationPath;
    userInformationPath = [self _userInformationPath];
    if(!userInformationPath || ![[NSFileManager defaultManager] fileExistsAtPath:userInformationPath]){
        return;
    }
    
    _timeLineDatas = [NSKeyedUnarchiver unarchiveObjectWithFile:userInformationPath];
}


-(void)addTimeLineData:(TimelineInfo*)line{
    if (!line) {
        return;
    }
    [_timeLineDatas addObject:line];
}

-(void)removeTimeLineDatas:(TimelineInfo *)line{
    if (!line) {
        return;
    }
    [_timeLineDatas removeObject:line];
}

-(void)clearTimeLineData{
    if (!_timeLineDatas && _timeLineDatas.count != 0) {
        [_timeLineDatas removeAllObjects];
    }
}
@end
