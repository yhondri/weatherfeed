//
//  WFSearchCityViewController.h
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 01/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WFWeatherEngineDidAddNewCityNotification;

@interface WFSearchCityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end
