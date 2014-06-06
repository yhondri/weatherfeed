//
//  WFCityViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFViewController.h"

@class WFCity, WFCurrentWeather;

@interface WFCityViewController : WFViewController

- (id)initWithCity:(WFCity*) city;

@end
