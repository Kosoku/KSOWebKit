//
//  KSOWebKitTheme.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSOWebKitTheme controls the appearance of a KSOWebKitViewController instance.
 */
@interface KSOWebKitTheme : NSObject <NSCopying>

/**
 Set and get the default theme.
 
 The default value has values equal to the default properties below.
 */
@property (class,strong,nonatomic,null_resettable) KSOWebKitTheme *defaultTheme;

/**
 Get the theme identifier.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Set and get the font used for the title.
 
 The default is [UIFont boldSystemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *titleFont;
/**
 Set and get the text color used for the title.
 
 The default is UIColor.blackColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *titleTextColor;

/**
 Set and get the font used for the URL.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *URLFont;
/**
 Set and get the text color used for the URL.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *URLTextColor;

/**
 Set and get the image displayed when the receiver is displaying only secure content.
 
 The default is [UIImage KSO_fontAwesomeImageWithString:@"\uf023" size:CGSizeMake(16, 16)].
 */
@property (strong,nonatomic,null_resettable) UIImage *hasOnlySecureContentImage;
/**
 Set and get the color used to tint the hasOnlySecureContentImage.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *hasOnlySecureContentImageTintColor;

/**
 Creates and returns an instance of the receiver with the provided *identifier*.
 
 @param identifier The theme identifier
 @return The initialized instance
 @exception NSException Thrown if *identifier* is nil
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
