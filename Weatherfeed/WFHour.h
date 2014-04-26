//
//  WFHour.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 20/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WFWeatherInfo.h"

@class WFCity;

@interface WFHour : WFWeatherInfo

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * precipitation;
@property (nonatomic, retain) WFCity *city;

@end
