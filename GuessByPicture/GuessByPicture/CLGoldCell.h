//
//  CLGoldCell.h
//  GuessByPicture
//
//  Created by apple on 14-6-13.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGoldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;

- (void)setupCellWithDict:(NSDictionary *)dict;
@end
