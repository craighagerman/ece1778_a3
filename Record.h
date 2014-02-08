//
//  Record.h
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/8/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * imagePath;
@property double timestamp;

@end
