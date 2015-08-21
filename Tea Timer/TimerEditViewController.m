//
//  TimerEditViewController.m
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import "TimerEditViewController.h"

@interface TimerEditViewController ()

@end

@implementation TimerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger mins=self.timerModel.duration/60;
    NSInteger secs=self.timerModel.duration%60;
    
    self.nameField.text=self.timerModel.name;
    [self updateLabelWithMinutes:mins seconds:secs];
    self.minutesSlider.value=mins;
    self.secondsSlider.value=secs;
    
    if(self.timerModel.type==TimerModelTypeCoffee){
        self.TimerTypeSegmentedControl.selectedSegmentIndex=0;
    }else{
        self.TimerTypeSegmentedControl.selectedSegmentIndex=1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
    [self saveModel];
    [self.delegate timerEditViewControllerDidSaveTimerModel:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sliderChanged:(id)sender{
    NSInteger mins=self.minutesSlider.value;
    NSInteger secs=self.secondsSlider.value;
    self.minutesSlider.value=mins;
    self.secondsSlider.value=secs;
    [self updateLabelWithMinutes:mins seconds:secs];
}

-(void)saveModel{
    TimerModelType type;
    if(self.TimerTypeSegmentedControl.selectedSegmentIndex==0){
        type=TimerModelTypeCoffee;
    }else{
        type=TimerModelTypeTea;
    }
    
    self.timerModel.name=self.nameField.text;
    self.timerModel.duration=(NSInteger)self.minutesSlider.value*60+(NSInteger)self.secondsSlider.value;
    self.timerModel.type=type;
}

-(void)updateLabelWithMinutes:(NSInteger)minutes
                      seconds:(NSInteger)secs{
    if (minutes==1) {
        self.minutesLabel.text=NSLocalizedString(@"1 Minute",@"1 Minute");
    }else{
        self.minutesLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%ld Minutes",@"Plural minutes"),(long)minutes];
    }
    
    if (secs==1) {
        self.secondsLabel.text=NSLocalizedString(@"1 Second",@"1 Second");
    }else{
        self.secondsLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%ld Seconds",@"Plural seconds"),(long)secs];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
