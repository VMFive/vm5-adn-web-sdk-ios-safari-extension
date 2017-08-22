//
//  ViewController.m
//  vm5-adn-web-sdk-ios-safari-extension
//
//  Created by DaidoujiChen on 2017/8/22.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"=w=" message:@"我只是為了 Safari Extension 存在" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好8..." style:UIAlertActionStyleCancel handler: ^(UIAlertAction *action) {
        exit(0);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
