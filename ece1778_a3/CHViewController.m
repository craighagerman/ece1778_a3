//
//  CHViewController.m
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/7/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "CHViewController.h"
#import "CHAppDelegate.h"
#import "CHPlace.h"
#import "Record.h"

@interface CHViewController ()

@property (strong, nonatomic) IBOutlet UIImage *image;
@property (copy, nonatomic)  NSString *filePath;
@property (copy, nonatomic) NSString *lattitudeString;
@property (copy, nonatomic) NSString *longitudeString;
@property (strong, nonatomic) CLLocationManager *locationManager;

-(NSString *)getFilePath:(double)timestamp;
-(BOOL)checkFileExists:(NSString *)filePath;

@end

@implementation CHViewController

#pragma mark - Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushTable:(id)sender {
    [self performSegueWithIdentifier: @"tableSegue" sender: self];
}


-(IBAction)shakeDetected:(id)sender
{
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    double timestamp = [[NSDate date] timeIntervalSince1970];
    newEntry.timestamp = timestamp;
    newEntry.latitude = self.lattitudeString;
    newEntry.longitude = self.longitudeString;
    self.filePath = [self getFilePath:timestamp];
    newEntry.imagePath = self.filePath;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
    }
    
    [self takePicture];
}


-(NSString *)getFilePath:(double)timestamp
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName =  [NSString stringWithFormat:@"%.04f", timestamp];
    return [documentsPath stringByAppendingPathComponent:fileName];
}


-(BOOL)checkFileExists:(NSString *)filePath
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return fileExists;
}






#pragma mark ---------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Geo-Location Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.lattitudeString = [NSString stringWithFormat:@"%g\u00B0", newLocation.coordinate.latitude];
    self.longitudeString = [NSString stringWithFormat:@"%g\u00B0", newLocation.coordinate.longitude];
    self.gpsLabel.text = [NSString stringWithFormat:@"%@N  %@W", self.lattitudeString, self.longitudeString];
    
    CHPlace *start = [[CHPlace alloc] init]; start.coordinate = newLocation.coordinate; start.title = @"Start Point";
    start.subtitle = @"This is where we started!";
    //[_mapView addAnnotation:start];
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100); [_mapView setRegion:region animated:YES];
    
    if (newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0) { // invalid accuracy
    } return;
    
    if (newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50) {
        // accuracy radius is so large, we don't want to use it
    } return;
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location" message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil
                          ];
    [alert show];
}





#pragma mark ---------------------------------------------------------------------------------------------------------------------------------------
#pragma mark shake functions

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Shaking began ....");
        self.gpsLabel.text = [NSString stringWithFormat:@"Shaking began!"];
    }
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
         //NSLog(@"Shaking ended");
        self.gpsLabel.text = [NSString stringWithFormat:@"%@N  %@W", self.lattitudeString, self.longitudeString];
        [self shakeDetected:nil];
    }
}






#pragma mark ---------------------------------------------------------------------------------------------------------------------------------------
#pragma mark  Camera functions 


-(void)takePicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.showsCameraControls = NO;
    [self presentViewController:picker animated:YES completion:^{
        sleep(1);
        [picker takePicture];
    }];
}

 
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
     
     if([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
     UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
     
         //Save Photo to library only if it wasnt already saved i.e. its just been taken
         if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
             UIImageWriteToSavedPhotosAlbum(photoTaken, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
             [self saveImageToDisk:photoTaken];
         }
     }
     [picker dismissViewControllerAnimated:YES completion:nil];
 }
 
 
 -(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
     UIAlertView *alert;
     if (error) {
         alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alert show];
     }
 }
 
 
 -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
     [picker dismissViewControllerAnimated:YES completion:nil];
 }


-(void)saveImageToDisk:(UIImage *) image
{
    
    CGFloat height = 640.0f;
    CGFloat width = (height / image.size.height) * image.size.width;
    UIImage *rotatedImage = [image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationDefault];
    
    
    NSData *imageData = UIImagePNGRepresentation(image); // or use UIImageJPEGRepresentation if it's a jpeg image
    NSError *writeError = nil;
    
    if (![imageData writeToFile:self.filePath options:NSDataWritingAtomic error:&writeError]) {
        NSLog(@"Failed to write file: %@", writeError);
    }
    /*
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved:"
                                                        message:self.filePath
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
     */
    if ([self checkFileExists:self.filePath]){
        NSLog(@"File exisits");
    }
    else {
        NSLog(@"Apparently the file doesn't exisit!");
    }
}






@end
