//
//  DoneToolbar.m
//  vm5-adn-web-sdk-ios-safari-extension
//
//  Created by DaidoujiChen on 2017/8/22.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import "DoneToolbar.h"

@interface DoneToolbar ()

@property (nonatomic, weak) UIView *target;

@end

@implementation DoneToolbar

#pragma mark - Private Instance Method

- (void)doneAction {
    [self.target resignFirstResponder];
}

#pragma mark - Class Method

+ (instancetype)on:(UIView *)target {
    return [[DoneToolbar alloc] initWith:target];
}

#pragma mark - Life Cycle

- (instancetype)initWith:(UIView *)target {
    self = [super init];
    if (self) {
        self.target = target;
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
        [self setItems:@[ flexSpace, doneButton ] animated:NO];
        [self sizeToFit];
    }
    return self;
}

@end
