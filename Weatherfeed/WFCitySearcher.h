//
//  WFCitySearcher.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 30/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSearchResult.h"

@interface WFCitySearcher : NSObject

typedef void (^CitySearchResponseBlock)(NSArray *citiesFound);

+ (void)searchForCity:(NSString*)city
         onCompletion:(CitySearchResponseBlock)completionBlock;

+ (void)saveResult:(WFSearchResult*)result;

@end
