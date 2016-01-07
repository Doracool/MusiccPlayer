//
//  SongListHandel.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "SongListHandel.h"
#import "QYMusic.h"

@implementation SongListHandel

-(void)setSongArr:(NSMutableArray *)songArr
{
    if (_songArr) {
        [_songArr removeAllObjects];
        [_songArr addObjectsFromArray:songArr];
        
    }else{
        _songArr = [NSMutableArray array];
        [_songArr addObjectsFromArray:songArr];
    }
}

/**
 *播放列表转化为model
 */
-(void)addListArr{
    _songArr = [NSMutableArray array];
    NSArray *array=[[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"SongsInfos" withExtension:@"plist"]];
    
    for (NSDictionary *dic in array) {
        [_songArr addObject:[QYMusic musicWithDic:dic]];
    }
}

+(instancetype)ShareSongList
{
    static SongListHandel *Handel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Handel = [SongListHandel new];
        [Handel addListArr];
    });
    return Handel;
}
@end
