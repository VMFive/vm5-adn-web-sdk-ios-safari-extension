//
//  SelectPicker.h
//  vm5-adn-web-sdk-ios-safari-extension
//
//  Created by DaidoujiChen on 2017/8/22.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

+ (instancetype)show:(NSArray<NSString *> *)items on:(UITextField *)target;
- (instancetype)initWith:(NSArray<NSString *> *)items target:(UITextField *)target;

@end
