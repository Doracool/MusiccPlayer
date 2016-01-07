//
//  ParsLrc.h
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYMusic;
@interface ParsLrc : NSObject
@property (strong , nonatomic) NSArray *timeArr;
@property (strong , nonatomic) NSMutableDictionary *lrcDic;

+(instancetype)initWithQyMusic:(QYMusic *)model;
@end
