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

@interface ActionViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *adTypeSelectTextField;
@property (weak, nonatomic) IBOutlet UITextField *divSelectTextField;
@property (weak, nonatomic) IBOutlet UIWebView *previewWebView;
@property (nonatomic, strong) NSString *prevDIV;

@end

@implementation ActionViewController

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!self.prevDIV) {
        self.prevDIV = self.divSelectTextField.text;
        NSString *javaScriptString = [NSString stringWithFormat:@"var element = document.querySelector(\"%@\"); \
                                      element.style.border = \"2px solid rgba(255, 0, 0, 1)\";", self.divSelectTextField.text];
        [self.previewWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
    }
}

#pragma mark - Private Instance Method

- (IBAction)done {
    NSExtensionItem *extensionItem = [NSExtensionItem new];
    NSDictionary *item = @{ NSExtensionJavaScriptFinalizeArgumentKey: @{ @"adType": self.adTypeSelectTextField.text, @"selector": self.divSelectTextField.text } };
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:item typeIdentifier:PlistString];
    extensionItem.attachments = @[ itemProvider ];
    [self.extensionContext completeRequestReturningItems:@[ extensionItem ] completionHandler:nil];
}

- (void)drawDIVEdge:(NSString *)target {
    if (!self.prevDIV) {
        return;
    }
    
    if ([self.prevDIV isEqualToString:target]) {
        return;
    }
    
    NSString *javaScriptString = [NSString stringWithFormat:@"var elements = document.getElementsByTagName(\"div\"); \
                                  for (var i = 0; i < elements.length; i++) { \
                                    elements[i].style.border = \"\"; \
                                  } \
                                  var newElement = document.querySelector(\"%@\"); \
                                  newElement.style.border = \"2px solid rgba(255, 0, 0, 1)\";", target];
    [self.previewWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
    self.prevDIV = target;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak ActionViewController *weakSelf = self;
    
    __block UITextField *textField = self.adTypeSelectTextField;
    textField.inputAccessoryView = [DoneToolbar on:textField];
    textField.inputView = [SelectPicker show:ADTypes onChange: ^(NSString *text) {
        weakSelf.adTypeSelectTextField.text = text;
    }];

    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:PlistString]) {
                [itemProvider loadItemForTypeIdentifier:PlistString options:0 completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
                    
                    if (item != nil) {
                        NSDictionary *resultDict = (NSDictionary *)item;
                        NSArray *divs = resultDict[NSExtensionJavaScriptPreprocessingResultsKey][@"divs"];
                        
                        textField = weakSelf.divSelectTextField;
                        textField.inputAccessoryView = [DoneToolbar on:textField];
                        textField.inputView = [SelectPicker show:divs onChange: ^(NSString *text) {
                            [weakSelf drawDIVEdge:text];
                            weakSelf.divSelectTextField.text = text;
                        }];
                        
                        weakSelf.previewWebView.delegate = weakSelf;
                        [weakSelf.previewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resultDict[NSExtensionJavaScriptPreprocessingResultsKey][@"url"]]]];
                    }
                }];
            }
        }
    }
}

@end
