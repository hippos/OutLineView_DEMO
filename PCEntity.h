//
//  PCEntity.h
//  OutLineView_Demo
//
//  Created by kazuot on 11/06/29.
//  Copyright (c) 2011 hippos-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PCEntity;

@interface PCEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * display_name;
@property (nonatomic, retain) NSNumber * isGroup;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet* children;
@property (nonatomic, retain) PCEntity * parent;

@end
