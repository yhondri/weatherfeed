//
//  WFCityCell.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 17/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCity, WFSearchResult;

@interface WFCityCell : UITableViewCell

- (void)setCity:(WFCity*)city;
- (void)setSearchResult:(WFSearchResult*)result;

@end
