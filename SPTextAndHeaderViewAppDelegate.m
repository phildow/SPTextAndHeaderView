//
//  SPTextAndHeaderViewAppDelegate.m
//  SPTextAndHeaderView
//
//  Created by Philip Dow on 11/15/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

/*

	Redistribution and use in source and binary forms, with or without modification, 
	are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright notice, this list 
	of conditions and the following disclaimer.

	* Redistributions in binary form must reproduce the above copyright notice, this 
	list of conditions and the following disclaimer in the documentation and/or other 
	materials provided with the distribution.

	* Neither the name of the author nor the names of its contributors may be used to 
	endorse or promote products derived from this software without specific prior 
	written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY 
	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
	OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
	SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
	TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
	DAMAGE.

*/

/*
	For non-attribution licensing options refer to http://phildow.net/licensing/
*/

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
