//
//  FontManager.m
//  FontLabel
//
//  Created by Kevin Ballard on 5/5/09.
//  Copyright © 2009 Zynga Game Networks
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FontManager.h"

static FontManager *sharedFontManager = nil;

@implementation FontManager
+ (id)sharedManager {
	@synchronized(self) {
		if (sharedFontManager == nil) {
			sharedFontManager = [[self alloc] init];
		}
	}
	return sharedFontManager;
}

- (id)init {
	if (self = [super init]) {
		fonts = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}
	return self;
}

- (BOOL)loadFont:(NSString *)filename {
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"ttf"];
	if (fontPath == nil) {
		fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	}
	if (fontPath == nil) return NO;
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath fileSystemRepresentation]);
	if (fontDataProvider == NULL) return NO;
	CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider); 
	CGDataProviderRelease(fontDataProvider); 
	if (newFont == NULL) return NO;
	
	CFDictionarySetValue(fonts, filename, newFont);
	CGFontRelease(newFont);
	return YES;
}

- (CGFontRef)fontWithName:(NSString *)filename {
	CGFontRef font = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	if (font == NULL && [self loadFont:filename]) {
		font = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	}
	return font;
}

- (void)dealloc {
	CFRelease(fonts);
	[super dealloc];
}
@end
