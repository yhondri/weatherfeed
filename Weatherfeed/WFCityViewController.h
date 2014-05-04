//
//  WFCityViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCity, WFCurrentWeather;

@interface WFCityViewController : UIViewController

- (id)initWithCity:(WFCity*) city;

@property NSUInteger pageIndex;

@end
