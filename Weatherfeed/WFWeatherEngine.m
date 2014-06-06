//
//  WFEngine.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 27/01/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFWeatherEngine.h"
#import "WFAppDelegate.h"
#import "WFCity.h"
#import "WFCurrentLocation.h"
#import "WFCurrentWeather.h"
#import "WFHour.h"
#import "WFDay.h"


NSString * const WFWeatherEngineLocationWeatherURL = @"http://api.openweathermap.org/data/2.5/find?lat=%f&lon=%f&units=metric&mode=json";
NSString * const WFWeatherEngineCurrentWeatherURL = @"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric&mode=json";
NSString * const WFWeatherEngineHourlyForecastURL = @"http://api.openweathermap.org/data/2.5/forecast?id=%@&units=metric&mode=json";
NSString * const WFWeatherEngineDailyForecastURL = @"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&cnt=14&units=metric&mode=json";

NSString * const WFWeatherEngineDidUpdateCityNotification = @"WFWeatherEngineDidUpdateCity%@Notification";
NSString * const WFWeatherEngineDidUpdateLocationDataNotification = @"WFWeatherEngineDidUpdateLocationDataNotification";

@implementation WFWeatherEngine

#warning Antes de ir a actualizar los datos de la ciudad hay que comprobar que hay internet, esto aún no está hecho.
+ (void)checkDataOfCities
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"addedDate != nil"]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    for (WFCity *city in fetchedObjects) {
        NSTimeInterval updateInterval = [[NSDate date] timeIntervalSinceDate:city.updatedDate];
        if (updateInterval >= 1800 || !city.updatedDate) {
            [WFWeatherEngine updateWeatherDataForCity:city];
        }
    }
}

+ (NSData*)getDataFromURL:(NSURL*)url
{
    NSData *response;
    NSInteger retryCount = 0;
    
    while (retryCount < 3 && response == nil) {
        retryCount++;
        response = [NSData dataWithContentsOfURL:url];
    }
    
    return response;
}

/*!  Método que recibe un atributo del tipo ciudad del cual sustrae su nombre para descargar los datos respecto a esa ciudad.
 @params city atributo de tipo WFCity.
 */
+ (void)updateWeatherDataForCity:(WFCity *)city
{
    NSLog(@"Updating weather for city: %@ ID: %@", city.name, city.idNumber);
    
    [WFAppDelegate sharedAppDelegate].operations++;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSURL *currentWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:WFWeatherEngineCurrentWeatherURL, city.idNumber]];
                       NSURL *hourlyForecastURL = [NSURL URLWithString:[NSString stringWithFormat:WFWeatherEngineHourlyForecastURL, city.idNumber]];
                       NSURL *dailyForecastURL = [NSURL URLWithString:[NSString stringWithFormat:WFWeatherEngineDailyForecastURL, city.idNumber]];
                       
                       NSData *currentWeatherData = [self getDataFromURL:currentWeatherURL];
                       NSData *hourlyForecastData = [self getDataFromURL:hourlyForecastURL];
                       NSData *dailyForecastData = [self getDataFromURL:dailyForecastURL];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [WFAppDelegate sharedAppDelegate].operations--;
                                          
                                          // If all data was obtained, the update is valid
                                          if (currentWeatherData && hourlyForecastData && dailyForecastData) {
                                              city.updatedDate = [NSDate date];
                                          }
                                          
                                          if (currentWeatherData) {
                                              [self updateCurrentWeatherForCity:city withData:currentWeatherData];
                                          }
                                          if (hourlyForecastData) {
                                              [self updateHourlyForecastForCity:city withData:hourlyForecastData];
                                          }
                                          if (dailyForecastData) {
                                              [self updateDailyForecastForCity:city withData:dailyForecastData];
                                          }
                                          
                                          [city.managedObjectContext save:nil];
                                          
                                          [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:WFWeatherEngineDidUpdateCityNotification, city.idNumber] object:nil];
                                      });
                   });
    
}

+ (void)updateCurrentWeatherForCity:(WFCity*)city
                           withData:(NSData*)data
{
    NSDictionary *currentWeatherDictionary= [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:nil];
    
    NSManagedObjectContext *context = city.managedObjectContext;
    
    WFCurrentWeather *currentWeahter = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentWeather" inManagedObjectContext:context];
    
    currentWeahter.sunrise = [NSDate dateWithTimeIntervalSince1970:[currentWeatherDictionary[@"sys"][@"sunrise"] integerValue]];
    currentWeahter.sunset = [NSDate dateWithTimeIntervalSince1970:[currentWeatherDictionary[@"sys"][@"sunset"] integerValue]];
    
    currentWeahter.weatherId = @([currentWeatherDictionary[@"weather"][0][@"id"] integerValue]);
    currentWeahter.text = currentWeatherDictionary[@"weather"][0][@"description"];
    currentWeahter.icon = currentWeatherDictionary[@"weather"][0][@"icon"];
    
    currentWeahter.temp = currentWeatherDictionary[@"main"][@"temp"];
    currentWeahter.humidity = currentWeatherDictionary[@"main"][@"humidity"];
    currentWeahter.pressure = currentWeatherDictionary[@"main"][@"pressure"];
    currentWeahter.windSpeed = currentWeatherDictionary[@"wind"][@"speed"];
    currentWeahter.windDirection = currentWeatherDictionary[@"wind"][@"deg"];
    currentWeahter.clouds = currentWeatherDictionary[@"clouds"][@"all"];
    
    city.currentWeather = currentWeahter;
}

+ (void)updateHourlyForecastForCity:(WFCity*)city
                           withData:(NSData*)data
{
    NSDictionary *hourlyWeatherDictionary= [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
    
    NSManagedObjectContext *context = city.managedObjectContext;
    
    [city removeHourlyForecast:[city hourlyForecast]];
    
    NSArray *hoursArray = hourlyWeatherDictionary[@"list"];
    
    for (NSDictionary *hourDict in hoursArray) {
        WFHour *newHour = [NSEntityDescription insertNewObjectForEntityForName:@"Hour" inManagedObjectContext:context];
        
        newHour.date = [NSDate dateWithTimeIntervalSince1970:[hourDict[@"dt"] integerValue]];
        
        newHour.weatherId = @([hourDict[@"weather"][0][@"id"] integerValue]);
        newHour.text = hourDict[@"weather"][0][@"description"];
        newHour.icon = hourDict[@"weather"][0][@"icon"];
        
        newHour.temp = hourDict[@"main"][@"temp"];
        
        newHour.humidity = hourDict[@"main"][@"humidity"];
        newHour.pressure = hourDict[@"main"][@"pressure"];
        
        newHour.windSpeed = hourDict[@"wind"][@"speed"];
        newHour.windDirection = hourDict[@"wind"][@"deg"];
        
        newHour.clouds = hourDict[@"clouds"][@"all"];
        
        if (hourDict[@"rain"]) {
            newHour.precipitation = hourDict[@"rain"][@"3h"];
        }
        
        [city addHourlyForecastObject:newHour];
    }
}

+ (void)updateDailyForecastForCity:(WFCity*)city
                          withData:(NSData*)data
{
    NSDictionary *dailyWeatherDictionary= [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
    
    NSManagedObjectContext *context = city.managedObjectContext;
    
    [city removeDailyForecast:[city dailyForecast]];
    
    NSArray *daysArray = dailyWeatherDictionary[@"list"];
    
    for (NSDictionary *dayDict in daysArray) {
        WFDay *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
        
        newDay.date = [NSDate dateWithTimeIntervalSince1970:[dayDict[@"dt"] integerValue]];
        
        newDay.weatherId = @([dayDict[@"weather"][0][@"id"] integerValue]);
        newDay.text = dayDict[@"weather"][0][@"description"];
        newDay.icon = dayDict[@"weather"][0][@"icon"];
        
        newDay.nightTemp = dayDict[@"temp"][@"night"];
        newDay.morningTemp = dayDict[@"temp"][@"morn"];
        newDay.dayTemp = dayDict[@"temp"][@"day"];
        newDay.eveningTemp = dayDict[@"temp"][@"eve"];
        newDay.maxTemp = dayDict[@"temp"][@"min"];
        newDay.minTemp = dayDict[@"temp"][@"max"];
        
        newDay.humidity = dayDict[@"humidity"];
        newDay.pressure = dayDict[@"pressure"];
        
        newDay.windSpeed = dayDict[@"speed"];
        newDay.windDirection = dayDict[@"deg"];
        
#warning Check if this is necessary
        if ([dayDict[@"clouds"] isKindOfClass:[NSNumber class]]) {
            newDay.clouds = dayDict[@"clouds"];
        }
        else {
            newDay.clouds = dayDict[@"clouds"][@"all"];
        }
        
        if (dayDict[@"rain"]) {
            newDay.precipitation = dayDict[@"rain"];
        }
        
        [city addDailyForecastObject:newDay];
    }
}

+ (void)updateWeatherDataForLatitude:(double)latitude
                           longitude:(double)longitude
{
    WFCity *city = [self currentLocationCity];
    
    NSTimeInterval updateInterval = [[NSDate date] timeIntervalSinceDate:city.updatedDate];
    if (updateInterval < 1800) {
        return;
    }
    
    [WFAppDelegate sharedAppDelegate].operations++;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSURL *locationWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:WFWeatherEngineLocationWeatherURL, latitude, longitude]];
                       
                       NSData *locationWeatherData = [self getDataFromURL:locationWeatherURL];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [WFAppDelegate sharedAppDelegate].operations--;
                                          
                                          if (locationWeatherData == nil) {
                                              NSLog(@"Error de descarga");
                                              
                                              return;
                                          }
                                          
                                          
                                          NSDictionary *locationWeatherDictionary= [NSJSONSerialization JSONObjectWithData:locationWeatherData
                                                                                                                   options:kNilOptions
                                                                                                                     error:nil];
                                          NSDictionary *cityDict = [locationWeatherDictionary[@"list"] firstObject];
                                          
                                          NSLog(@"Location %@", cityDict);
                                          
                                          city.idNumber = cityDict[@"id"];
                                          city.name = cityDict[@"name"];
                                          city.country = cityDict[@"sys"][@"country"];
                                          city.updatedDate = [NSDate date];
                                          
                                          
                                          NSManagedObjectContext *context = city.managedObjectContext;
                                          
                                          WFCurrentWeather *currentWeahter = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentWeather" inManagedObjectContext:context];
                                          
                                          currentWeahter.weatherId = @([cityDict[@"weather"][0][@"id"] integerValue]);
                                          currentWeahter.text = cityDict[@"weather"][0][@"description"];
                                          currentWeahter.icon = cityDict[@"weather"][0][@"icon"];
                                          
                                          currentWeahter.temp = cityDict[@"main"][@"temp"];
                                          currentWeahter.humidity = cityDict[@"main"][@"humidity"];
                                          currentWeahter.pressure = cityDict[@"main"][@"pressure"];
                                          currentWeahter.windSpeed = cityDict[@"wind"][@"speed"];
                                          currentWeahter.windDirection = cityDict[@"wind"][@"deg"];
                                          currentWeahter.clouds = cityDict[@"clouds"][@"all"];
                                          
                                          city.currentWeather = currentWeahter;
                                          
                                          [context save:nil];
                                          
                                          [[NSNotificationCenter defaultCenter] postNotificationName:WFWeatherEngineDidUpdateLocationDataNotification object:nil];
                                      });
                   });
}

+ (WFCity*)currentLocationCity
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"addedDate == nil"]];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    WFCity *city = [fetchedObjects firstObject];
    
    if (!city) {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        
        [context save:nil];
    }
    
    return city;
}

@end
