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

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>

#import <WebKit/WebKit.h>

@interface KSOWebKitViewController ()
@property (strong,nonatomic) WKWebView *webView;
@property (strong,nonatomic) UIBarButtonItem *activityIndicatorViewItem;
@property (strong,nonatomic) UIBarButtonItem *actionBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *doneBarButtonItem;

@property (assign,nonatomic) BOOL hasPerformedSetup;
@end

@implementation KSOWebKitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    _showsActionBarButtonItem = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    [self setWebView:[[WKWebView alloc] initWithFrame:CGRectZero configuration:config]];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.webView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.webView}]];
    
    kstWeakify(self);
    if (self.showsActionBarButtonItem) {
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
    }
    
    if (self.presentingViewController != nil) {
        [self setDoneBarButtonItem:[UIBarButtonItem KDI_barButtonSystemItem:UIBarButtonSystemItemDone block:^(UIBarButtonItem * _Nonnull barButtonItem) {
            kstStrongify(self);
            if ([self.delegate respondsToSelector:@selector(webKitViewControllerDidFinish:)]) {
                [self.delegate webKitViewControllerDidFinish:self];
            }
            else {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }]];
    }
    
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
            if (self.showsActionBarButtonItem) {
                [self.navigationItem setRightBarButtonItems:@[self.actionBarButtonItem,self.activityIndicatorViewItem]];
            }
            else {
                [self.navigationItem setRightBarButtonItems:@[self.activityIndicatorViewItem]];
            }
        }
        else {
            if (self.showsActionBarButtonItem) {
                [self.navigationItem setLeftBarButtonItems:@[self.actionBarButtonItem]];
            }
            
            [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem,self.activityIndicatorViewItem]];
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
            if (self.showsActionBarButtonItem) {
                [self.navigationItem setRightBarButtonItems:@[self.actionBarButtonItem]];
            }
        }
        else {
            if (self.showsActionBarButtonItem) {
                [self.navigationItem setLeftBarButtonItems:@[self.actionBarButtonItem]];
            }
            
            [self.navigationItem setRightBarButtonItems:@[self.doneBarButtonItem]];
        }
    }
    
    KSOWebKitTitleView *titleView = [[KSOWebKitTitleView alloc] initWithFrame:CGRectZero webView:self.webView];
    
    [titleView sizeToFit];
    
    [self.navigationItem setTitleView:titleView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.hasPerformedSetup) {
        [self setHasPerformedSetup:YES];
        
        kstWeakify(self);
        [self KAG_addObserverForKeyPath:@kstKeypath(self,URL) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, NSURL * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            kstStrongify(self);
            KSTDispatchMainAsync(^{
                if (value == nil) {
                    [self.webView stopLoading];
                }
                else {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:value]];
                }
            });
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.KDI_progressNavigationBar setProgressHidden:YES animated:YES];
}

@end
