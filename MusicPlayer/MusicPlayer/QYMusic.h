//
//  QYMusic.h
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QYMusic : NSObject

@property (nonatomic, strong) NSString *kName;
@property (nonatomic, strong) NSString *kType;
@property (nonatomic, strong) NSString *kArt;
@property (nonatomic, strong) NSString *kIcon;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)musicWithDic:(NSDictionary *)dic;

@end
