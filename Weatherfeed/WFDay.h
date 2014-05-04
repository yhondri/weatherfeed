//
//  WFDay.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 04/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WFWeatherInfo.h"

@class WFCity;

@interface WFDay : WFWeatherInfo

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dayTemp;
@property (nonatomic, retain) NSNumber * eveningTemp;
@property (nonatomic, retain) NSNumber * morningTemp;
@property (nonatomic, retain) NSNumber * nightTemp;
@property (nonatomic, retain) NSNumber * precipitation;
@property (nonatomic, retain) NSNumber * maxTemp;
@property (nonatomic, retain) NSNumber * minTemp;
@property (nonatomic, retain) WFCity *city;

@end
