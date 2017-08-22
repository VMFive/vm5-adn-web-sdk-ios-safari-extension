//
//  SelectPicker.m
//  vm5-adn-web-sdk-ios-safari-extension
//
//  Created by DaidoujiChen on 2017/8/22.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import "SelectPicker.h"

@interface SelectPicker ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) UITextField *target;

@end

@implementation SelectPicker

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.items.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.target.text isEqualToString:@""]) {
        self.target.text = self.items[row];
    }
    return self.items[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.target.text = self.items[row];
}

#pragma mark - Class Method

+ (instancetype)show:(NSArray<NSString *> *)items on:(UITextField *)target {
    return [[SelectPicker alloc] initWith:items target:target];
}

#pragma mark - Life Cycle

- (instancetype)initWith:(NSArray<NSString *> *)items target:(UITextField *)target {
    self = [super init];
    if (self) {
        self.items = items;
        self.target = target;
        if (self.items.count) {
            self.target.text = self.items[0];
        }
        self.dataSource = self;
        self.delegate = self;
        self.showsSelectionIndicator = YES;
        [self sizeToFit];
    }
    return self;
}

@end
