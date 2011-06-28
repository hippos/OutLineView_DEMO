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
  /** TODO ***/
  /* set stored index */
  [super insertObject:object atArrangedObjectIndexPath:indexPath];
}

- (void)insertChild:(PCEntity*)childnode
{
  /** TODO ***/
  /* set stored index */
  PCEntity* e = [[self selectedObjects] objectAtIndex:0];
  e.children = [e.children setByAddingObject:childnode];
}

@end
