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
	// SPTextAndHeaderViewContainer manages the geometry of the enclossing scroll view
	// when the text view changes due to user interaction (typing, resizing, etc),
	// but the setup and view hiearchy must be established here.
	
	
	// Add a margin to the text view; the vertical should correspond to the contents
	// of the header view
	
	const CGFloat kVerticalContainerInset = 5.0; // left and right indentation
	const CGFloat kHorizontalContainerInset = 46.0; // top and bottom indentation
	const CGFloat kVerticalTextPadding = 15.0; // padding between header and text view
	
	[self.textView setTextContainerInset:NSMakeSize(kHorizontalContainerInset,
			kVerticalContainerInset)];
	
	// Set up view geometry and heierarchy. The text view initially occupies the entire 
	// scroll view as its document view. We will be replacing the text view with our custom 
	// text-and-container view, which becomes the scroll's document view. The text view
	// and header view are then added to the container view as its subviews:
	
	// Scroll View -> Document View / SPTextAndHeaderView
	//	
	//		[											]
	//		[ header view								]
	//		[											]
	//		[ text view									]
	//		[											]
	//
	
	NSRect containerFrame = [self.textView frame];
	NSRect headerFrame = [self.headerView frame];
	NSRect textFrame = [self.textView frame];
	
	// adjust header frame for new location in containing view
	headerFrame = NSMakeRect(0, 0, NSWidth(textFrame), NSHeight(headerFrame));
	
	// adjust text view frame for new location in containing view
	textFrame.origin.y = NSHeight(headerFrame) + kVerticalTextPadding;
	textFrame.size.height = textFrame.size.height - textFrame.origin.y;
	
	SPTextAndHeaderViewContainer *container = [[SPTextAndHeaderViewContainer alloc] 
			initWithFrame:containerFrame];
	
	[container setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	
	// grab the scroll view before removing the text view
	NSScrollView *scrollView = [textView enclosingScrollView];
	
	[textView retain]; // retain before removing from superview
	[textView removeFromSuperview];
	
	// set frames and add text and header views to containing views
	
	[textView setFrame:textFrame];
	[container addSubview:textView];
	
	[headerView setFrame:headerFrame];
	[container addSubview:headerView];
	
	container.scrollViewAncestor = scrollView;
	container.textView = textView;
	
	// container.headerView = headerView;
	// This call screws it up, unneeded by the container view anyway.
	// Unsure why, as the headerView isn't referred to anywhere in the container
	
	[scrollView setDocumentView:container];
	
	// set up is complete, just adding the scroll view to the window's content view
	[scrollView setFrame:[[self.window contentView] bounds]];
	[[self.window contentView] addSubview:scrollView];
	
	// release after returning to new superview
	[container release];
	[textView release];
}

@end
