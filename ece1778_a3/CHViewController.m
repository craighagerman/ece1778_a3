//
//  CHViewController.m
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/7/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "CHViewController.h"
#import "Record.h"
#import "CHAppDelegate.h"

@interface CHViewController ()

@property (nonatomic, copy) NSString *imageFilePath;

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    [self addGeoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushTable:(id)sender {
    [self performSegueWithIdentifier: @"tableSegue" sender: self];
}


- (IBAction)addGeoData
{
    /*  Add Entry to Data base
     Add all entries to Core Data, and then delete the new entries if 'Store' is not tapped on the initial scene.
     In this case, this is easier than passing messages or objects (say with NSNotification) or creating temp files.
     */
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    
    //UIImage *newimage = [UIImage imageNamed:@"cavalier5"];
    
    newEntry.latitude = @"0.123.456";
    newEntry.longitude = @"99.45.67";
    
    newEntry.imagePath = self.imageFilePath;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
    }
        

    
}















@end
