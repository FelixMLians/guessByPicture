//
//  CLGoldViewController.h
//  GuessByPicture
//
//  Created by apple on 14-6-13.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGoldViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataSource;

@end
