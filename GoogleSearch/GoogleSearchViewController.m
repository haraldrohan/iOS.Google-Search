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

@interface GoogleSearchViewController ()

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data.count > (uint)indexPath.row)
    {
        [self.ActivityIndicator startAnimating];
        
        NSDictionary *result = self.data[(long)indexPath.row];
        
        NSString *url = result[@"url"];
        
        [[GBLoading sharedLoading] loadResource:url withBackgroundProcessor:kGBLoadingProcessorDataToImage success:^(id object) {
            
            // update our image
            UIImage *viennaImage = object;
            self.ImageView.image = viennaImage;
            
            // change our ui state
            [self.ActivityIndicator stopAnimating];
        } failure:^(BOOL isCancelled) {
            
            // change our ui state
            [self.ActivityIndicator stopAnimating];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search
{
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
                                    initWithTitle:@"My First App" message:@"Hello, World!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [helloWorldAlert show];
    
    //NSString *escapedString = @"test";
    NSString *escapedString = self.SearchTerm.text;
    NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?q=%@&v=1.0&start=%d", escapedString, 1];
    
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
    }];
}

@end
