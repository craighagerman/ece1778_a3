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
- (UIImage *)scaleAndRotateImage:(UIImage *)image;

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
    
    CHPlace *start = [[CHPlace alloc] init]; start.coordinate = newLocation.coordinate; start.title = @"Here";
    start.subtitle = @"now";
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
    //[alert show];         // used for development, debugging
}





#pragma mark ---------------------------------------------------------------------------------------------------------------------------------------
#pragma mark shake functions

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        //NSLog(@"Shaking began ....");        // used for development, debugging
        self.gpsLabel.text = [NSString stringWithFormat:@"Shaking began!"];
    }
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
         //NSLog(@"Shaking ended");      // used for development, debugging
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
    //[alert show];     // used for development, debugging
     }
 }
 
 
 -(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
     [picker dismissViewControllerAnimated:YES completion:nil];
 }


-(void)saveImageToDisk:(UIImage *) image
{
    UIImage *imageCopy = [self scaleAndRotateImage:image];
    
    NSData *imageData = UIImagePNGRepresentation(imageCopy); // or use UIImageJPEGRepresentation if it's a jpeg image
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
        //NSLog(@"File exisits"); // used for development, debugging
    }
    else {
        //NSLog(@"Apparently the file doesn't exisit!");  // used for development, debugging
    }
}

#pragma mark - scaleAndRotateImage (copied code)
/*  *****************************************************************************************************************
    NOTE:    Although the orientation for this app is only allowed to be portrait, the imagePickerController camera
    has a default orientation of landscape. This means that when using imagePickerController to take a photo
    programmatically it will be taken in portrait but identified as landscape. This makes (1) the display orientation
    wrong and (2) causes the image to be stretched and squashed. The code below is copied from the web discussion
    listed and serves to return a resized, rotated copy of an image to correct for this behavior.
    see: http://stackoverflow.com/questions/538041/uiimagepickercontroller-camera-preview-is-portrait-in-landscape-app
    see also:  http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
*****************************************************************************************************************  */

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}





@end
