//
//  QYMusic.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYMusic.h"

@implementation QYMusic

-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)musicWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
@end
