//
//  SearchViewController.h
//  GoogleSearch
//
//  Created by Harald Rohan on 11/22/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(IBAction)search;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UITextField *SearchTerm;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;


@end
