//
//  ViewController.m
//  MusicPlayer
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYMusic.h"
#import "QYMusicCell.h"
#import "PlayMusicVC.h"
#import "PlayerHandel.h"
#import "SongListHandel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *music;
@end

@implementation ViewController
static NSString *identify = @"cell";

-(NSArray *)music
{
    if (_music  == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SongsInfos" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *models = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            QYMusic *music = [QYMusic musicWithDic:dic];
            [models addObject:music];
        }
        _music = models;
    }
    return _music;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.title = @"音乐列表";
}

-(void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 120;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SongListHandel ShareSongList].songArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYMusicCell" owner:self options:nil][0];
        QYMusic *model = [SongListHandel ShareSongList].songArr[indexPath.row];
        cell.music = model;
        
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    PlayMusicVC *pmvc = [[PlayMusicVC alloc] init];
    if ( [PlayerHandel sharePlayer].PlayerIndex!=indexPath.row) {
        [PlayerHandel sharePlayer].PlayerIndex=indexPath.row;
    }
    [self.navigationController pushViewController:pmvc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
