//
//  ShowImageViewController.m
//  GoogleSearch
//
//  Created by Harald Rohan on 11/22/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ImageView.image = self.Image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
