//
//  QYMusicCell.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYMusicCell.h"
#import "QYMusic.h"
@interface QYMusicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ArtLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation QYMusicCell

-(void)setMusic:(QYMusic *)music
{
    _music = music;
    _imgView.layer.cornerRadius = 55;
    _imgView.layer.masksToBounds = YES;
    _imgView.image = [UIImage imageNamed:music.kIcon];
    _titleLabel.text = music.kName;
    _ArtLabel.text = music.kArt;
    _typeLabel.text = music.kType;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
