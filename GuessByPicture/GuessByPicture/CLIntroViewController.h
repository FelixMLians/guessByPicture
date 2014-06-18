//
//  CLIntroViewController.h
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CLIntroViewController : UIViewController
{
    BOOL _audioStatus; // 1 播放 0 停止

}
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfFan;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfBoard;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;


@end
