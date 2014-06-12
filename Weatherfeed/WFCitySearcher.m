//
//  WFCitySearcher.m
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 30/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFCitySearcher.h"
#import "WFWeatherEngine.h"
#import "WFAppDelegate.h"
#import "WFCity.h"

NSString * const WFCitySearcherSearchCityURL = @"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&units=metric&mode=json";

@implementation WFCitySearcher

+ (void)searchForCity:(NSString*)city
         onCompletion:(CitySearchResponseBlock)completionBlock
{
    [WFAppDelegate sharedAppDelegate].operations++;
    
    city = [city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSURL *citySearchURL = [NSURL URLWithString:[NSString stringWithFormat:WFCitySearcherSearchCityURL, city]];
                       
                       NSData *citySearchData = [WFWeatherEngine getDataFromURL:citySearchURL];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [WFAppDelegate sharedAppDelegate].operations--;
                                          
                                          NSMutableArray *citiesFound;
                                          
                                          if (citySearchData) {
                                              NSError *error;
                                              NSDictionary *citySearchDictionary= [NSJSONSerialization JSONObjectWithData:citySearchData
                                                                                                                      options:kNilOptions
                                                                                                                        error:&error];
                                              
                                              citiesFound = [@[] mutableCopy];
                                              
                                              for (NSDictionary *cityDict in citySearchDictionary[@"list"]) {
                                                  WFSearchResult *newCity = [[WFSearchResult alloc] init];
                                                  newCity.idNumber = cityDict[@"id"];
                                                  newCity.name = cityDict[@"name"];
                                                  newCity.country = cityDict[@"sys"][@"country"];
                                                  newCity.coordinates = CLLocationCoordinate2DMake([cityDict[@"coord"][@"lat"] doubleValue], [cityDict[@"coord"][@"lon"] doubleValue]);
                                                  
                                                  newCity.icon = cityDict[@"weather"][0][@"icon"];
                                                  newCity.temp = cityDict[@"main"][@"temp"];
                                                  
                                                  [citiesFound addObject:newCity];
                                              }
                                          }
                                          
                                          completionBlock(citiesFound);
                                      });
                   });
}

+ (void)saveResult:(WFSearchResult*)result
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    if ([self cityExits:result]) {
        return;
    }
    
    WFCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    
    newCity.addedDate = [NSDate date];
    newCity.idNumber = result.idNumber;
    newCity.name = result.name;
    newCity.country = result.country;
    
    [context save:nil];
    
    [WFWeatherEngine updateWeatherDataForCity:newCity];
}

+ (BOOL)cityExits:(WFSearchResult*)result
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idNumber == %@", result.idNumber]];
    
    NSInteger count = [context countForFetchRequest:fetchRequest error:nil];
    
    return (count > 0);
}

@end
