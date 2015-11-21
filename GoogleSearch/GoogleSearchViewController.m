//
//  GoogleSearchViewController.m
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import "GoogleSearchViewController.h"
#import "ImageHandler.h"
#import <GBLoading/GBLoading.h>

typedef enum {
    UIStateList,
    UIStateImage,
    UIStateProgress,
} UIState;

@interface GoogleSearchViewController ()

@property (assign, nonatomic) UIState                                       uiState;

@end

@implementation GoogleSearchViewController

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
    return 5;
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
    self.ImageView.hidden = (uiState != UIStateImage);
    self.BackButton.hidden = (uiState != UIStateImage);
    //self.Title.hidden = (uiState == UIStateProgress);
    self.ActivityIndicator.hidden = (uiState != UIStateProgress);
    
    switch (uiState) {
        case UIStateList: {
            self.Title.text = @"Image Search";
            [self.ActivityIndicator stopAnimating];
        } break;
            
        case UIStateImage: {
            self.Title.text = @"Image";
            [self.ActivityIndicator stopAnimating];
        } break;
            
        case UIStateProgress: {
            self.Title.text = @"Loading";
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
            
            // update our image
            UIImage *viennaImage = object;
            self.ImageView.image = viennaImage;
            
            // set to next state
            self.uiState = UIStateImage;
        } failure:^(BOOL isCancelled) {
            
            // reset to previous state
            self.uiState = UIStateList;
        }];
    }
}


- (IBAction)search
{
    NSString *escapedString = self.SearchTerm.text;
    NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?q=%@&v=1.0&start=%d", escapedString, 1];
    
    // set in progress state
    self.uiState = UIStateProgress;
    
    [ImageHandler getImagesWithUrlString:urlString completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            self.data = [[NSArray alloc] init];
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

- (IBAction)back
{
    // set to previous state
    self.uiState = UIStateList;

}


@end
