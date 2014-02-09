//
//  CHViewController.h
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/7/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>

@interface CHViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)pushTable:(id)sender;
-(IBAction)shakeDetected:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
