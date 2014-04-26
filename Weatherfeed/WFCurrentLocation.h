//
//  WFCurrentLocation.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 20/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WFCurrentWeather;

@interface WFCurrentLocation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) WFCurrentWeather *currentWeather;

@end
