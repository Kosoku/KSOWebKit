//
//  KSOWebKitViewController.h
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
#import <WebKit/WKNavigationAction.h>
#import <WebKit/WKNavigationDelegate.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSOWebKitViewControllerProgressDisplayMode) {
    KSOWebKitViewControllerProgressDisplayModeNavigationBar,
    KSOWebKitViewControllerProgressDisplayModeSubview
};

/**
 Options mask describing possible values for toolbar options.
 */
typedef NS_OPTIONS(NSUInteger, KSOWebKitViewControllerToolbarOptions) {
    /**
     No toolbar items are displayed and the toolbar will be hidden.
     */
    KSOWebKitViewControllerToolbarOptionsNone = 0,
    /**
     The back item will be displayed. Similar to Safari.
     */
    KSOWebKitViewControllerToolbarOptionsBack = 1 << 0,
    /**
     The forward item will be displayed. Similar to Safari.
     */
    KSOWebKitViewControllerToolbarOptionsForward = 1 << 1,
    /**
     The action item will be displayed. This is the standard system action item.
     */
    KSOWebKitViewControllerToolbarOptionsAction = 1 << 2,
    /**
     All items will be displayed. This is the default.
     */
    KSOWebKitViewControllerToolbarOptionsAll = KSOWebKitViewControllerToolbarOptionsBack| KSOWebKitViewControllerToolbarOptionsForward|KSOWebKitViewControllerToolbarOptionsAction
};

@class KSOWebKitTheme;
@protocol KSOWebKitViewControllerDelegate;

/**
 KSOWebKitViewController wraps an instance of WKWebView to display web content.
 */
@interface KSOWebKitViewController : UIViewController

/**
 Set and get the delegate of the receiver.
 
 @see KSOWebKitViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<KSOWebKitViewControllerDelegate> delegate;

/**
 Set and get the theme of the receiver.
 
 The default is KSOWebKitTheme.defaultTheme.
 */
@property (strong,nonatomic,null_resettable) KSOWebKitTheme *theme;

/**
 Set and get the display title of the receiver. If non-nil, it will displayed as the title of the receiver's navigationItem, otherwise the title will track the title property of the managed WKWebView.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *displayTitle;
/**
 Set and get the done bar button item title, which is displayed in the navigation bar when the receiver is presented modally inside a UINavigationController. If nil, the standard done bar button item is displayed instead.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *doneBarButtonItemTitle;
@property (assign,nonatomic) KSOWebKitViewControllerProgressDisplayMode progressDisplayMode;
/**
 Set and get the toolbar options of the receiver. This value controls whether to toolbar is shown and what items are displayed.
 
 The default is KSOWebKitViewControllerToolbarOptionsAll.
 
 @see KSOWebKitViewControllerToolbarOptions
 */
@property (assign,nonatomic) KSOWebKitViewControllerToolbarOptions toolbarOptions;

/**
 Set and get the URL string of the receiver. This funnels through setURLRequest:.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSString *URLString;
/**
 Set and get the URL of the receiver. This funnels through setURLRequest:.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSURL *URL;
/**
 Set and get the URL request of the receiver. Setting this to nil causes the receiver to stop loading the current URL request. Setting it to non-nil causes the receiver to begin loading the request.
 */
@property (copy,nonatomic,nullable) NSURLRequest *URLRequest;

@end

/**
 Protocol describing the delegate of KSOWebKitViewController instances.
 */
@protocol KSOWebKitViewControllerDelegate <NSObject>
@optional
/**
 Called to determine whether to procede with the provided navigation action. The delegate must invoke the provided *decisionHandler* with one of the WKNavigationActionPolicy constants once a decision has been made.
 
 @param viewController The sender of the message
 @param navigationAction The navigation action to evaluate
 @param decisionHandler The block to invoke when a decision has been made
 */
- (void)webKitViewController:(KSOWebKitViewController *)viewController decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
/**
 Called when the done bar button item is tapped. If implemented, the delegate is reqsponsible for dismissing the *viewController*.
 
 @param viewController The sender of the message
 */
- (void)webKitViewControllerDidFinish:(KSOWebKitViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
