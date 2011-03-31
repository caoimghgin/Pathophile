//
//  AppController.m
//  HUDWindow
//
//  Created by Matt Gemmell on 11/03/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import "AppController.h"

@implementation AppController

-(id)init {
    if (self = [super init]) {
		filePathArray = [[NSArray alloc] init];
		pasteBoard = [NSPasteboard generalPasteboard];
		delayToFadeWindow = 2.5;
		[pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    }
    return self;
}

- (void)dealloc {
	NSLog( @"dealloc" );
	[filePathArray release];
	[pasteBoard release];
	[timer release];
	[textField release];
	[super dealloc];
}

// Getters...
-(NSArray *)filePathArray{
	return (filePathArray);
}

// Setters...
-(void) setFilePathArray:(NSArray *)input {
    [input retain];
    [filePathArray release];
    filePathArray = input;
}

// Other...
- (NSMutableString *) filePathArrayAsReturnDelimString {
	
	NSMutableString* mutableString = [[NSMutableString alloc] init];
	
	for (int i = 0; i < [filePathArray count]; i++) {
		id path = [filePathArray objectAtIndex:i];
		[mutableString appendString:path];
		if ([filePathArray count] != i+1) {
			[mutableString appendString:@"\r"];
		}
	}
	
	return mutableString;
}

- (BOOL)application:(NSApplication *)sender openFiles:(NSArray *)pathArray {	
	[self setFilePathArray:pathArray];
	return YES;
}



- (void)awakeFromNib {
	// Couldn't use awakeFromNib because it's called before '- (BOOL)application:(NSApplication *)sender openFiles:(NSArray *)pathArray {' method.
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		
	//[self setDockStatus];
	
		if ([filePathArray count] != 0) {
			
			self.HUDWindowShowItemsCopiedToClipboard;
			[window makeKeyAndOrderFront:self];				//make window visible!
			[pasteBoard setString:[ self filePathArrayAsReturnDelimString ] forType:NSStringPboardType];
			timer = [[NSTimer scheduledTimerWithTimeInterval:delayToFadeWindow target:self selector:@selector(fadeWindowAndQuit)  userInfo:nil repeats:NO]retain];

		} else {
			
			self.HUDWindowWelcome;
			[window makeKeyAndOrderFront:self];				//make window visible!
		}
	
}
	

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
    return YES;
}


- (BOOL)windowShouldClose:(id)sender {
    return YES;
}

- (void)fadeWindowAndQuit {

	//float alpha = 1.0;
	//[window setAlphaValue:alpha];
	[window makeKeyAndOrderFront:self];
	for (int x = 0; x < 10; x++) {
		[window setAlphaValue:[window alphaValue] - 0.1];
		[NSThread sleepForTimeInterval:0.020];
	}
	
	exit(0);
}

- (void)HUDWindowShowItemsCopiedToClipboard {
	
	/*
	 Will need to test for size of monitor
	 in case string is very long...
	 */
	
	textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20,20,20,20)];  // Create textField, fill with string, resize.
    
	[textField setStringValue:[self filePathArrayAsReturnDelimString]];
	//[textField setStringValue:@"02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdfANIT YA PROUD.pdfANIT YA PROUD.pdfANIT YA PROUD???\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf\r02_Server_Raid:02_Server_WIP:B:BOS:BOS74734:RIP_74734:SoundDock_Portable.038_HR.pdf"];
	[textField setEditable:NO];						// Doesn't need to be editable
    [textField setTextColor:[NSColor whiteColor]];	// 
    [textField setDrawsBackground:NO];				//
    [textField setBordered:NO];						//
	[textField setAlignment:NSLeftTextAlignment];	//
   	[textField sizeToFit];							//resize textField to fit all text contents. We'll draw the window around the resized textField.
    
	// Draw the window around the resized textField.
	window = [[HUDWindow alloc] initWithContentRect:NSMakeRect(20,20, textField.frame.size.width + 40, textField.frame.size.height + 50)  styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	[[window contentView] addSubview:textField];	// Adds a view to the receiver’s subviews so it’s displayed above its siblings.
	[window center];								// Window is centered on screen.
    [window setTitle:@"Copied the following paths to clipboard..."];				// Set title.	
	[window setDelegate:self];						// Make us window's delegate, so we receive windowShouldClose:.
	
	/*
	 NSLog(@"frameRect = %@", NSStringFromRect([textField frame]));
	 NSLog (@"thewidth (in pixels):  %f", textField.frame.size.width);
	 NSLog (@"theheight (in pixels):  %f", textField.frame.size.height);
	 */
}

- (void)HUDWindowWelcome {
	
	NSSize windowSize = NSMakeSize(300, 170);
	
	textField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 10,  windowSize.width-40, windowSize.height - [NSMenuView menuBarHeight] -18)];
	
	[textField setStringValue:@"To use Pathophile, simply drag files from the Finder onto the Pathophile application icon. The paths will be copied to the clipboard so you can easily email or print the exact path of the file.\r\rQuit the program and then give it a try!"];
	[textField setEditable:NO];						// Doesn't need to be editable
    [textField setTextColor:[NSColor whiteColor]];	// 
    [textField setDrawsBackground:NO];				//
    [textField setBordered:NO];						//
	[textField setAlignment:NSLeftTextAlignment];	//
	[[textField cell] setLineBreakMode:NSLineBreakByWordWrapping];
	[[textField cell] setWraps:YES];
	
	window = [[HUDWindow alloc] initWithContentRect:NSMakeRect(0,0, windowSize.width, windowSize.height)  styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	[[window contentView] addSubview:textField];
	[window center];
	[window setTitle:@"Pathophile"];
	[window setDelegate:self];
	[window addCloseWidget];
	
	/*
	 NSLog (@"menuBarHeight (in pixels):  %f", [NSMenuView menuBarHeight]);
	 */
}
/*
- (void) setDockStatus {
	// this should be called from the application delegate's applicationDidFinishLaunching
	// method or from some controller object's awakeFromNib method
	// Neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a>
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"doShowInDock"]) {
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		// enable menu bar
		SetSystemUIMode(kUIModeNormal, 0);
		// switch to Dock.app
		[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil];
		// switch back
		[[NSApplication sharedApplication] activateIgnoringOtherApps:TRUE];
	}
}
*/
@end
