//
//  SPTextAndHeaderViewAppDelegate.m
//  SPTextAndHeaderView
//
//  Created by Philip Dow on 11/15/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

#import "SPTextAndHeaderViewAppDelegate.h"
#import "SPTextAndHeaderViewContainer.h"

@interface SPTextAndHeaderViewAppDelegate()

- (void) prepareTextAndHeaderView;

@end

@implementation SPTextAndHeaderViewAppDelegate

@synthesize window;

@synthesize textView;
@synthesize headerView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	[self prepareTextAndHeaderView];
}

- (void) prepareTextAndHeaderView
{
	
	const CGFloat CHLargeNumberForText = 1.0e7;
	const CGFloat kExtendedNoteTextContainerInset = 46.0;
	[self.textView setTextContainerInset:NSMakeSize(kExtendedNoteTextContainerInset,5.0)];
	
	/*
	[self.textView setPostsFrameChangedNotifications:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
			selector:@selector(viewFrameDidChange:) 
			name:NSViewFrameDidChangeNotification 
			object:[self view]];
	*/
	
	
	NSTextContainer *oContainer = [self.textView textContainer];
	NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:
			NSMakeSize(CHLargeNumberForText, CHLargeNumberForText)] autorelease];
	
	
	NSRect headerClip = NSMakeRect(0, 25, NSWidth([self.textView bounds]), 110);
	//[textContainer setClippingRect:headerClip forKey:[NSNumber numberWithInteger:1]];
	
	
	[textContainer setHeightTracksTextView:NO];
	[textContainer setWidthTracksTextView:YES];
	
	[textContainer setLineFragmentPadding:[oContainer lineFragmentPadding]];
	[textContainer setContainerSize:[oContainer containerSize]];
	
	[self.textView replaceTextContainer:textContainer];
	
	
	[self.headerView setFrame:headerClip];
	//[self.textView addSubview:self.headerView];
	
	NSRect containerFrame = [self.textView frame];
	SPTextAndHeaderViewContainer *container = [[SPTextAndHeaderViewContainer alloc] 
			initWithFrame:containerFrame];
	
	[container setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	
	NSScrollView *scrollView = [textView enclosingScrollView];
	
	[textView retain];
	[textView removeFromSuperview];
	
	headerClip.origin.y = 0;
	[headerView setFrame:headerClip];
	[container addSubview:headerView];
	
	NSRect textFrame = [textView frame];
	textFrame.size.height = headerClip.origin.y;
	textFrame.origin.y = 125;
	[textView setFrame:textFrame];
	[container addSubview:textView];
	
	container.scrollViewAncestor = scrollView;
	container.textView = textView;
	
	// container.headerView = headerView;
	// This call screws everything up!
	
	//[container setFrame:containerFrame];
	[scrollView setDocumentView:container];
	
	[scrollView setFrame:[[self.window contentView] bounds]];
	[[self.window contentView] addSubview:scrollView];
}

@end
