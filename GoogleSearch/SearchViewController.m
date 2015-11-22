//
//  SearchViewController.m
//  GoogleSearch
//
//  Created by Harald Rohan on 11/22/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import "SearchViewController.h"
#import "ShowImageViewController.h"
#import "ImageHandler.h"
#import <GBLoading/GBLoading.h>

typedef enum {
    UIStateList,
    UIStateImage,
    UIStateProgress,
} UIState;

@interface SearchViewController ()

@property (nonatomic) NSArray *data;
@property (nonatomic) UIImage *image;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.TableView registerClass:UITableViewCell.class  forCellReuseIdentifier:@"SimpleTableItem"];
    
    self.data = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem"];
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell: %ld", (long)indexPath.row];
    if (self.data.count > (uint)indexPath.row)
    {
        NSDictionary *result = self.data[(long)indexPath.row];
        
        NSString *title = result[@"titleNoFormatting"];
        cell.textLabel.text = title;
    }
    else
        cell.textLabel.text = @"";
    return cell;
}


- (void)setUiState:(UIState)uiState {
    
    // change the UI based on the given states
    self.TableView.hidden = (uiState != UIStateList);
    self.SearchTerm.hidden = (uiState != UIStateList);
    self.SearchButton.hidden = (uiState != UIStateList);
    self.ActivityIndicator.hidden = (uiState != UIStateProgress);
    
    switch (uiState) {
        case UIStateList: {
            [self.ActivityIndicator stopAnimating];
        } break;
            
        case UIStateImage: {
            [self.ActivityIndicator stopAnimating];
        } break;
            
        case UIStateProgress: {
            [self.ActivityIndicator startAnimating];
        } break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data.count > (uint)indexPath.row)
    {
        // set in progress state
        self.uiState = UIStateProgress;
        
        NSDictionary *result = self.data[(long)indexPath.row];
        
        NSString *url = result[@"url"];
        
        [[GBLoading sharedLoading] loadResource:url withBackgroundProcessor:kGBLoadingProcessorDataToImage success:^(id object) {
            
            // store image
            self.image = object;
            
            // switch controller
            [self performSegueWithIdentifier:@"ShowImage" sender:self];
            
            // set to next state
            self.uiState = UIStateList;
        } failure:^(BOOL isCancelled) {
            
            // reset to previous state
            self.uiState = UIStateList;
        }];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"ShowImage"])
    {
        // Get reference to the destination view controller
        ShowImageViewController *vc = [segue destinationViewController];
        vc.Image = self.image;
        //vc.ImageView.image = self.image;
    }
}


- (IBAction)search
{
    NSString *escapedString = self.SearchTerm.text;
    NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?q=%@&v=1.0&start=%d", escapedString, 0];

    // set in progress state
    self.uiState = UIStateProgress;
    
    [ImageHandler getImagesWithUrlString:urlString completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            self.data = [[NSMutableArray alloc] init];
        } else {
            // the response is actually always a http or https response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *responseData = responseObject[@"responseData"];
                self.data = responseData[@"results"];
                [self.TableView reloadData];
            }
            else {
                NSLog(@"Error: %@ (%@)", responseObject[@"responseDetails"], httpResponse);
            }
        }
        // reset state
        self.uiState = UIStateList;
    }];
}


@end
