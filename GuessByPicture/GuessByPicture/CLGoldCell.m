//
//  CLGoldCell.m
//  GuessByPicture
//
//  Created by apple on 14-6-13.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define Price_Key @"price"
#define Value_Key @"value"

#import "CLGoldCell.h"

@implementation CLGoldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithDict:(NSDictionary *)dict
{
    _desLabel.text = dict[Value_Key];
    
    [_moneyButton setTitle:[NSString stringWithFormat:@"%@",dict[Price_Key]] forState:UIControlStateNormal];
//    [_moneyButton addTarget:self action:@selector(buyGoldClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

@end
