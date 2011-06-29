//
//  PCTreeController.m
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import "PCTreeController.h"

@implementation PCTreeController

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

- (void)insertObject:(PCEntity*)object atArrangedObjectIndexPath:(NSIndexPath *)indexPath
{
  [super insertObject:object atArrangedObjectIndexPath:indexPath];
}

- (void)insertChild:(PCEntity*)childnode
{
  PCEntity* e = [[self selectedObjects] objectAtIndex:0];
  e.children = [e.children setByAddingObject:childnode];
}

- (void)reIndexed;
{
  NSMutableArray* nodes = [[NSMutableArray alloc] init];
  
  for (NSTreeNode* node in [[self arrangedObjects] childNodes]) 
  {
    [nodes addObject:node];
    if ([[node mutableChildNodes] count] > 0)
    {
      [nodes addObjectsFromArray:[self descendants:node]];
    }
  }
    
  NSUInteger index = 0;  
  for(index = 0; index < [nodes count]; ++index)
  {
    PCEntity* e = [[nodes objectAtIndex:index] representedObject];
    e.index = [NSNumber numberWithLong:index];
  }
  
  [nodes release];
}

- (NSArray *)descendants:(NSTreeNode*)node
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSTreeNode *child in [node childNodes]) 
  {
		[array addObject:child];
		if (![child isLeaf])
    {
			[array addObjectsFromArray:[self descendants:child]];
    }
	}
	return [[array copy] autorelease];
}


@end
