//
//  OutLineView_DemoAppDelegate.m
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import "OutLineView_DemoAppDelegate.h"
#import "PCEntity.h"

@implementation OutLineView_DemoAppDelegate

@synthesize window;
@synthesize dragNodesArray;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "OutLineView_Demo" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory 
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
  return [libraryURL URLByAppendingPathComponent:@"OutLineView_Demo"];
}

/**
    Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel 
{
  if (__managedObjectModel) 
  {
    return __managedObjectModel;
  }

  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OutLineView_Demo" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return __managedObjectModel;
}

/**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator 
{
  if (__persistentStoreCoordinator) 
  {
    return __persistentStoreCoordinator;
  }

  NSManagedObjectModel *mom = [self managedObjectModel];
  if (!mom) 
  {
    NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
    return nil;
  }

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
  NSError *error = nil;
  
  NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
        
  if (!properties) 
  {
    BOOL ok = NO;
    if ([error code] == NSFileReadNoSuchFileError) 
    {
      ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (!ok) 
    {
      [[NSApplication sharedApplication] presentError:error];
      return nil;
    }
  }
  else 
  {
    if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) 
    {
      // Customize and localize this error.
      NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
      
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
      error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
      
      [[NSApplication sharedApplication] presentError:error];
      return nil;
    }
  }
    
  NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"OutLineView_Demo.storedata"];
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) 
  {
    [[NSApplication sharedApplication] presentError:error];
    [__persistentStoreCoordinator release], __persistentStoreCoordinator = nil;
    return nil;
  }

  return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *) managedObjectContext 
{
  if (__managedObjectContext) 
  {
    return __managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) 
  {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"hippos-lab.com" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }
  __managedObjectContext = [[NSManagedObjectContext alloc] init];
  [__managedObjectContext setPersistentStoreCoordinator:coordinator];

  return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window 
{
  return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction) saveAction:(id)sender 
{
  NSError *error = nil;
  
  if (![[self managedObjectContext] commitEditing]) 
  {
    NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
  }

  if (![[self managedObjectContext] save:&error]) 
  {
    [[NSApplication sharedApplication] presentError:error];
  }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender 
{

  // Save changes in the application's managed object context before the application terminates.

  if (!__managedObjectContext) 
  {
    return NSTerminateNow;
  }

  if (![[self managedObjectContext] commitEditing]) 
  {
    NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
    return NSTerminateCancel;
  }

  if (![[self managedObjectContext] hasChanges]) 
  {
    return NSTerminateNow;
  }

  NSError *error = nil;
  if (![[self managedObjectContext] save:&error]) 
  {

    // Customize this code block to include application-specific recovery steps.              
    BOOL result = [sender presentError:error];
    if (result) 
    {
      return NSTerminateCancel;
    }

    NSString *question = 
      NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
    NSString *info = 
      NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
    NSString *quitButton = 
      NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
    NSString *cancelButton = 
      NSLocalizedString(@"Cancel", @"Cancel button title");
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:question];
    [alert setInformativeText:info];
    [alert addButtonWithTitle:quitButton];
    [alert addButtonWithTitle:cancelButton];

    NSInteger answer = [alert runModal];
    [alert release];
    alert = nil;
    
    if (answer == NSAlertAlternateReturn) 
    {
      return NSTerminateCancel;
    }
  }

  return NSTerminateNow;
}

- (void)dealloc
{
  [__managedObjectContext release];
  [__persistentStoreCoordinator release];
  [__managedObjectModel release];
    [super dealloc];
}

- (IBAction)addRoot:sender
{
  NSUInteger length = 1;
  NSUInteger indexes[256];
  NSIndexPath* path = [treecontroller selectionIndexPath];
  if (path != nil)
  {
    [path getIndexes:&indexes[0]];
    indexes[[path length]-1] = indexes[[path length]-1]+1;
    length = [path length];
  }
  else
  {
    indexes[0] = 0;
    length = 1;
  }
  
  PCEntity* groupnode = 
    [NSEntityDescription insertNewObjectForEntityForName:@"PCEntity" 
                                  inManagedObjectContext:__managedObjectContext];
  groupnode.display_name = [NSString stringWithFormat:@"Root%02ld",indexes[length-1]];
  groupnode.isGroup = [NSNumber numberWithInt:1];
  [treecontroller insertObject:groupnode 
     atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndexes:&indexes[0] length:length]];
  
}

- (IBAction)addChild:sender
{
  PCEntity * childnode = 
    [NSEntityDescription insertNewObjectForEntityForName:@"PCEntity" 
                                  inManagedObjectContext:__managedObjectContext];
  childnode.display_name = [NSString stringWithFormat:@"NewChild"];
  childnode.isGroup = [NSNumber numberWithInt:0];;
  [treecontroller insertChild:childnode];
  
}

- (IBAction)removeEntity:sender
{
  for(NSTreeNode* tn in [treecontroller selectedNodes])
  {
    if (![tn isLeaf])
    {
      NSAlert* alert = [NSAlert alertWithMessageText:@"Entity has child node"
                                       defaultButton:@"NO" 
                                     alternateButton:@"YES" 
                                         otherButton:nil 
                           informativeTextWithFormat:@"Do you really remove it?"];
      if ([alert runModal] == NSAlertDefaultReturn)
      {
        continue;
      }
    }
    [treecontroller remove:tn];  
  }
}

- (void)handleInternalDrops:(NSPasteboard *)pboard withIndexPath:(NSIndexPath *)indexPath
{
  NSArray *newNodes = self.dragNodesArray;
  
  NSInteger i;
  
  for (i = ([newNodes count] - 1); i >= 0; i--)
  {
    [treecontroller moveNode:[newNodes objectAtIndex:i] toIndexPath:indexPath];
  }
  
  // keep the moved nodes selected
  NSMutableArray *indexPathList = [NSMutableArray array];
  for (i = 0; i < [newNodes count]; i++)
  {
    [indexPathList addObject:[[newNodes objectAtIndex:i] indexPath]];
  }
  
  [(NSTreeController *)treecontroller setSelectionIndexPaths:indexPathList];
}

- (void)handleFileBasedDrops:(NSPasteboard *)pboard withIndexPath:(NSIndexPath *)indexPath
{
  NSArray *fileNames = [pboard propertyListForType:NSFilenamesPboardType];
  
  if ([fileNames count] > 0)
  {
    NSInteger i;
    NSInteger count = [fileNames count];
    
    for (i = (count - 1); i >= 0; i--)
    {
      NSURL  *url  = [NSURL fileURLWithPath:[fileNames objectAtIndex:i]];
      PCEntity *node = [treecontroller newObject];
      NSString *name = [[NSFileManager defaultManager] displayNameAtPath:[url path]];
      node.display_name = name;
      [treecontroller insertObject:node atArrangedObjectIndexPath:indexPath];
      [node release];
    }
  }
}


@end
