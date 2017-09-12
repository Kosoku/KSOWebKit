//
//  KSOWebKitViewController.m
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

#import "KSOWebKitViewController.h"
#import "KSOWebKitTitleView.h"
#import "KSOWebKitTheme.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

#import <WebKit/WebKit.h>

static CGFloat const kFixedItemWidth = 32.0;
static CGSize const kToolbarIconSize = {.width=25.0, .height=25.0};

@interface KSOWebKitViewController () <WKNavigationDelegate,WKUIDelegate>
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) WKWebView *webView;
@property (strong,nonatomic) UIBarButtonItem *activityIndicatorViewItem;
@property (strong,nonatomic) UIBarButtonItem *actionBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *backBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *forwardBarButtonItem;

@property (assign,nonatomic) BOOL hasPerformedSetup;
@end

@implementation KSOWebKitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    _theme = KSOWebKitTheme.defaultTheme;
    _toolbarOptions = KSOWebKitViewControllerToolbarOptionsAll;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    [self setWebView:[[WKWebView alloc] initWithFrame:CGRectZero configuration:config]];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.webView setNavigationDelegate:self];
    [self.webView setUIDelegate:self];
    [self.view addSubview:self.webView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    
    kstWeakify(self);
    [self setActionBarButtonItem:[UIBarButtonItem KDI_barButtonSystemItem:UIBarButtonSystemItemAction block:^(UIBarButtonItem *barButtonItem){
        kstStrongify(self);
        if (self.webView.URL.isFileURL) {
            UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:self.webView.URL];
            
            [controller presentOptionsMenuFromBarButtonItem:barButtonItem animated:YES];
        }
        else {
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.webView.URL] applicationActivities:nil];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
    }]];
    
    if (self.presentingViewController != nil) {
        void(^doneBlock)(UIBarButtonItem *) = ^(UIBarButtonItem *barButtonItem){
            kstStrongify(self);
            if ([self.delegate respondsToSelector:@selector(webKitViewControllerDidFinish:)]) {
                [self.delegate webKitViewControllerDidFinish:self];
            }
            else {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        };
        
        if (self.doneBarButtonItemTitle.length == 0) {
            [self setDoneBarButtonItem:[UIBarButtonItem KDI_barButtonSystemItem:UIBarButtonSystemItemDone block:doneBlock]];
        }
        else {
            [self setDoneBarButtonItem:[UIBarButtonItem KDI_barButtonItemWithTitle:self.doneBarButtonItemTitle style:UIBarButtonItemStyleDone block:doneBlock]];
        }
    }
    
    if (self.progressDisplayMode == KSOWebKitViewControllerProgressDisplayModeNavigationBar) {
        if (self.navigationController.KDI_progressNavigationBar == nil) {
            [self setActivityIndicatorViewItem:[[UIBarButtonItem alloc] initWithCustomView:({
                UIActivityIndicatorView *retval = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                [retval setHidesWhenStopped:YES];
                
                retval;
            })]];
            
            [self.webView KAG_addObserverForKeyPath:@kstKeypath(self.webView,loading) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
                kstStrongify(self);
                KSTDispatchMainAsync(^{
                    if (self.webView.isLoading) {
                        [(UIActivityIndicatorView *)self.activityIndicatorViewItem.customView startAnimating];
                    }
                    else {
                        [(UIActivityIndicatorView *)self.activityIndicatorViewItem.customView stopAnimating];
                    }
                });
            }];
            
            if (self.presentingViewController == nil) {
                [self.navigationItem setRightBarButtonItems:@[self.activityIndicatorViewItem]];
            }
            else {
                [self.navigationItem setLeftBarButtonItems:@[self.activityIndicatorViewItem]];
                [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]];
            }
        }
        else {
            [self.webView KAG_addObserverForKeyPaths:@[@kstKeypath(self.webView,loading),@kstKeypath(self.webView,estimatedProgress)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
                kstStrongify(self);
                KSTDispatchMainAsync(^{
                    if ([keyPath isEqualToString:@kstKeypath(self.webView,loading)]) {
                        [self.navigationController.KDI_progressNavigationBar setProgressHidden:!self.webView.isLoading animated:YES];
                    }
                    else if ([keyPath isEqualToString:@kstKeypath(self.webView,estimatedProgress)]) {
                        [self.navigationController.KDI_progressNavigationBar setProgress:self.webView.estimatedProgress animated:YES];
                    }
                });
            }];
            
            if (self.presentingViewController == nil) {
                [self.navigationItem setRightBarButtonItems:@[[UIBarButtonItem KDI_fixedSpaceBarButtonItemWithWidth:kFixedItemWidth]]];
            }
            else {
                [self.navigationItem setLeftBarButtonItems:@[[UIBarButtonItem KDI_fixedSpaceBarButtonItemWithWidth:kFixedItemWidth]]];
                [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]];
            }
        }
    }
    else if (self.progressDisplayMode == KSOWebKitViewControllerProgressDisplayModeSubview) {
        [self setProgressView:[[UIProgressView alloc] initWithFrame:CGRectZero]];
        [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.progressView setAlpha:0.0];
        [self.view addSubview:self.progressView];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.progressView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": self.progressView}]];
        
        [self.webView KAG_addObserverForKeyPaths:@[@kstKeypath(self.webView,loading),@kstKeypath(self.webView,estimatedProgress)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            kstStrongify(self);
            KSTDispatchMainAsync(^{
                if ([keyPath isEqualToString:@kstKeypath(self.webView,loading)]) {
                    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.progressView setAlpha:self.webView.isLoading ? 1.0 : 0.0];
                    } completion:nil];
                }
                else if ([keyPath isEqualToString:@kstKeypath(self.webView,estimatedProgress)]) {
                    [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
                }
            });
        }];
    }
    
    KSOWebKitTitleView *titleView = [[KSOWebKitTitleView alloc] initWithFrame:CGRectZero webView:self.webView viewController:self];
    
    [titleView sizeToFit];
    
    [self.navigationItem setTitleView:titleView];
    
    [self setBackBarButtonItem:[UIBarButtonItem KDI_barButtonItemWithImage:[[UIImage KSO_fontAwesomeImageWithString:@"\uf053" size:kToolbarIconSize] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain block:^(UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        [self.webView goBack];
    }]];
    [self setForwardBarButtonItem:[UIBarButtonItem KDI_barButtonItemWithImage:[[UIImage KSO_fontAwesomeImageWithString:@"\uf054" size:kToolbarIconSize] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain block:^(UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        [self.webView goForward];
    }]];
    
    [self.webView KAG_addObserverForKeyPaths:@[@kstKeypath(self.webView,canGoBack),@kstKeypath(self.webView,canGoForward)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.backBarButtonItem setEnabled:self.webView.canGoBack];
            [self.forwardBarButtonItem setEnabled:self.webView.canGoForward];
        });
    }];
    
    if (self.toolbarOptions != KSOWebKitViewControllerToolbarOptionsNone) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        [items addObject:[UIBarButtonItem KDI_flexibleSpaceBarButtonItem]];
        
        if (self.toolbarOptions & KSOWebKitViewControllerToolbarOptionsBack) {
            [items addObject:self.backBarButtonItem];
            [items addObject:[UIBarButtonItem KDI_flexibleSpaceBarButtonItem]];
        }
        if (self.toolbarOptions & KSOWebKitViewControllerToolbarOptionsForward) {
            [items addObject:self.forwardBarButtonItem];
            [items addObject:[UIBarButtonItem KDI_flexibleSpaceBarButtonItem]];
        }
        if (self.toolbarOptions & KSOWebKitViewControllerToolbarOptionsAction) {
            [items addObject:self.actionBarButtonItem];
            [items addObject:[UIBarButtonItem KDI_flexibleSpaceBarButtonItem]];
        }
        
        [self setToolbarItems:items];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:self.toolbarOptions == KSOWebKitViewControllerToolbarOptionsNone animated:animated];
    
    if (!self.hasPerformedSetup) {
        [self setHasPerformedSetup:YES];
        
        kstWeakify(self);
        [self KAG_addObserverForKeyPath:@kstKeypath(self,URLRequest) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, NSURLRequest * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            kstStrongify(self);
            KSTDispatchMainAsync(^{
                if (value == nil) {
                    [self.webView stopLoading];
                }
                else {
                    [self.webView loadRequest:value];
                }
            });
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
    [self.navigationController.KDI_progressNavigationBar setProgressHidden:YES animated:NO];
    [self.navigationController.KDI_progressNavigationBar setProgress:0.0];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self.delegate respondsToSelector:@selector(webKitViewController:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.delegate webKitViewController:self decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (navigationAction.targetFrame == nil) {
        [self.webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)setTheme:(KSOWebKitTheme *)theme {
    _theme = theme ?: KSOWebKitTheme.defaultTheme;
}

@dynamic URLString;
- (NSString *)URLString {
    return self.URLRequest.URL.absoluteString;
}
- (void)setURLString:(NSString *)URLString {
    [self setURLRequest:URLString.length == 0 ? nil : [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
}
@dynamic URL;
- (NSURL *)URL {
    return self.URLRequest.URL;
}
- (void)setURL:(NSURL *)URL {
    [self setURLRequest:URL == nil ? nil : [NSURLRequest requestWithURL:URL]];
}

@end
