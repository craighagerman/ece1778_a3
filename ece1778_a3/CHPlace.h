//
//  CHPlace.h
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/9/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CHPlace : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end


