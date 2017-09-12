//
//  KSOWebKitTitleView.m
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

#import "KSOWebKitTitleView.h"
#import "KSOWebKitViewController.h"
#import "KSOWebKitTheme.h"
#import "NSBundle+KSOWebKitPrivateExtensions.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

#import <WebKit/WebKit.h>

@interface KSOWebKitTitleView ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *URLLabel;
@property (strong,nonatomic) UIImageView *hasOnlySecureContentImageView;

@property (assign,nonatomic) BOOL hasDisplayTitle;

@property (weak,nonatomic) WKWebView *webView;
@property (weak,nonatomic) KSOWebKitViewController *viewController;
@end

@implementation KSOWebKitTitleView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), ceil(self.titleLabel.font.lineHeight))];
    
    if (self.hasOnlySecureContentImageView.superview == nil) {
        [self.URLLabel setFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds), ceil(self.URLLabel.font.lineHeight))];
    }
    else {
        CGFloat URLLabelWidth = [self.URLLabel sizeThatFits:CGSizeZero].width;
        CGFloat marginX = 4.0;
        
        if (CGRectGetWidth(self.bounds) - URLLabelWidth < self.hasOnlySecureContentImageView.image.size.width + marginX) {
            [self.URLLabel setFrame:CGRectMake(self.hasOnlySecureContentImageView.image.size.width + marginX, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds) - self.hasOnlySecureContentImageView.image.size.width - marginX, ceil(self.URLLabel.font.lineHeight))];
            [self.hasOnlySecureContentImageView setFrame:KSTCGRectCenterInRectVertically(CGRectMake(0, 0, self.hasOnlySecureContentImageView.image.size.width, self.hasOnlySecureContentImageView.image.size.height), self.URLLabel.frame)];
        }
        else {
            [self.URLLabel setFrame:KSTCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), URLLabelWidth, ceil(self.URLLabel.font.lineHeight)), self.bounds)];
            [self.hasOnlySecureContentImageView setFrame:KSTCGRectCenterInRectVertically(CGRectMake(CGRectGetMinX(self.URLLabel.frame) - marginX - self.hasOnlySecureContentImageView.image.size.width, 0, self.hasOnlySecureContentImageView.image.size.width, self.hasOnlySecureContentImageView.image.size.height), self.URLLabel.frame)];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, ceil(self.titleLabel.font.lineHeight) + MAX(self.hasOnlySecureContentImageView.image.topCapHeight, ceil(self.URLLabel.font.lineHeight)));
}

- (instancetype)initWithFrame:(CGRect)frame webView:(WKWebView *)webView viewController:(KSOWebKitViewController *)viewController; {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    _webView = webView;
    _viewController = viewController;
    
    NSString *placeholder = NSLocalizedStringWithDefaultValue(@"TITLE_VIEW_PLACEHOLDER", nil, [NSBundle KSO_webKitFrameworkBundle], @"Loading…", @"title view placeholder");
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setText:placeholder];
    [self addSubview:_titleLabel];
    
    _URLLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_URLLabel setTextAlignment:NSTextAlignmentCenter];
    [_URLLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [_URLLabel setText:placeholder];
    [self addSubview:_URLLabel];
    
    _hasOnlySecureContentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    kstWeakify(self);
    [_webView KAG_addObserverForKeyPaths:@[@kstKeypath(_webView,title),@kstKeypath(_webView,URL),@kstKeypath(_webView,hasOnlySecureContent)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self.webView,title)]) {
                if (!self.hasDisplayTitle) {
                    [self.titleLabel setText:self.webView.title.length > 0 ? self.webView.title : placeholder];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self.webView,URL)]) {
                [self.URLLabel setText:self.webView.URL.absoluteString.length > 0 ? self.webView.URL.absoluteString : placeholder];
                [self setNeedsLayout];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self.webView,hasOnlySecureContent)]) {
                if (self.webView.hasOnlySecureContent) {
                    if (self.hasOnlySecureContentImageView.superview == nil) {
                        [self addSubview:self.hasOnlySecureContentImageView];
                        [self setNeedsLayout];
                    }
                }
                else {
                    if (self.hasOnlySecureContentImageView.superview != nil) {
                        [self.hasOnlySecureContentImageView removeFromSuperview];
                        [self setNeedsLayout];
                    }
                }
            }
        });
    }];
    
    [_viewController KAG_addObserverForKeyPaths:@[@kstKeypath(_viewController,theme),@kstKeypath(_viewController,displayTitle)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self.viewController,theme)]) {
                [self.titleLabel setFont:self.viewController.theme.titleFont];
                [self.titleLabel setTextColor:self.viewController.theme.titleTextColor];
                
                [self.URLLabel setFont:self.viewController.theme.URLFont];
                [self.URLLabel setTextColor:self.viewController.theme.URLTextColor];
                
                [self.hasOnlySecureContentImageView setTintColor:self.viewController.theme.hasOnlySecureContentImageTintColor];
                [self.hasOnlySecureContentImageView setImage:[self.viewController.theme.hasOnlySecureContentImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                
                [self sizeToFit];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self.viewController,displayTitle)]) {
                if (self.viewController.displayTitle.length > 0) {
                    [self setHasDisplayTitle:YES];
                    [self.titleLabel setText:self.viewController.displayTitle];
                }
                else {
                    [self setHasDisplayTitle:NO];
                    [self.titleLabel setText:self.webView.title.length > 0 ? self.webView.title : placeholder];
                }
            }
        });
    }];
    
    return self;
}

@end
