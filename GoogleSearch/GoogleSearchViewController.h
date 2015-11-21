//
//  GoogleSearchViewController.h
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleSearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(IBAction)search;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *SearchTerm;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (nonatomic) NSArray *data;

@end
