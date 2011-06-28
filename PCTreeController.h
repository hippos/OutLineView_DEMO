//
//  PCTreeController.h
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright 2011 hippos-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCEntity.h"

@interface PCTreeController : NSTreeController 
{
@private
    
}

- (void)insertObject:(PCEntity*)object atArrangedObjectIndexPath:(NSIndexPath *)indexPath;
- (void)insertChild:(PCEntity*)object;

@end
