//
//  PCOutLineView.m
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import "PCOutLineView.h"


@implementation PCOutLineView

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib
{
  [[[self enclosingScrollView] verticalScroller] setFloatValue:0.0];
  [[[self enclosingScrollView] contentView] scrollToPoint:NSMakePoint(0, 0)];  
  [self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
  
  [self registerForDraggedTypes:
      [NSArray arrayWithObjects:NSFilenamesPboardType,NSURLPboardType,kEntityPBoardType,nil]];  
}

@end
