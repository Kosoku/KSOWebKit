//
//  UIViewController+KSOWebKitExtensions.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KSOWebKitExtensions)

/**
 Presents an instance of KSOWebKitViewController wrapped in a UINavigationController with the provided *URL*, using the provided *navigationBarClass*, optionally *animated* and invoking *completion* when the operation completes.
 
 @param URL The URL to display
 @param animated Whether to animate the presentation
 @param navigationBarClass The UINavigationBar class to use, if Nil, [KDIProgressNavigationBar class] is used
 @param completion The completion block to invoke when the operation completes
 */
- (void)KSO_presentWebKitViewControllerForURL:(NSURL *)URL animated:(BOOL)animated navigationBarClass:(nullable Class)navigationBarClass completion:(nullable dispatch_block_t)completion;

/**
 Pushes an instance of KSOWebKitViewController with the provided *URL*, optionally *animated* and invoking *
 completion* when the operation completes.
 
 @param URL The URL to display
 @param animated Whether to animate the push
 @param completion The completion block to invoke when the operation completes
 */
- (void)KSO_pushWebKitViewControllerForURL:(NSURL *)URL animated:(BOOL)animated completion:(nullable dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END
