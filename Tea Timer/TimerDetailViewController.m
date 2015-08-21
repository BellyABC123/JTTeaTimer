//
//  TimerDetailViewController.m
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import "TimerDetailViewController.h"

@interface TimerDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic,weak) NSTimer* timer;
@property (nonatomic,assign) NSInteger timeRemain;

@property(nonatomic,assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation TimerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.timerModel.name;
    self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                              self.timerModel.duration/60,
                              self.timerModel.duration%60];
    [self.timerModel addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.timerModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender{
    if(self.timer){
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                  self.timerModel.duration/60,
                                  self.timerModel.duration%60];
        [self.startStopButton setTitle:NSLocalizedString(@"Start",@"Start") forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        //[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [self.timer invalidate];
        [[UIApplication sharedApplication]endBackgroundTask:self.backgroundTaskIdentifier];
    }else{
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.startStopButton setTitle:NSLocalizedString(@"Stop",@"Stop") forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        self.timeRemain=self.timerModel.duration;
        self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                  self.timerModel.duration/60,
                                  self.timerModel.duration%60];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(timerFired:)
                                                  userInfo:nil
                                                   repeats:YES];
        self.backgroundTaskIdentifier= [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
            [self notifyUser:NSLocalizedString(@"Coffee Timer stopped running",@"Coffee Timer stopped running")];
        }];
    }
}

-(void)notifyUser:(NSString*)alert{
    if([[UIApplication sharedApplication]applicationState]==UIApplicationStateActive) {
        [[[UIAlertView alloc] initWithTitle:@"Coffee Timer"
                                    message:alert
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }else{
        UILocalNotification* notif=[[UILocalNotification alloc]init];
        notif.alertBody=alert;
        notif.alertAction=@"OK";
        notif.fireDate=nil;
        notif.soundName=UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication]scheduleLocalNotification:notif];
    }
}

-(void)timerFired:(NSTimer*)timer{
    self.timeRemain-=1;
    if(self.timeRemain>0){
        self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                  self.timeRemain/60,
                                  self.timeRemain%60];
    }else{
        self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                  self.timerModel.duration/60,
                                  self.timerModel.duration%60];
        [self.timer invalidate];
        self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                  self.timerModel.duration/60,
                                  self.timerModel.duration%60];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.startStopButton setTitle:NSLocalizedString(@"Start",@"Start") forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        //[self.startStopButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [self notifyUser:NSLocalizedString(@"Timer completed!",@"Timer completed!")];
        [[UIApplication sharedApplication]endBackgroundTask:self.backgroundTaskIdentifier];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"editDetail"]){
        UINavigationController* nc= segue.destinationViewController;
        TimerEditViewController* vc= (TimerEditViewController *)nc.topViewController;
        vc.timerModel=self.timerModel;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"duration"]) {
        if(!self.timer){
            self.countdownLabel.text=[NSString stringWithFormat:@"%02ld:%02ld",
                                      self.timerModel.duration/60,
                                      self.timerModel.duration%60];
        }
    }else if([keyPath isEqualToString:@"name"]){
        self.title=self.timerModel.name;
    }
}

-(void)dealloc{
    [self.timerModel removeObserver:self forKeyPath:@"duration"];
    [self.timerModel removeObserver:self forKeyPath:@"name"];
}

@end


