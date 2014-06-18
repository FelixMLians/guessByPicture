//
//  CLAppDelegate.h
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboApi.h"
@interface CLAppDelegate : UIResponder <UIApplicationDelegate,WeiboAuthDelegate,WeiboRequestDelegate>
{
    WeiboApi  *wbapi;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , retain) WeiboApi                    *wbapi;
@end
