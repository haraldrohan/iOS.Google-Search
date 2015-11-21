//
//  GoogleSearchViewController.m
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import "GoogleSearchViewController.h"
#import "ImageHandler.h"

@interface GoogleSearchViewController ()

@end

@implementation GoogleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.TableView registerClass:UITableViewCell.class  forCellReuseIdentifier:@"SimpleTableItem"];
    
    self.data = [[NSArray alloc] init];
    self.data = [NSArray arrayWithObjects:@"Milk", @"Honey", @"Bread", @"Toast", @"Butter", nil];
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
    cell.textLabel.text = self.data[(long)indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMessage
{
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
                                    initWithTitle:@"My First App" message:@"Hello, World!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [helloWorldAlert show];
    
    NSString *escapedString = @"test";
    NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?q=%@&v=1.0&start=%ld", escapedString, 1];
    
    
    [ImageHandler getImagesWithUrlString:urlString completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
//            [self clear];
        } else {
            NSNumber *responseStatus = responseObject[@"responseStatus"];
            if (responseStatus.integerValue == 200) {
                NSDictionary *responseData = responseObject[@"responseData"];
                NSArray * values = [responseData allValues];
                NSArray * values2 = values[0];
                NSDictionary * values3 = values2[0];
                NSArray * values4 = [values3 allValues];
                self.data = [values3 allValues];
                //self.data = [self.data arrayByAddingObjectsFromArray:responseData[@"results"]];
                [self.TableView reloadData];
            }
            else {
                NSLog(@"Error: %@ (%@)", responseObject[@"responseDetails"], responseStatus);
            }
        }
    }];
    
    

}

@end
