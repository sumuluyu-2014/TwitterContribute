//
//  TimelineInfo.h
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-16.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineInfo : NSObject
{
    NSString *_content;
    NSString *_subTime;
    NSString *_infoID;
}
@property (nonatomic,retain)NSString *content;
@property (nonatomic,retain)NSString *subTime;
@property (nonatomic,retain)NSString *infoID;
@end
