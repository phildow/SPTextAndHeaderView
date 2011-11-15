//
//  SPTextAndHeaderViewAppDelegate.h
//  SPTextAndHeaderView
//
//  Created by Philip Dow on 11/15/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPTextAndHeaderViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	NSTextView *textView;
	NSView *headerView;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextView *textView;
@property (assign) IBOutlet NSView *headerView;

@end
