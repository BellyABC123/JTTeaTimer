//
//  AppDelegate.m
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import "AppDelegate.h"
#import "TimerModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


-(NSPersistentStoreCoordinator*) persistentStoreCoordinator {
    if( _pStoreCoordinator==nil ){
        _pStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
        NSURL* applicationDocumentsDirectory=[[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        NSURL* storeURL=[applicationDocumentsDirectory URLByAppendingPathComponent:@"CoffeeTimer.sqlite"];
        NSError* error=nil;
        if (![_pStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error]) {
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
    }
    return _pStoreCoordinator;
}

-(NSManagedObjectModel*)managedObjectModel{
    if (_managedObjectModel==nil) {
        NSURL* modelURL=[[NSBundle mainBundle]URLForResource:@"CoffeeTimer" withExtension:@"momd"];
        _managedObjectModel=[[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

-(NSManagedObjectContext*) managedObjectContext {
    if(_managedObjectContext == nil ){
        _managedObjectContext=[[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"App launched");
    BOOL hasDefaultModels=[[NSUserDefaults standardUserDefaults]boolForKey:@"loadedDefaults"];
    if (!hasDefaultModels) {
        for(NSInteger i=0; i<5;i++){
            TimerModel* model=[NSEntityDescription insertNewObjectForEntityForName:@"TimerModel"
                                                            inManagedObjectContext:self.managedObjectContext];
            model.displayOrder=(int32_t)i;
            switch (i) {
                case 0:
                    model.name=NSLocalizedString(@"Columbian", @"Columbian name");
                    model.duration=240;
                    model.type=TimerModelTypeCoffee;
                    break;
                case 1:
                    model.name=NSLocalizedString(@"Mexican", @"Mexican name");
                    model.duration=40;
                    model.type=TimerModelTypeCoffee;
                    break;
                case 2:
                    model.name=NSLocalizedString(@"Green Tea", @"Green Tea name");
                    model.duration=200;
                    model.type=TimerModelTypeTea;
                    break;
                case 3:
                    model.name=NSLocalizedString(@"Oolong", @"Oolong name");
                    model.duration=140;
                    model.type=TimerModelTypeTea;
                    break;
                case 4:
                    model.name=NSLocalizedString(@"Rooibos", @"Columbian name");
                    model.duration=340;
                    model.type=TimerModelTypeTea;
                    break;
                default:
                    break;
            }
        }
        [[NSUserDefaults standardUserDefaults]setBool:YES
                                               forKey:@"loadedDefaults"];
    }
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"App will resign active");
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Could not save MOC: %@",error);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"App is bkg");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"App about to fg");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"App active");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"App about to terminate");
}

@end
