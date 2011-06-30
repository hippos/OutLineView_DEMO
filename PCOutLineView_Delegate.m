

//
//  OutLineView_DemoAppDelegate.h
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import "OutLineView_DemoAppDelegate.h"

@implementation OutLineView_DemoAppDelegate(PCOutLineView_Delegate)

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
  return NSDragOperationEvery;
}

- (BOOL)outlineView:(NSOutlineView *)ov 
         writeItems:(NSArray *)items 
       toPasteboard:(NSPasteboard *)pboard
{
  [pboard declareTypes:[NSArray arrayWithObjects:kEntityPBoardType, nil] owner:self];
  self.dragNodesArray = items;  
  return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov 
                  validateDrop:(id<NSDraggingInfo> )info 
                  proposedItem:(id)item
            proposedChildIndex:(NSInteger)index
{
  PCEntity* e = [item representedObject];
  if (e.isGroup == [NSNumber numberWithBool:NO])
  {// 子ノードにはドロップ不可
    return NSDragOperationNone;
  }
  return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)ov
         acceptDrop:(id<NSDraggingInfo> )info 
               item:(id)targetItem
         childIndex:(NSInteger)index
{
  BOOL result = NO;
  
  NSIndexPath *indexPath;
  
  if (index == -1)
  {
    if (targetItem)
    {// グループノードにドロップ
      indexPath = [[targetItem indexPath] indexPathByAddingIndex:0];
    }
    else
    {// Viewに対してドロップ
      indexPath = [NSIndexPath indexPathWithIndex:[[[treecontroller arrangedObjects] childNodes] count]];
    }
  }
  else
  {
    if (targetItem)
    {// 特定の位置にドロップ
      NSUInteger len = [[targetItem indexPath] length];
      NSUInteger *indexes = malloc(sizeof(NSUInteger)*len+1);
      [[targetItem indexPath] getIndexes:indexes];
      *(indexes+len) = index;
      indexPath = [NSIndexPath indexPathWithIndexes:indexes length:len+1];
      free(indexes);
    }
    else
    {//　ルートレベルにドロップ
      indexPath = [NSIndexPath indexPathWithIndex:index];
    }    
  }
  
  NSPasteboard *pboard = [info draggingPasteboard];
  
  if ([pboard availableTypeFromArray:[NSArray arrayWithObject:kEntityPBoardType]])
  {
    [self handleInternalDrops:pboard withIndexPath:indexPath];
    result = YES;
  }
  else if ([pboard availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]])
  {
    [self handleFileBasedDrops:pboard withIndexPath:indexPath];
    result = YES;    
  }
  else if ([pboard availableTypeFromArray:[NSArray arrayWithObject:NSURLPboardType]])
  {
    [self handleURLBasedDrops:pboard withIndexPath:indexPath];
    return YES;
  }
  else
  {
    result = NO;    
  }
  
  return result;
}


@end