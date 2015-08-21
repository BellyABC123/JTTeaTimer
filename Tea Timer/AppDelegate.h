//
//  AppDelegate.h
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly,strong) NSPersistentStoreCoordinator* pStoreCoordinator;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel* managedObjectModel;

@end

