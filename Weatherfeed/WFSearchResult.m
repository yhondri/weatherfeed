//
//  WFSearchResult.m
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 01/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFSearchResult.h"

@implementation WFSearchResult

- (NSString *)description
{
    return [NSString stringWithFormat:@"CityID: %@ Name: %@, %@", self.idNumber, self.name, self.country];
}

@end
