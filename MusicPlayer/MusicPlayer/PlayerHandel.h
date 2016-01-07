//
//  PlayerHandel.h
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ParsLrc.h"
typedef enum : NSUInteger{
    sequenceLoop,
    singleLoop,
    Random,
} PLAYETYPE;

@protocol PlayerPRO <NSObject>
//更新播放时间的UI
-(void)updateProgressForTime:(NSTimeInterval)time;
//选中哪行歌词
-(void)updateLrcselectIndex:(NSInteger)index;
//获取当前的播放时间
//-(void)currentPlayTime:(NSTimeInterval)time;
-(void)finshedPlayNotifig;

@end
@interface PlayerHandel : NSObject
//歌词解析模型
@property(readonly , nonatomic) ParsLrc * lrcModel;
//播放模式
@property (nonatomic, assign) PLAYETYPE playerType;
//播放的状态
@property (nonatomic, assign) BOOL isPlaying;
//当前播放的时间
@property (nonatomic, assign) NSTimeInterval CurrentPTime;
//音频总时长
@property (readonly,nonatomic)NSTimeInterval countPtime;

//播放或暂停
@property (nonatomic, assign) BOOL playOrPause;
//协议实现
@property (nonatomic, assign) id<PlayerPRO>delegate;
/**
 *播放的下标
 */
@property (nonatomic, assign)NSInteger PlayerIndex;
// 当前音量
@property (nonatomic,assign) float volume;
// 歌曲名称
@property (nonatomic,readonly,strong)NSString *songTitle;
//歌曲图片
@property (nonatomic,readonly,strong)UIImage *songPicture;

+(instancetype)sharePlayer;

//下一首
-(void)NextSong;
//上一首
-(void)previousSong;
@end
