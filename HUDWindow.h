//
//  HUDWindow.h
//  HUDWindow
//
//  Created by Matt Gemmell on 12/02/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HUDWindow : NSPanel {
    BOOL forceDisplay;
}

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(unsigned int)styleMask 
				  backing:(NSBackingStoreType)bufferingType 
					defer:(BOOL)flag;

- (id)initWithContentRectAndContents:(NSRect)contentRect 
						   styleMask:(unsigned int)styleMask 
							 backing:(NSBackingStoreType)bufferingType 
							   defer:(BOOL)flag 
					 withCloseWidget:(BOOL)closeWidget
						withTitle:(NSString *)title;

- (NSColor *)sizedHUDBackground;
- (void)addCloseWidget;

@end
