//
//  WFCityCell.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 17/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFCityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *skyImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
