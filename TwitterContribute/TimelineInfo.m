//
//  TimelineInfo.m
//  TwitterContribute
//
//  Created by Lyuuma on 14-4-16.
//  Copyright (c) 2014年 sunming. All rights reserved.
//

#import "TimelineInfo.h"

@implementation TimelineInfo
@synthesize content = _content,subTime = _subTime,infoID = _infoID;
- (id) init{
    self = [super init];
    if (!self){
        return nil;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeObject:_content forKey:@"_content"];
    [encoder encodeObject:_subTime forKey:@"_subTime"];
    [encoder encodeObject:_infoID forKey:@"_infoID"];
}

-(id)initWithCoder:(NSCoder*)decoder{
    self = [super init];
    if (!self){
        return nil;
    }
    _content =[decoder decodeObjectForKey:@"_content"];
    _subTime =[decoder decodeObjectForKey:@"_subTime"];
    _infoID = [decoder decodeObjectForKey:@"_infoID"];
    return self;
}

@end
