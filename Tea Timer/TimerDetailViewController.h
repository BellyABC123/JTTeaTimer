//
//  TimerDetailViewController.h
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerModel.h"
#import "TimerEditViewController.h"

@interface TimerDetailViewController : UIViewController

@property (nonatomic,strong) TimerModel* timerModel;

@end
