//
//  ParsLrc.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ParsLrc.h"
#import "QYMusic.h"
@implementation ParsLrc

-(void)lrcParseFromArray:(NSArray *)arr{
    for (NSString *lrcStr in arr) {
        //以[:]拆分
        NSArray *keyArray = [lrcStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[:]"]];
        if (keyArray.count >= 4) {
            NSString *minutes = keyArray[1];
            if ([minutes hasPrefix:@"0"]) {
                NSString *second = keyArray[2];
                NSString *value = keyArray[3];
                float key = minutes.intValue*60 + second.floatValue;
                //时间和value存在字典里
                [self.lrcDic setObject:value forKey:@(key)];
            }
        }
    }
    //排序时间戳
    self.timeArr = [[self.lrcDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


-(instancetype)initWithQyMusic:(QYMusic *)model{
    if (self = [super init]) {
        //解析歌词  取出歌词
       NSString *lrcStr=[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:model.kName ofType:@"lrc"] encoding:NSUTF8StringEncoding error:nil];
        
        //歌词以\n拆分
        NSArray *keyLrc = [lrcStr componentsSeparatedByString:@"\n"];
        //初始化字典
        self.lrcDic = [NSMutableDictionary dictionary];
        
        [self lrcParseFromArray:keyLrc];
    }
    return self;
}

+(instancetype)initWithQyMusic:(QYMusic *)model
{
    return [[ParsLrc alloc] initWithQyMusic:model];
}
@end
