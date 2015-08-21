//
//  TimerEditViewController.h
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerModel.h"

@class TimerEditViewController;

typedef enum {
    TimerEditViewControllerTypeCoffee=0,
    TimerEditViewControllerTypeTea
} TimerEditViewControllerType;

@protocol TimerEditViewControllerDelegate <NSObject>

-(void)timerEditViewControllerDidCancel:(TimerEditViewController*)viewController;
-(void)timerEditViewControllerDidSaveTimerModel:(TimerEditViewController*)viewController;

@end


@interface TimerEditViewController : UIViewController

@property (nonatomic,strong) TimerModel* timerModel;
@property (nonatomic,assign) BOOL creatingNewTimer;
@property (nonatomic,weak) id<TimerEditViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UISlider *minutesSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondsSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TimerTypeSegmentedControl;

@end
