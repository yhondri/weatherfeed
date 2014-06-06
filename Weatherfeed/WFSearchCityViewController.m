//
//  WFSearchCityViewController.m
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 01/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFSearchCityViewController.h"
#import "WFCitySearcher.h"
#import "WFCityCell.h"

@interface WFSearchCityViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *citiesFound;

@end

@implementation WFSearchCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"WFCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ResultCell"];
    
    [self.searchTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [WFCitySearcher searchForCity:self.searchTextField.text
                     onCompletion:^(NSArray *citiesFound) {
                         self.citiesFound = citiesFound;
                         [self.tableView reloadData];
                     }];
    
    [textField resignFirstResponder];
    
    return NO;
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.citiesFound count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ResultCell";
    
    WFCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WFSearchResult *city = self.citiesFound[indexPath.row];
    [cell setSearchResult:city];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFSearchResult *result = self.citiesFound[indexPath.row];
    
    [WFCitySearcher saveResult:result];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WFWeatherEngineDidAddNewCityNotification" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
