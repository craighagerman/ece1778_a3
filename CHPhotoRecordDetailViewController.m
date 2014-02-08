//
//  CHPhotoRecordDetailViewController.m
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/8/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "CHPhotoRecordDetailViewController.h"

@interface CHPhotoRecordDetailViewController ()

@end

@implementation CHPhotoRecordDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initialSetup
{
    self.myImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",self.selectedRecord.imagePath]];
    self.myLabel.text = [NSString stringWithFormat:@"%@,  %@",self.selectedRecord.latitude, self.selectedRecord.longitude];
}


-(void)updateImage:(UIImage *)image withLabel:(NSString *) str
{
    self.myImageView.image = image;
    self.myLabel.text = str;
}



@end
