//
//  PlayViewController.m
//  LiveDemo
//
//  Created by kevin on 2017/6/23.
//  Copyright © 2017年 SLLive. All rights reserved.
//
#import <AFNetworking.h>
#import "PlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MBProgressHUD.h>
#import <RTRootNavigationController.h>
#import <Masonry.h>
@interface PlayViewController ()<MBProgressHUDDelegate>
@property(nonatomic,strong) IJKFFMoviePlayerController *player;
@property(nonatomic,strong) MBProgressHUD *Hud;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
  
    
    
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionIntValue:30 forKey:@"max-fps"];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.datel.flv] withOptions:option];

    self.player.view.frame = self.view.bounds;

    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
   
    self.player.shouldAutoplay = YES;
    [self.player prepareToPlay];
    [self.view addSubview:self.player.view];
    
    [self initObserver];
    
    self.Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.Hud.label.text = @"直播链接中";
    self.Hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    
    UIButton *close = [[UIButton alloc]init];
    [self.player.view addSubview: close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.player.view.mas_top).offset(30);
        make.right.mas_equalTo(self.player.view.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    close.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    close.layer.cornerRadius = 25;
    close.clipsToBounds = YES;
    [close setImage:[UIImage imageNamed:@"BackToHome"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;


}
- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld 直播状态%ld", self.player.loadState, self.player.playbackState);
   
    if (self.player.loadState & IJKMPMovieLoadStateStalled) {
        

        return;
    }
    __weak typeof(self)weakSelf = self;
    [[AFHTTPSessionManager manager] GET:self.datel.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@, 等待继续播放", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [self.rt_navigationController popToRootViewControllerAnimated:YES complete:nil];
        [weakSelf.player shutdown];
        [weakSelf.player.view removeFromSuperview];
        weakSelf.player = nil;
      
    }];
}
-(void)stateDidChange
{
     NSLog(@"加载状态...%ld 直播状态%ld ", self.player.loadState, self.player.playbackState);

    switch ( self.player.loadState) {
        case IJKMPMovieLoadStateUnknown:
            NSLog(@"//状态未知");
            break;
        case IJKMPMovieLoadStatePlayable:
              NSLog(@"//缓存数据足够开始播放，但是视频并没有缓存完全");
            break;
        case IJKMPMovieLoadStatePlaythroughOK:
              NSLog(@" //已经缓存完成，如果设置了自动播放，这时会自动播放");
            break;
        case IJKMPMovieLoadStateStalled:
              NSLog(@"//数据缓存已经停止，播放将暂停");
            break;
            
        default:
            break;
    }
    
    
    switch ( self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"//停止播放");
            break;
        case IJKMPMoviePlaybackStatePlaying:
            self.Hud.hidden = YES;
            NSLog(@"//正在播放");
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@" //暂停播放");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"//中断播放");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"////快进");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"//快退");
            break;
            
        default:
            break;
    }
    
    __weak typeof(self)weakSelf = self;
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!weakSelf.player.isPlaying) {
            [weakSelf.player play];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.Hud.hidden = YES;
               ;
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.Hud.hidden = YES;
                });
                
        
        }
    }else if (self.player.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)close
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES complete:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
