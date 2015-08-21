//
//  TimerListViewController.h
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerEditViewController.h"

@interface TimerListViewController : UITableViewController <TimerEditViewControllerDelegate,NSFetchedResultsControllerDelegate>

@end
