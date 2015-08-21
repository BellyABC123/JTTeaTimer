//
//  TimerModel.h
//  Coffe Timer
//
//  Created by Jack Thompson on 30/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


typedef enum:int32_t{
    TimerModelTypeCoffee=0,
    TimerModelTypeTea
}TimerModelType;

@interface TimerModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t duration;
@property (nonatomic) int32_t type;
@property (nonatomic) int32_t displayOrder;

@end
