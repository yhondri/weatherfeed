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

NSString * const WFCitySearcherSearchCityURL = @"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&mode=json&units=metric";

@implementation WFCitySearcher

+ (void)searchForCity:(NSString*)city
         onCompletion:(CitySearchResponseBlock)completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSURL *citySearchURL = [NSURL URLWithString:[NSString stringWithFormat:WFCitySearcherSearchCityURL, city]];
                       
                       NSData *citySearchData = [WFWeatherEngine getDataFromURL:citySearchURL];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
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
    
    WFCity *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    
    newCity.addedDate = [NSDate date];
    newCity.idNumber = result.idNumber;
    newCity.name = result.name;
    newCity.country = result.country;
    
    [context save:nil];
}

@end