//
//  CLBuyGoldViewController.h
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLBuyGoldViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *currentGoldLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *goldButton;
@property (weak, nonatomic) IBOutlet UIButton *missionButton;

@property (weak, nonatomic) IBOutlet UITableView *priceTableView;


@end
