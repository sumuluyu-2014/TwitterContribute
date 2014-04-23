//
//  TCDataManager.h
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-16.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineInfo.h"
@interface TCDataManager : NSObject
{
    NSMutableArray* _timeLineDatas;
    TimelineInfo *_timeLineInfo;
}
@property (nonatomic, retain)TimelineInfo *timeLineInfo;
@property (nonatomic, readonly)NSArray* timeLineDatas;
+(TCDataManager *)sharedInstance;

-(void)addTimeLineData:(TimelineInfo*)line;

-(void)removeTimeLineDatas:(TimelineInfo *)line;

-(void)clearTimeLineData;

-(BOOL)save;
-(void)load;

@end
