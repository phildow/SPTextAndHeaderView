//
//  SPTextAndHeaderViewContainer.h
//  Jot
//
//  Created by Philip Dow on 7/12/11.
//  Copyright 2011 Philip Dow / Sprouted. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SPTextAndHeaderViewContainer : NSView {
	
	NSScrollView* scrollViewAncestor;
	NSTextView* textView; 
	NSView *headerView;
	
	NSRect textViewFrame; 
	BOOL isAutosizing; 

}

@property (nonatomic,assign) IBOutlet NSScrollView* scrollViewAncestor;
@property (nonatomic,assign) IBOutlet NSTextView* textView;
@property (nonatomic,assign) IBOutlet NSView *headerView;

@end
