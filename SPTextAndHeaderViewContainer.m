//
//  SPTextAndHeaderViewContainer.m
//  Jot
//
//  Created by Philip Dow on 7/12/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//
//

//
//	The trick: having the correct autoresizing masks on the header view
//	and on the text view...
//	
//	The header should be horizontally resizable, be sticky on the left 
//	and right sides, and be sticky on the bottom
//
//	The text view should be horizontally resizable and sticky on 
//	the left and right sides as well as on the top
//

#import "SPTextAndHeaderViewContainer.h"


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


- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize { //(PHIL)
	
	// set and check autosizing flag to prevent infinite recursive loop
	
	if ( isAutosizing ) return;
	isAutosizing = YES;
	
	//DLog();
	
	// resize 
	[super resizeSubviewsWithOldSize:oldBoundsSize]; 
	// and make the text view resize to fit
	[textView sizeToFit]; 
	
	isAutosizing = NO;
}

- (void) embeddedTextViewFrameDidChange:(NSNotification* )aNotification
{
	NSRect textFrame = [textView frame];
	
	// 110 height, 125 text origin (refactor)
	
	// I do want to maintain a minimum height as well
	// trouble is if no backgrounds are being drawn, we need to clear out display artifacts
	// from the end of the text frame to the end of our height
	
	CGFloat minHeight = [scrollViewAncestor contentSize].height - 20; // margin
	
	CGFloat desiredHeight = NSMaxY(textFrame) + 10; // margin
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
	
	//DLog(@"text frame: %@, container frame: %@", NSStringFromRect(textFrame), NSStringFromRect(myFrame) );
	
	[self setFrame:myFrame];
}

- (BOOL) isFlipped {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	// probably we want to make the text view first responder and move
	// the insertion point to the end
	
	//NSInteger clickCount = [theEvent clickCount];
	NSPoint winPoint = [theEvent locationInWindow];
	NSPoint viewPoint = [self convertPointFromBase:winPoint];
	
	if ( [self mouse:viewPoint inRect:NSMakeRect(0,0,NSWidth([self bounds]),125)] ) // factor
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

#pragma mark -

@end
