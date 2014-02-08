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

    newEntry.timestamp = [[NSDate date] timeIntervalSince1970];
    newEntry.latitude = @"0.00.123";
    newEntry.longitude = @"99.00.123";
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cavalier0"]];
    NSData *imageData = UIImagePNGRepresentation(image); // or use UIImageJPEGRepresentation if it's a jpeg image
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = @"dog";
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    newEntry.imagePath = filePath;
    
    NSError *writeError = nil;
    
    if (![imageData writeToFile:filePath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Failed to write file: %@", writeError);
    }
    

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
    }
        

    
}





//-(void)saveImageToDisk:(UIImage *) image
-(void)saveImageToDisk
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cavalier0"]];
    NSData *imageData = UIImagePNGRepresentation(image); // or use UIImageJPEGRepresentation if it's a jpeg image
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = @"dog";
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];

    
    
    NSError *writeError = nil;
    
    if (![imageData writeToFile:filePath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Failed to write file: %@", writeError);
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved:"
                                                        message:filePath
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    NSLog(@"filepath:  %@", filePath);
}











@end
