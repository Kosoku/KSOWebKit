//
//  UIViewController+KSOWebKitExtensions.m
//  KSOWebKit
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

#import "UIViewController+KSOWebKitExtensions.h"
#import "KSOWebKitViewController.h"

#import <Ditko/Ditko.h>

@implementation UIViewController (KSOWebKitExtensions)

- (void)KSO_presentWebKitViewControllerForURL:(NSURL *)URL animated:(BOOL)animated navigationBarClass:(Class)navigationBarClass completion:(dispatch_block_t)completion {
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setURL:URL];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:navigationBarClass ?: [KDIProgressNavigationBar class] toolbarClass:Nil];
    
    [navigationController setViewControllers:@[viewController]];
    
    [self presentViewController:navigationController animated:animated completion:completion];
}
- (void)KSO_pushWebKitViewControllerForURL:(NSURL *)URL animated:(BOOL)animated completion:(dispatch_block_t)completion; {
    KSOWebKitViewController *viewController = [[KSOWebKitViewController alloc] init];
    
    [viewController setURL:URL];
    
    [self.navigationController KDI_pushViewController:viewController animated:animated completion:completion];
}

@end
