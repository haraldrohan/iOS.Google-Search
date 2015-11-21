//
//  GoogleSearchViewController.h
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleSearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(IBAction)showMessage;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (nonatomic) NSArray *data;

@end
