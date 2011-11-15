//
//  SPTextAndHeaderViewContainer.m
//  Jot
//
//  Created by Philip Dow on 7/12/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//
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


//	Much of this code was pulled from online discussion groups in which users
//	were exactly trying to solve the problem of embedding additional views inside
//	a scroll view along with a text view. The code was incomplete and not functional.
//	A number of modifications were made to produce this working product.

//	The trick: having the correct autoresizing masks on the header view
//	and on the text view:
//	
//	The header should be horizontally resizable and sticky on the left, right and bottom.
//	The text view should be horizontally resizable and sticky on the left, right and top.
//	This has been established in IB but could be accomplished in code as well using
//	autoresizing masks or new Lion APIs.

#import "SPTextAndHeaderViewContainer.h"

@interface SPTextAndHeaderViewContainer()

- (void) embeddedTextViewFrameDidChange:(NSNotification* )aNotification;

@end

#pragma mark -

@implementation SPTextAndHeaderViewContainer

@synthesize scrollViewAncestor;
@synthesize headerView;
@synthesize textView;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) setTextView:(NSTextView *)aTextView 
{
	if ( textView != aTextView ) {
		textView = aTextView;
		
		if(textView != nil) {
			// track the frame of the text view 
			textViewFrame = [textView frame]; 
			isAutosizing = NO;
			// observe notifications of the text view resizing 
			[textView setPostsFrameChangedNotifications:YES]; 
			
			NSNotificationCenter* nc = [NSNotificationCenter defaultCenter]; 
			[nc addObserver:self selector:@selector(embeddedTextViewFrameDidChange:) 
					name:NSViewFrameDidChangeNotification object:textView]; 
		} 
	}
}

#pragma mark -


- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {
	
	// set and check autosizing flag to prevent infinite recursive loop
	if ( isAutosizing ) return;
	isAutosizing = YES;
	
	// resize 
	[super resizeSubviewsWithOldSize:oldBoundsSize]; 
	// and make the text view resize to fit
	[textView sizeToFit]; 
	
	isAutosizing = NO;
}

- (void) embeddedTextViewFrameDidChange:(NSNotification* )aNotification
{
	NSRect textFrame = [textView frame];
	
	// I do want to maintain a minimum height as well
	// trouble is if no backgrounds are being drawn, we need to clear out display artifacts
	// from the end of the text frame to the end of our height
	
	// Do not recall why the 20 and 10 offsets.
	
	CGFloat minHeight = [scrollViewAncestor contentSize].height;// - 20; // margin
	CGFloat desiredHeight = NSMaxY(textFrame);// + 10; // margin
	
	if ( desiredHeight < minHeight ) desiredHeight = minHeight;
	
	if ( desiredHeight < [scrollViewAncestor contentSize].height ) {
		
		// if text view does not draw background
		// if enclosing scroll view does not draw backround
		
		NSRect displayRect = NSMakeRect(0,NSMaxY(textFrame),NSWidth([self bounds]), 
				[scrollViewAncestor contentSize].height - NSMaxY(textFrame));
		
		NSRect actualRect = [self convertRect:displayRect toView:[scrollViewAncestor superview]];
		[[scrollViewAncestor superview] setNeedsDisplayInRect:actualRect];
	}
	
	NSRect myFrame = [self frame];
	myFrame.size.height = desiredHeight;
	myFrame.origin.y = 0;
	
	[self setFrame:myFrame];
}

- (BOOL) isFlipped {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	// In case the text view does not occupy the rest of the container view,
	// we receive the click and redirect it to the text view by making the text 
	// view the first responder and moving the insertion point to the end.
	
	// If the click takes place in the header area we ignore it.
	
	//NSInteger clickCount = [theEvent clickCount];
	NSPoint winPoint = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPointFromBase:winPoint];
	
	if ( [self mouse:viewPoint inRect:NSMakeRect(0,0,NSWidth([self bounds]),NSMinY([textView frame]))] )
		return;
		
	if ( [self.textView acceptsFirstResponder] ) { 
		[[self window] makeFirstResponder:self.textView];
		[self.textView setSelectedRange:NSMakeRange([[self.textView string] length],0)];
	}
}

-(void)dealloc { 
	if(textView != nil){ 
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter]; 
		[nc removeObserver:self name:NSViewFrameDidChangeNotification object:textView]; 
	}
	[super dealloc]; 
}

@end
