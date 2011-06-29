//
//  OutLineView_DemoAppDelegate.h
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PCTreeController.h"
#import "PCOutLineView.h"

@interface OutLineView_DemoAppDelegate : NSObject <NSApplicationDelegate> {
@private
  NSWindow *window;
  IBOutlet PCTreeController* treecontroller;
  IBOutlet PCOutLineView* outline;
  NSPersistentStoreCoordinator *__persistentStoreCoordinator;
  NSManagedObjectModel *__managedObjectModel;
  NSManagedObjectContext *__managedObjectContext;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) NSArray *dragNodesArray;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;
- (IBAction)addRoot:sender;
- (IBAction)addChild:sender;
- (IBAction)removeEntity:sender;

- (NSArray*)sortDescriptors;

- (void)handleInternalDrops:(NSPasteboard *)pboard withIndexPath:(NSIndexPath *)indexPath;
- (void)handleFileBasedDrops:(NSPasteboard *)pboard withIndexPath:(NSIndexPath *)indexPath;

@end
