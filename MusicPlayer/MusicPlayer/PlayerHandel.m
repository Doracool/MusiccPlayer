//
//  PlayerHandel.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "PlayerHandel.h"
#import "QYMusic.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SongListHandel.h"
#import "ParsLrc.h"

@interface PlayerHandel ()<AVAudioPlayerDelegate>
//播放器
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation PlayerHandel
@synthesize volume = _volume;
@synthesize CurrentPTime = _CurrentPTime;
+(instancetype)sharePlayer
{
    static PlayerHandel *playerHandel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        playerHandel = [[PlayerHandel alloc] init];
        playerHandel.PlayerIndex = -1;
        
        //设置音量值
        playerHandel.volume = .5;
       
    });
    return playerHandel;
}

-(void)setAudioBackGroundSession{
    //获取会话对象
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置策略
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //启动会话
    [session setActive:YES error:nil];
}
//改变当前的音量
-(void)setVolume:(float)volume{
    if (_volume == volume) {
        return;
    }
    self.player.volume = volume;
    _volume = volume;
}
//当前的音量
-(float)volume{
    return _volume;
}

//获取当前的时长
-(NSTimeInterval)CurrentPTime{
    return self.player.currentTime;
}

//改变当前的播放时长
-(void)setCurrentPTime:(NSTimeInterval)CurrentPTime
{
    if (_CurrentPTime == CurrentPTime) {
        return;
    }
    self.player.currentTime = CurrentPTime;
    _CurrentPTime = CurrentPTime;
}

-(NSTimer *)timer
{
    if (_timer) {
        return _timer;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(upDateTime) userInfo:nil repeats:YES];
    return _timer;
}

-(void)upDateTime{
    if (_delegate) {
        [self.delegate updateProgressForTime:self.CurrentPTime];
        
        //当前选中哪一行
        NSInteger index = 0;
        
        NSTimeInterval tempCurrent = self.CurrentPTime;
        for (NSNumber *number in _lrcModel.timeArr) {
            if (number.floatValue <= tempCurrent) {
                index += 1;
            }else{
                break;
            }
        }
        if (index != 0) {
            [self.delegate updateLrcselectIndex:index -1];
        }
    }
}
//重写播放器音乐列表下标
-(void)setPlayerIndex:(NSInteger)PlayerIndex
{
    if (PlayerIndex != -1) {
        if (_PlayerIndex == PlayerIndex) {
            return;
        }
        _PlayerIndex = PlayerIndex;
        //初始化音乐播放器
        //取出模型
        QYMusic *model = [SongListHandel ShareSongList].songArr[PlayerIndex];
        //解析歌词
        _lrcModel = [ParsLrc initWithQyMusic:model];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:model.kName withExtension:model.kType] error:nil];
        _player.volume = self.volume;
        _player.delegate = self;
        [_player prepareToPlay];
        self.playOrPause = YES;
        
        //更新歌词
        if (_delegate) {
            [self.delegate finshedPlayNotifig];
        }
    }else{
        _PlayerIndex = PlayerIndex;
    }
 
}

//播放暂停
-(void)setPlayOrPause:(BOOL)playOrPause
{
    if (playOrPause) {
        [_player play];
    }else{
        [_player pause];
    }
    _playOrPause = playOrPause;
    
}
-(BOOL)isPlaying{
    return self.player.isPlaying;
}

//下一首
-(void)NextSong{
    if (_PlayerIndex+1>=[SongListHandel ShareSongList].songArr.count) {
        self.PlayerIndex = 0;
    }else{
        self.PlayerIndex += 1;
    }
}

//上一首
-(void)previousSong
{
    if (_PlayerIndex -1 <= [SongListHandel ShareSongList].songArr.count - 1) {
        self.PlayerIndex -= 1;
    }else{
        self.PlayerIndex = [SongListHandel ShareSongList].songArr.count - 1;
    }
}

-(void)setDelegate:(id<PlayerPRO>)delegate
{
    if (delegate) {
        //启动
        self.timer.fireDate = [NSDate distantPast];
    }else{
        //暂停
        self.timer.fireDate = [NSDate distantFuture];
    }
    _delegate = delegate;
}
//音乐总时长
-(NSTimeInterval)countPtime{
    return self.player.duration;
}

-(NSString *)songTitle{
    QYMusic *model = [SongListHandel ShareSongList].songArr[_PlayerIndex];
    return model.kName;
}

-(UIImage *)songPicture
{
    QYMusic *model = [SongListHandel ShareSongList].songArr[_PlayerIndex];
    UIImage *image = [UIImage imageNamed:model.kIcon];
    return image;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"duration"]) {
        NSLog(@"----->%f",[change[@"new"] floatValue]);
    }
}


#pragma mark - 音乐播放完毕之后的调用
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        //暂停
//        [self stopTime];
        switch (self.playerType) {
            case sequenceLoop://循环播放
//                if (_PlayerIndex +1 >= [SongListHandel ShareSongList].songArr.count) {
//                    self.PlayerIndex = 0;
//                }else{
//                    self.PlayerIndex += 1;
//                }
                [self NextSong];
                break;
            case singleLoop://单曲循环
            {
//                self.PlayerIndex  = self.PlayerIndex;
                NSInteger currtIndex = self.PlayerIndex;
                self.PlayerIndex = -1;
                self.PlayerIndex = currtIndex;
            }
                break;
                
            case Random://随机播放
                self.PlayerIndex = arc4random()%[SongListHandel ShareSongList].songArr.count;
                break;
                
            default:
                break;
        }
        //开始
//        [self startTime];
    }
}

@end
