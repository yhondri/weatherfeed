//
//  WFWeatherInfo.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 20/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WFWeatherInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * clouds;
@property (nonatomic, retain) NSNumber * windSpeed;
@property (nonatomic, retain) NSNumber * windDirection;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * weatherId;

@end
