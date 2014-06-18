//
//  CLIntroViewController.m
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define Initial_Level 1
#define Initial_Gold 250

#import "CLIntroViewController.h"
#import "CLMainViewController.h"
#import "CLAudioHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface CLIntroViewController ()
{
    BOOL isSoundButtonClicked;
}
- (void)musicPlay;
- (void)musicStop;

- (void) startAnimation;

@end

static AVAudioPlayer *_audioPlayer = nil;

@implementation CLIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - button click action

- (IBAction)feedBack:(id)sender {
    //点击音效
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    NSLog(@"feedback(use umfeedback)");
}

- (IBAction)soundSwitch:(id)sender {
    if (!isSoundButtonClicked) {
        _soundButton.selected=YES;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AudioStatus"];
        [self musicStop];
        
    }
    else{
        _soundButton.selected=NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AudioStatus"];
        [self musicPlay];
    }
    isSoundButtonClicked=!isSoundButtonClicked;
    
    //每次点击加上音效
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
}

- (IBAction)startGame:(id)sender {
    //点击音效
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    CLMainViewController *mainCtl=[[CLMainViewController alloc]init];
    [self.navigationController pushViewController:mainCtl animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController.navigationItem setHidesBackButton:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //确认等级
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentLevel"]) {
        [[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentLevel"]integerValue];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:Initial_Level forKey:@"CurrentLevel"];
    }
    
    //确认金币
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentGold"]) {
        [[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentGold"]integerValue];
    }
    else{
        [[NSUserDefaults standardUserDefaults]setInteger:Initial_Gold forKey:@"CurrentGold"];
    }
    
    //确认音乐状态
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"AudioStatus"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AudioStatus"];
    }
    
    //播放音乐
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"AudioStatus"]) {
        [self musicPlay];
    }
    
    //画面动画
    [self startAnimation];
    
    //声音按钮，默认播放声音
    isSoundButtonClicked=NO;
    [_soundButton setImage:[UIImage imageNamed:@"btn_music_on"] forState:UIControlStateSelected];
    _soundButton.selected=NO;
    
//    _imageOfBoard.layer.anchorPoint = CGPointMake(0.5, 0.0);
}

#pragma mark private

- (void)musicPlay
{
    //如果播放器没有初始化，初始化；
    if (!_audioPlayer) {
        NSString *musicStr=[[NSBundle mainBundle] pathForResource:@"bg0" ofType:@"mp3"];
        NSURL *musicURL=[[NSURL alloc]initFileURLWithPath:musicStr];
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:musicURL error:nil];
    }
    
    //播放器时候播放
    if (![_audioPlayer isPlaying]) {
        [_audioPlayer prepareToPlay];
        [_audioPlayer setVolume:0.8];
        _audioPlayer.numberOfLoops=-1;
        [_audioPlayer play];
    }
    
}

- (void)musicStop
{
    //停止播放
    [_audioPlayer stop];
}

#pragma mark - animation with timer

- (void) startAnimation
{
    //风车旋转
    CABasicAnimation *fanAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    fanAnimation.toValue=[NSNumber numberWithFloat:M_PI*2.0];
    fanAnimation.duration=3;
    fanAnimation.repeatCount=9999;
    [_imageOfFan.layer addAnimation:fanAnimation forKey:@"animation1"];
    
    //定时器,招牌左右摇摆
    NSTimer *timer=[NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(shopCarFly) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)shopCarFly
{
    
    //招牌左右摇摆
    CAKeyframeAnimation *shopCarAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    shopCarAnimation.duration=5;
    shopCarAnimation.repeatCount=3;
    shopCarAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    NSMutableArray *values=[NSMutableArray array];
//    [values addObject:[NSNumber numberWithFloat:0*M_PI/180]];
    [values addObject:[NSNumber numberWithFloat:40*M_PI/180]];
    [values addObject:[NSNumber numberWithFloat:0*M_PI/180]];
    [values addObject:[NSNumber numberWithFloat:-40*M_PI/180]];
    [values addObject:[NSNumber numberWithFloat:0*M_PI/180]];
    [values addObject:[NSNumber numberWithFloat:40*M_PI/180]];
    shopCarAnimation.values=values;
    
    CGPoint oldAnchorPoint=_imageOfBoard.layer.anchorPoint;
    [_imageOfBoard.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
    [_imageOfBoard.layer setPosition:CGPointMake(_imageOfBoard.layer.position.x+_imageOfBoard.layer.bounds.size.width*(_imageOfBoard.layer.anchorPoint.x-oldAnchorPoint.x), _imageOfBoard.layer.position.y+_imageOfBoard.layer.bounds.size.height*(_imageOfBoard.layer.anchorPoint.y-oldAnchorPoint.y))];
    
    [_imageOfBoard.layer addAnimation:shopCarAnimation forKey:@"animation2"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
