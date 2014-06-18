//
//  CLMainViewController.m
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define Initial_Level 1
#define Initial_Gold 250
#define wordsColomes 8
#define wordsRows 3
#define Gold_Per_Question 30

#import "CLMainViewController.h"
#import "CLBuyGoldViewController.h"
#import "CLAudioHelper.h"

const static NSString *_wordsString = @"寿 弄 麦 形 进 戒 吞 远 违 运 扶 抚 坛 技 坏 扰 拒 找 批 扯 址 走 抄 坝 贡 攻 赤 折 抓 扮 抢 孝 均 抛 投 坟 抗 坑 坊 抖 护 壳 志 扭 块 声 把 报 却 劫 芽 花 芹 芬 苍 芳 严 芦 劳 克 苏 杆 杠 杜 材 村 杏 极 李 杨 求 更 束 豆 两 丽 医 辰 励 否 还 歼 来 连 步 坚 旱 盯 呈 时 吴 助 县 里 呆 园 旷 围 呀 吨 足 邮 男 困 吵 串 员 听 吩 吹 呜 吧 吼 别 岗 帐 财 针 钉 告 我 乱 利 秃 秀 私 每 兵 估 体 何 但 伸 作 伯 伶 佣 低 你 住 位 伴 身 皂 佛 近 彻 役 返 余 希 坐 谷 妥 含 邻 岔 肝 肚 肠 龟 免 狂 犹 角 删 条 卵 岛 迎 饭 饮 系 言 冻 状 亩 况 床 库 疗 应 冷 这 序 辛 弃 冶 忘 闲 间 闷 判 灶 灿 弟 汪 沙 汽 沃 泛 沟 没 沈 沉 怀 忧 快 完 宋 宏 牢 究 穷 灾 良 证 启 评 补 初 社 识 诉 诊 词 译 君 灵 即 层 尿 尾 迟 局 改 张 忌 际 陆 阿 陈 阻 附 妙 妖 妨 努 忍 劲 鸡 驱 纯 纱 纳 纲 驳 纵 纷 纸 纹 纺 驴 纽";


@interface CLMainViewController ()

{
    NSInteger _currentLevel;  // 当前level
    NSInteger _currentGold; // 当前金币数量
    NSString *_currentAnswer; // 答案
    NSInteger _currentWordIndex;  // 当前应该填字的位置：1 2 3 4
    NSMutableString *currentPrepareWordsString;
    
    NSMutableDictionary *maps;
    
    BOOL _isWrong;
    BOOL _answerBtnSelectWhenWrong;
    BOOL _firstShowWord;
}

- (UIImage *)getSharedImage;

@end

@implementation CLMainViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self gameStart];
    [self setupButtons];
    [self setupAnswerCorrectBorad];
    [self setupShowWordBoard];
    [self createWordsView];
    
    _shareView.hidden=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(cancelShareView)];
    [_shareView addGestureRecognizer:tap];
}
-(void)gameStart
{
    //确定等级
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"]){
        _currentLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"] intValue];
        
    }else{
        _currentLevel = Initial_Level;
        [[NSUserDefaults standardUserDefaults] setInteger:Initial_Level forKey:@"CurrentLevel"];
    }
    
    //确定金币
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"]){
        _currentGold = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"] intValue];
        
    }else{
        _currentGold = Initial_Gold;
        [[NSUserDefaults standardUserDefaults] setInteger:Initial_Gold forKey:@"CurrentGolden"];
    }
    
    _currentWordIndex = 0;
    _isWrong = NO;
    _answerBtnSelectWhenWrong = NO;
    _firstShowWord = YES;
    maps = [NSMutableDictionary dictionary];
    
    //添加答案的汉字
    NSString *questionStr=[[NSBundle mainBundle] pathForResource:@"question" ofType:@"plist"];
    NSArray *questionArr=[NSArray arrayWithContentsOfFile:questionStr];
    if ([questionArr[_currentLevel-1] isKindOfClass:[NSDictionary class]]) {
        _currentAnswer=[questionArr[_currentLevel-1] valueForKey:@"answer"];
    }
    
    //level label
    _levelLabel.text=[NSString stringWithFormat:@"Level: %d",_currentLevel];
    
    //gold label
    _goldLabel.text=[NSString stringWithFormat:@"%d",_currentGold];
    
    //question image view
    NSString *imgName = [NSString stringWithFormat:@"question%d",[[questionArr[_currentLevel-1] objectForKey:@"question"] intValue]];
    _questionImgView.image = [UIImage imageNamed:imgName];
}
-(void)setupAnswerCorrectBorad
{
    _correctAnswerBoard.hidden=YES;
}
-(void)setupShowWordBoard
{
    _showWordView.hidden=YES;
}
-(void)setupButtons
{
    _firstButton.tag=200;
    [_firstButton setImage:[UIImage imageNamed:@"answer_press"] forState:UIControlStateHighlighted];
    [_firstButton addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    _secondButton.tag=201;
    [_secondButton setImage:[UIImage imageNamed:@"answer_press"] forState:UIControlStateHighlighted];
    [_secondButton addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    _thirdButton.tag=202;
    [_thirdButton setImage:[UIImage imageNamed:@"answer_press"] forState:UIControlStateHighlighted];
    [_thirdButton addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    _forthButton.tag=203;
    [_forthButton setImage:[UIImage imageNamed:@"answer_press"] forState:UIControlStateHighlighted];
    [_forthButton addTarget:self action:@selector(answerButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [_backButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [_goldButton setImage:[UIImage imageNamed:@"btn_gold_press"] forState:UIControlStateHighlighted];
    [_shareButton setImage:[UIImage imageNamed:@"btn_share_press"] forState:UIControlStateHighlighted];
    [_showWordButton setImage:[UIImage imageNamed:@"btn_showword_press"] forState:UIControlStateHighlighted];
    
    [_nextQuestionButton setImage:[UIImage imageNamed:@"bt_next_press"] forState:UIControlStateHighlighted];
}
- (IBAction)backButton:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)buyGoldCoin:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    CLBuyGoldViewController *goldShop=[[CLBuyGoldViewController alloc]init];
    [self.navigationController pushViewController:goldShop animated:YES];
    
}
- (IBAction)showWord:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    [_showWordDesLabel setText:[NSString stringWithFormat:@"确认花掉%@个金币来显示一个答案？",_goldPerQuestion.text]];
    _showWordView.hidden=NO;
}

#pragma mark - share
- (IBAction)share:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    _shareView.hidden=NO;
}
-(void)cancelShareView
{
    [_shareView setHidden:YES];
}
- (IBAction)confirmShare:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    //截屏
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"For Test:恭喜你答对了！", @"content",
                                   image, @"pic",
                                   nil];
    [_wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
}

- (IBAction)askForHelp:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    //截屏
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"For Test:这游戏究竟是有多难，快帮帮我！", @"content",
                                   image, @"pic",
                                   nil];
    [_wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    
}

#pragma mark - privates
- (void)createWordsView
{
    
    [_wordsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int count=wordsColomes*wordsRows;
    
    //prepare count words
    NSMutableString *prepareWords=[[NSMutableString alloc]init];
    for (int i=0; i<count-4; i++) {
        NSString *aWord=[_wordsString substringWithRange:NSMakeRange(arc4random()%(_wordsString.length), 1)];
        if (![aWord isEqual:@" "]) {
        [prepareWords appendString:aWord];
        }
        else{
            count++;
        }
    }
    [prepareWords appendString:_currentAnswer];
    
    NSMutableString *restWordStr = [NSMutableString stringWithString:prepareWords];
    NSMutableString *chosedWordStr = [NSMutableString string];
    for (int i=0; i<24; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"word.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"word_press.png"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(wordButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        //随机布局words
        NSRange selectedRange = NSMakeRange(rand()%[restWordStr length], 1);
        NSString *aWord = [restWordStr substringWithRange:selectedRange];
        [btn setTitle:aWord forState:UIControlStateNormal];
        [restWordStr replaceCharactersInRange:selectedRange withString:@""];

        
        //set btn frame
        CGFloat x = i%wordsColomes*(265/8.0+5) ;
        CGFloat y = (i/wordsColomes)*(265/8.0+5);
        
        [btn setFrame:CGRectMake(0, y, 265/8.0, 265/8.0)];
        [_wordsView addSubview:btn];
        [_wordsView setFrame:CGRectMake(_wordsView.frame.origin.x, _wordsView.frame.origin.y, _wordsView.frame.size.width, (265/8.0+5)*3-5)];
        _wordsView.backgroundColor=[UIColor clearColor];
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [btn setFrame:CGRectMake(x, y, 265/8.0*1.2, 265/8.0*1.2)];
            
        } completion:^(BOOL finished){
            
            if (finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [btn setFrame:CGRectMake(x, y, 265/8.0, 265/8.0)];
                    
                    
                } completion:^(BOOL finished){
                    
                    
                    
                }];
                
            }
            
        }];
        
        
    }
    
    // record this round of wordsStirng
    currentPrepareWordsString = chosedWordStr;
}
-(void)answerButtonSelected:(UIButton *)button
{
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    UIButton *btn=button;
    if (_isWrong) {
        for (int i=0; i<4; i++) {
            UIButton *b=(UIButton *)[self.view viewWithTag:i+200];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        _answerBtnSelectWhenWrong=YES;
    }
    if ([btn.titleLabel.text length]>0) {
        btn.titleLabel.text=nil;
        [btn setTitle:nil forState:UIControlStateNormal];
        
        //还原word
        int targetWord=[maps[[NSString stringWithFormat:@"%d",(btn.tag - 200)]] intValue];
        UIButton *wordButton=(UIButton *)[_wordsView viewWithTag:targetWord];
        wordButton.hidden=NO;
    }
    if (_currentWordIndex>btn.tag-200) {
        _currentWordIndex=btn.tag-200;
    }
}
-(void)wordButtonSelected:(UIButton *)button
{
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    //如果成语错了，而4个答案栏又没有点击的情况
    if (_isWrong) {
        if (!_answerBtnSelectWhenWrong) {
            for (int i=0; i<4; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:(i+200)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitle:nil forState:UIControlStateNormal];
                btn.titleLabel.text = nil;
                
                //对应的 word button 显示出来
                int targetWordTag = [maps[[NSString stringWithFormat:@"%d",(btn.tag - 200)]] intValue];
                [_wordsView viewWithTag:targetWordTag].hidden = NO;
                
            }
            _currentWordIndex = 0;
        }
        _answerBtnSelectWhenWrong = NO;
        _isWrong = NO;
    }
    
    //如果成语没有错，
    UIButton *wordBtn = (UIButton *)button;
    NSString *text = wordBtn.titleLabel.text;
    
    //set answer button
    UIView *unkonw = [self.view viewWithTag:(_currentWordIndex+200)];
    if ([unkonw isKindOfClass:[UIButton class]]) {
        UIButton *answerBtn = (UIButton *)unkonw;
        [answerBtn setTitle:text forState:UIControlStateNormal];
    }
    
    //隐藏汉字button
    wordBtn.hidden=YES;
    [maps setObject:[NSString stringWithFormat:@"%d",wordBtn.tag] forKey:[NSString stringWithFormat:@"%d",_currentWordIndex]];
    
    // 这是揭晓答案的时刻
    if (_currentWordIndex == 3) {
        
        [self checkAnswer];
        return;
    }
    
    //如果不是最后一个，判断后面的空格是否已经填写
    while (_currentWordIndex!=3) {
        _currentWordIndex ++;
        UIButton *b=[[UIButton alloc]init];
        UIView *view=[self.view viewWithTag:_currentWordIndex +200];
        if ([view isKindOfClass:[UIButton class]]) {
            b=(UIButton *)view;
        }
        if ([b.titleLabel.text length]==0) {
            return;
        }
        else{
            [self checkAnswer];
            return;
        }
    }

}

-(void)checkAnswer
{
    NSMutableString *yourAnswer=[[NSMutableString alloc]init];
    for (int i=0; i<4; i++) {
        UIButton *b=(UIButton *)[self.view viewWithTag:200+i];
        NSString *str=b.titleLabel.text;
        [yourAnswer appendString:str];
    }
    if ([self checkAnswerWithYourAnswer:yourAnswer]) {
        [self youAreRight];
    }
    else{
        [self youAreWrong];
    }
}
- (BOOL)checkAnswerWithYourAnswer:(NSString *)yourAnswer{
    
    return [_currentAnswer isEqualToString:yourAnswer];
    
}
-(void)youAreRight
{
    NSLog(@"you are right");
    _currentWordIndex=0;
    
    //获得金币
    int currentGold = [_goldLabel.text intValue] + Gold_Per_Question;
    _goldLabel.text = [NSString stringWithFormat:@"%d",currentGold];
    [[NSUserDefaults standardUserDefaults] setInteger:currentGold forKey:@"CurrentGolden"];
    
    [UIView animateWithDuration:0.75 animations:^{
        
        [_wordsView setFrame:CGRectMake(_wordsView.frame.origin.x, _wordsView.frame.origin.y-[UIScreen mainScreen].bounds.size.height, _wordsView.frame.size.width, _wordsView  .frame.size.height)];
        _wordsView.hidden = NO;
        _wordsView.alpha = 1;
        
    } completion:^(BOOL finished){
        //
        [_answerDesLabel setText:[NSString stringWithFormat:@"恭喜你顺利晋升到等级%d!",_currentLevel+1]];
        
        [_correctAnswerBoard setHidden:NO];
        _currentLevel++;
        
    }];

}
-(void)youAreWrong
{
    NSLog(@"you are wrong");
    _isWrong=YES;
    
    for (int i=0; i<4; i++) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:i +200];
        
        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.repeatCount=6;
        animation.duration=0.25;
        
        float rand=(float)random();
        [animation setBeginTime:CACurrentMediaTime()+rand*.0000000001 ];
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSNumber numberWithFloat:(-5)*M_PI/180]];
        [values addObject:[NSNumber numberWithFloat:(5)*M_PI/180]];
        [values addObject:[NSNumber numberWithFloat:(-5)*M_PI/180]];
        
        animation.values=values;
        [btn.layer addAnimation:animation forKey:nil];
        
        [UIView animateWithDuration:0.6 animations:^{
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }];
    }
}
- (IBAction)turnToNextQuestion:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:_currentLevel forKey:@"CurrentLevel"];
    [[NSUserDefaults standardUserDefaults]setInteger:_currentGold forKey:@"CurrentGold"];
    
    //隐藏提示栏
    [_correctAnswerBoard setHidden:YES];
    
    
    [self gameStart];
    [self createWordsView];
    
    //answer 栏的汉字清空
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:(i+200)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:nil forState:UIControlStateNormal];
        btn.titleLabel.text = nil;
    }
    
    //24个汉字重现
    [UIView animateWithDuration:0.75 animations:^{
        
        
        [_wordsView setFrame:CGRectMake(_wordsView.frame.origin.x, _wordsView.frame.origin.y+[UIScreen mainScreen].bounds.size.height, _wordsView.frame.size.width, _wordsView  .frame.size.height)];
        _wordsView.hidden = NO;
        _wordsView.alpha = 1;
        
    } completion:^(BOOL finished){
    
        
    }];

    
}
- (IBAction)cancelShowWord:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    [_showWordView setHidden:YES];
}
- (IBAction)confirmShowWord:(id)sender {
    [CLAudioHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    if (_firstShowWord) {
        if ((_currentGold-30)>0) {
        _currentGold-=30;
        _goldLabel.text=[NSString stringWithFormat:@"%d",_currentGold];
        [[NSUserDefaults standardUserDefaults]setInteger:_currentGold forKey:@"CurrentGold"];
            _firstShowWord=NO;
            _showWordGoldLabel.text=[NSString stringWithFormat:@"%d",Gold_Per_Question*2];

            //显示提示汉字
            NSString *word=[_currentAnswer substringWithRange:NSMakeRange(_currentWordIndex, 1)];
            UIButton *btn = (UIButton *)[self.view viewWithTag:(_currentWordIndex+200)];
            [btn setTitle:word  forState:UIControlStateNormal];
               _currentWordIndex++;
            if (_currentWordIndex==4) {
                [self checkAnswer];
            }
            
            [_showWordView setHidden:YES];
            
            //金币保存
            int currentGold = [_goldLabel.text intValue];
            [[NSUserDefaults standardUserDefaults] setInteger:currentGold forKey:@"CurrentGolden"];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"你的金币已经不足，请到商店购买！" delegate:self cancelButtonTitle:@"不用了，下次" otherButtonTitles:@"好的", nil];
            alert.tag=1000;
            [alert show];
        }
    }
    else{
        if ((_currentGold-60)>0) {
            _currentGold-=60;
            _goldLabel.text=[NSString stringWithFormat:@"%d",_currentGold];
            [[NSUserDefaults standardUserDefaults]setInteger:_currentGold forKey:@"CurrentGold"];
//            _firstShowWord=NO;
        
            //显示提示汉字
            NSString *word=[_currentAnswer substringWithRange:NSMakeRange(_currentWordIndex, 1)];
            UIButton *btn = (UIButton *)[self.view viewWithTag:(_currentWordIndex+200)];
            [btn setTitle:word  forState:UIControlStateNormal];
            _currentWordIndex++;
            if (_currentWordIndex==4) {
                [self checkAnswer];
            }
            
            [_showWordView setHidden:YES];
            
            //金币保存
            int currentGold = [_goldLabel.text intValue];
            [[NSUserDefaults standardUserDefaults] setInteger:currentGold forKey:@"CurrentGolden"];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"你的金币已经不足，请到商店购买！" delegate:self cancelButtonTitle:@"不用了，下次" otherButtonTitles:@"好的", nil];
            alert.tag=1001;
            [alert show];
        }

    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [_showWordView setHidden:YES];
    }
    else if (buttonIndex==1)
    {
        [_showWordView setHidden:YES];
        CLBuyGoldViewController *buyGold=[[CLBuyGoldViewController alloc]init];
        [self.navigationController pushViewController:buyGold animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
