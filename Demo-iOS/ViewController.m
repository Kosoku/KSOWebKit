//
//  ViewController.m
//  Demo-iOS
//
//  Created by William Towe on 5/1/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewController.h"
#import "SubviewViewController.h"

#import <KSOWebKit/KSOWebKit.h>
#import <Ditko/Ditko.h>

@interface ViewController ()
@property (weak,nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Demo"];
    
    [self.textField setText:@"https://arstechnica.com/"];
}

- (IBAction)_presentAction:(id)sender {
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setURL:[NSURL URLWithString:self.textField.text]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[KDIProgressNavigationBar class] toolbarClass:Nil];
    
    [navigationController setViewControllers:@[viewController]];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)_pushAction:(id)sender {
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setDisplayTitle:@"Custom Title"];
    [viewController setURL:[NSURL URLWithString:self.textField.text]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)_presentWithoutProgressAction:(id)sender {
    [self KSO_presentWebKitViewControllerForURL:[NSURL URLWithString:self.textField.text] animated:YES navigationBarClass:[UINavigationBar class] completion:nil];
}
- (IBAction)_pushAsSubviewAction:(id)sender {
    [self.navigationController pushViewController:[[SubviewViewController alloc] init] animated:YES];
}
- (IBAction)_presentWithThemeAction:(id)sender {
    KSOWebKitTheme *theme = [KSOWebKitTheme.defaultTheme copy];
    
    [theme setTitleTextColor:KDIColorRandomRGB()];
    [theme setURLTextColor:KDIColorRandomRGB()];
    [theme setHasOnlySecureContentImageTintColor:KDIColorRandomRGB()];
    
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setTheme:theme];
    [viewController setURL:[NSURL URLWithString:self.textField.text]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[KDIProgressNavigationBar class] toolbarClass:Nil];
    
    [navigationController.navigationBar setBarTintColor:KDIColorRandomRGB()];
    [navigationController setViewControllers:@[viewController]];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
