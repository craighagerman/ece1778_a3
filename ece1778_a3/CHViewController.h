//
//  CHViewController.h
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/7/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>


@interface CHViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gpsLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
-(IBAction)pushTable:(id)sender;
-(IBAction)shakeDetected:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
