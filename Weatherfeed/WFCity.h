//
//  WFCity.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 20/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WFCurrentWeather, WFDay, WFHour;

@interface WFCity : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) WFCurrentWeather *currentWeather;
@property (nonatomic, retain) NSSet *dailyForecast;
@property (nonatomic, retain) NSSet *hourlyForecast;
@end

@interface WFCity (CoreDataGeneratedAccessors)

- (void)addDailyForecastObject:(WFDay *)value;
- (void)removeDailyForecastObject:(WFDay *)value;
- (void)addDailyForecast:(NSSet *)values;
- (void)removeDailyForecast:(NSSet *)values;

- (void)addHourlyForecastObject:(WFHour *)value;
- (void)removeHourlyForecastObject:(WFHour *)value;
- (void)addHourlyForecast:(NSSet *)values;
- (void)removeHourlyForecast:(NSSet *)values;

@end
