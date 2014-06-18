//
//  CLBuyGoldViewController.m
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define Price_Key @"price"
#define Value_Key @"value"

#import "CLBuyGoldViewController.h"
#import "CLAudioHelper.h"
#import "CLGoldViewController.h"

@interface CLBuyGoldViewController ()
{
    NSArray *dataSourceOfGold;
    NSArray *dataSourceOfMission;
    
    NSInteger currentBtnSelected; // 1 代表金币 2 代表任务
    
    UILabel *goldBtnLabel;
    UILabel *missionBtnLabel;
}
@end

@implementation CLBuyGoldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSourceOfGoldAndMission];
    [self setupButtons];
    currentBtnSelected=1;
    [self setupTableView];
    currentBtnSelected=2;
    
    _currentGoldLabel.text=[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"] intValue]];
}
-(void)setupSourceOfGoldAndMission
{
    dataSourceOfGold = @[@{Price_Key:@"￥6",Value_Key:@"+288金币"},@{Price_Key:@"￥12",Value_Key:@"+666金币 赠送10%"},@{Price_Key:@"￥30",Value_Key:@"+1888金币 赠送20%"},@{Price_Key:@"￥68",Value_Key:@"+3999金币 赠送40%"}, @{Price_Key:@"￥128",Value_Key:@"+11888金币 赠送80%"}];
    
    dataSourceOfMission = @[@{Price_Key:@"接受",Value_Key:@"每天连续答对5题送100金币"},@{Price_Key:@"接受",Value_Key:@"每天分享5次送150金币"},@{Price_Key:@"接受",Value_Key:@"每天连续答对10题送300金币"}];
}
-(void)setupButtons
{
    [_goldButton setImage:[UIImage imageNamed:@"shop_button_open"] forState:UIControlStateNormal];
    [_goldButton setImage:[UIImage imageNamed:@"shop_button_close"] forState:UIControlStateSelected];
//    [_goldButton setTitle:@"金币" forState:UIControlStateNormal];
    goldBtnLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 13, 40, 20)];
    [_goldButton addSubview:goldBtnLabel];
    goldBtnLabel.text=@"金币";
    
    _goldButton.selected=NO;
    
    [_missionButton setImage:[UIImage imageNamed:@"shop_button_close"] forState:UIControlStateNormal];
    [_missionButton setImage:[UIImage imageNamed:@"shop_button_open"] forState:UIControlStateSelected];
//    [_missionButton setTitle:@"任务" forState:UIControlStateNormal];
    missionBtnLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 13, 40, 20)];
    [_missionButton addSubview:missionBtnLabel];
    missionBtnLabel.text=@"任务";
    _missionButton.selected=NO;
}
- (IBAction)goldButtonClick:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    if (currentBtnSelected==1) {
        [self setupTableView];
        currentBtnSelected=2;
        
    }
    _goldButton.selected=NO;
    _missionButton.selected=NO;
}
- (IBAction)missionButtonClick:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    if (currentBtnSelected==2) {
        [self setupTableView];
        currentBtnSelected=1;
    }
    _goldButton.selected=YES;
    _missionButton.selected=YES;
}
-(void)setupTableView
{
    CLGoldViewController  *goldCtl = [[CLGoldViewController alloc]init];
    goldCtl.dataSource = currentBtnSelected==1?dataSourceOfGold:dataSourceOfMission;
    
    [self addChildViewController:goldCtl];
    [goldCtl.view setFrame:[_priceTableView bounds]];
    [_priceTableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_priceTableView addSubview:goldCtl.view];
    _priceTableView.bounces=NO;
    _priceTableView.showsHorizontalScrollIndicator=NO;
}

/// 购买 金币
-(void)buyGoldClicked:(id)sender
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
