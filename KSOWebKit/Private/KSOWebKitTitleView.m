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

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

#import <WebKit/WebKit.h>

@interface KSOWebKitTitleView ()
@property (strong,nonatomic) UILabel *titleLabel;

@property (weak,nonatomic) WKWebView *webView;
@end

@implementation KSOWebKitTitleView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, ceil(self.titleLabel.font.lineHeight));
}

- (instancetype)initWithFrame:(CGRect)frame webView:(WKWebView *)webView; {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _webView = webView;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    NSString *placeholder = NSLocalizedStringWithDefaultValue(@"TITLE_VIEW_PLACEHOLDER", nil, [NSBundle mainBundle], @"Loading…", @"title view placeholder");
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UINavigationBar appearance].titleTextAttributes[NSFontAttributeName] ?: [UIFont boldSystemFontOfSize:17.0]];
    [_titleLabel setText:placeholder];
    [self addSubview:_titleLabel];
    
    kstWeakify(self);
    [_webView KAG_addObserverForKeyPath:@kstKeypath(_webView,title) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.titleLabel setText:self.webView.title.length > 0 ? self.webView.title : placeholder];
            
            [self sizeToFit];
        });
    }];
    
    return self;
}

@end
