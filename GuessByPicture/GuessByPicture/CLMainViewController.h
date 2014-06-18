//
//  CLMainViewController.h
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboApi.h"

@interface CLMainViewController : UIViewController<UIAlertViewDelegate,WeiboRequestDelegate,WeiboAuthDelegate>

@property (nonatomic , retain) WeiboApi                    *wbapi;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *goldButton;
@property (weak, nonatomic) IBOutlet UIButton *showWordButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *wordsView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *showWordGoldLabel;

@property (weak, nonatomic) IBOutlet UIImageView *questionImgView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *forthButton;

@property (weak, nonatomic) IBOutlet UIView *correctAnswerBoard;
@property (weak, nonatomic) IBOutlet UILabel *answerDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldPerQuestion;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;

@property (weak, nonatomic) IBOutlet UIView *showWordView;
@property (weak, nonatomic) IBOutlet UILabel *showWordDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *confirmShareButton;
@property (weak, nonatomic) IBOutlet UIButton *helpShareButton;

@end
