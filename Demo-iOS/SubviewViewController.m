//
//  SubviewViewController.m
//  KSOWebKit
//
//  Created by William Towe on 9/11/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SubviewViewController.h"

#import <KSOWebKit/KSOWebKit.h>

@interface SubviewViewController ()

@end

@implementation SubviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:@"Subview Button Title" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": button}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": button, @"top": self.topLayoutGuide}]];
    
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setProgressDisplayMode:KSOWebKitViewControllerProgressDisplayModeSubview];
    [viewController setToolbarOptions:KSOWebKitViewControllerToolbarOptionsNone];
    [viewController setURLString:@"http://www.cnn.com/"];
    
    [self addChildViewController:viewController];
    [viewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": viewController.view}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]|" options:0 metrics:nil views:@{@"view": viewController.view, @"subview": button}]];
}

@end
