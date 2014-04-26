//
//  WFCurrentWeather.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 20/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WFWeatherInfo.h"

@class WFCity, WFCurrentLocation;

@interface WFCurrentWeather : WFWeatherInfo

@property (nonatomic, retain) NSDate * sunrise;
@property (nonatomic, retain) NSDate * sunset;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) WFCity *city;
@property (nonatomic, retain) WFCurrentLocation *currentLocation;

@end
