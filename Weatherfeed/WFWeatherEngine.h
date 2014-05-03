//
//  WFEngine.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 27/01/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const WFWeatherEngineDidUpdateNotification;
extern NSString * const WFWeatherEngineDidUpdateLocationDataNotification;

@class WFCity, WFCurrentLocation;

@interface WFWeatherEngine : NSObject

+ (NSData*)getDataFromURL:(NSURL*)url;

+ (void)updateWeatherDataForCity:(WFCity *)city;
+ (void)checkDataOfCities;

+ (void)updateWeatherDataForLatitude:(double)latitude
                           longitude:(double)longitude;
+ (WFCity*)currentLocationCity;

@end
