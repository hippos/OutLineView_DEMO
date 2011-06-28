//
//  PCEntity.m
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright (c) 2011 hippos-lab.com. All rights reserved.
//

#import "PCEntity.h"
#import "PCEntity.h"


@implementation PCEntity
@dynamic display_name;
@dynamic isGroup;
@dynamic index;
@dynamic children;
@dynamic parent;

- (void)addChildrenObject:(PCEntity *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] addObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeChildrenObject:(PCEntity *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] removeObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addChildren:(NSSet *)value {    
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] unionSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeChildren:(NSSet *)value {
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] minusSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
