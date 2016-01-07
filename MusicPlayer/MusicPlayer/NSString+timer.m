//
//  NSString+timer.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "NSString+timer.h"

@implementation NSString (timer)

-(NSString *)valueExchange:(NSTimeInterval)timer
{
    int minutes = (float)timer/60;
    int second = (int)timer%60;
    NSString *strMinutes;
    if (minutes >= 10) {
        strMinutes = [NSString stringWithFormat:@"%d",minutes];
    }else{
        strMinutes = [NSString stringWithFormat:@"0%d",minutes];
    }
    NSString *strSecond;
    if (second >= 10) {
        strSecond = [NSString stringWithFormat:@"%d",second];
    }else{
        strSecond = [NSString stringWithFormat:@"0%d",second];
    }
    return [NSString stringWithFormat:@"%@:%@",strMinutes,strSecond];
}
@end
