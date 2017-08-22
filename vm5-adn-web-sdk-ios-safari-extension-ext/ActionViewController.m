//
//  ActionViewController.m
//  vm5-adn-web-sdk-ios-safari-extension-ext
//
//  Created by DaidoujiChen on 2017/8/22.
//  Copyright © 2017年 DaidoujiChen. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SelectPicker.h"
#import "DoneToolbar.h"

#define ADTypes @[ @"video-top", @"video-native", @"video-impressive", @"video-interstitial", @"video-interstitial-embedded", @"portraitvideo-interstitial", @"portraitvideo-interstitial-embedded" ]
#define PlistString (NSString *)kUTTypePropertyList

@interface ActionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *adTypeSelectTextField;
@property (weak, nonatomic) IBOutlet UITextField *divSelectTextField;

@end

@implementation ActionViewController

#pragma mark - Private Instance Method

- (IBAction)done {
    NSExtensionItem *extensionItem = [NSExtensionItem new];
    NSDictionary *item = @{ NSExtensionJavaScriptFinalizeArgumentKey: @{ @"adType": self.adTypeSelectTextField.text, @"selector": self.divSelectTextField.text } };
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:PlistString];
    extensionItem.attachments = @[ itemProvider ];
    [self.extensionContext completeRequestReturningItems:@[ extensionItem ] completionHandler:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block UITextField *textField = self.adTypeSelectTextField;
    textField.inputAccessoryView = [DoneToolbar on:textField];
    textField.inputView = [SelectPicker show:ADTypes on:textField];

    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:PlistString]) {
                
                __weak ActionViewController *weakSelf = self;
                [itemProvider loadItemForTypeIdentifier:PlistString options:0 completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
                    
                    if (item != nil) {
                        NSDictionary *resultDict = (NSDictionary *)item;
                        NSArray *divs = resultDict[NSExtensionJavaScriptPreprocessingResultsKey][@"divs"];
                        
                        textField = weakSelf.divSelectTextField;
                        textField.inputAccessoryView = [DoneToolbar on:textField];
                        textField.inputView = [SelectPicker show:divs on:textField];
                    }
                }];
            }
        }
    }
}

@end
