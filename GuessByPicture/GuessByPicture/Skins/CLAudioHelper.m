//
//  CLAudioHelper.m
//  GuessByPicture
//
//  Created by apple on 14-6-10.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//

#import "CLAudioHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation CLAudioHelper
+ (void)playSoundWithFileName:(NSString *)name ofType:(NSString *)type
{
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *soundURL=[NSURL fileURLWithPath:soundPath];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
}
@end
