//
//  KSOWebKitTheme.m
//  KSOWebKit
//
//  Created by William Towe on 5/2/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOWebKitTheme.h"

#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

#import <objc/runtime.h>

@interface KSOWebKitTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleTextColor;
+ (UIFont *)_defaultURLFont;
+ (UIColor *)_defaultURLTextColor;
+ (UIImage *)_defaultHasOnlySecureContentImage;
+ (UIColor *)_defaultHasOnlySecureContentImageTintColor;
@end

@implementation KSOWebKitTheme

- (id)copyWithZone:(NSZone *)zone {
    KSOWebKitTheme *retval = [[[self class] alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_titleFont = _titleFont;
    retval->_titleTextColor = _titleTextColor;
    
    retval->_URLFont = _URLFont;
    retval->_URLTextColor = _URLTextColor;
    
    retval->_hasOnlySecureContentImage = _hasOnlySecureContentImage;
    retval->_hasOnlySecureContentImageTintColor = _hasOnlySecureContentImageTintColor;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(identifier != nil);
    
    _identifier = [identifier copy];
    
    _titleFont = [self.class _defaultTitleFont];
    _titleTextColor = [self.class _defaultTitleTextColor];
    
    _URLFont = [self.class _defaultURLFont];
    _URLTextColor = [self.class _defaultURLTextColor];
    
    _hasOnlySecureContentImage = [self.class _defaultHasOnlySecureContentImage];
    _hasOnlySecureContentImageTintColor = [self.class _defaultHasOnlySecureContentImageTintColor];
    
    return self;
}

static void const *kDefaultThemeKey = &kDefaultThemeKey;
+ (KSOWebKitTheme *)defaultTheme {
    return objc_getAssociatedObject(self, kDefaultThemeKey) ?: [[KSOWebKitTheme alloc] initWithIdentifier:@"com.kosoku.ksowebkit.theme.default"];
}
+ (void)setDefaultTheme:(KSOWebKitTheme *)defaultTheme {
    objc_setAssociatedObject(self, kDefaultThemeKey, defaultTheme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
}
- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor ?: [self.class _defaultTitleTextColor];
}
- (void)setURLFont:(UIFont *)URLFont {
    _URLFont = URLFont ?: [self.class _defaultURLFont];
}
- (void)setURLTextColor:(UIColor *)URLTextColor {
    _URLTextColor = URLTextColor ?: [self.class _defaultURLTextColor];
}
- (void)setHasOnlySecureContentImage:(UIImage *)hasOnlySecureContentImage {
    _hasOnlySecureContentImage = hasOnlySecureContentImage ?: [self.class _defaultHasOnlySecureContentImage];
}
- (void)setHasOnlySecureContentImageTintColor:(UIColor *)hasOnlySecureContentImageTintColor {
    _hasOnlySecureContentImageTintColor = hasOnlySecureContentImageTintColor ?: [self.class _defaultHasOnlySecureContentImageTintColor];
}

+ (UIFont *)_defaultTitleFont; {
    return [UIFont boldSystemFontOfSize:17.0];
}
+ (UIColor *)_defaultTitleTextColor; {
    return UIColor.blackColor;
}
+ (UIFont *)_defaultURLFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultURLTextColor; {
    return UIColor.darkGrayColor;
}
+ (UIImage *)_defaultHasOnlySecureContentImage; {
    // fa-lock
    return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf023" size:CGSizeMake(16, 16)];
}
+ (UIColor *)_defaultHasOnlySecureContentImageTintColor; {
    return UIColor.darkGrayColor;
}

@end
