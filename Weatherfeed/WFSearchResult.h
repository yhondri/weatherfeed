//
//  WFSearchResult.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 01/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface WFSearchResult : NSObject

@property (strong, nonatomic) NSNumber *idNumber;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) NSNumber *temp;
@property (strong, nonatomic) NSString *icon;

@end
