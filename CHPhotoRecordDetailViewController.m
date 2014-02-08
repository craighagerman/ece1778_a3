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
	// Do any additional setup after loading the view.
     [self initialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initialSetup
{
    /*  GET/Set entries from Records
    //  1
    self.firstNameTextfield.text = self.selectedRecord.firstName;
    self.lastNameTextfield.text = self.selectedRecord.lastName;
    self.cityTextfield.text = self.selectedRecord.city;
    
    //  2
    NSArray* phoneNumbers = [self.selectedRecord.phoneNumbers allObjects];
    self.number1Textfield.text = ((PhoneNumber*)[phoneNumbers objectAtIndex:0]).number;
    self.number2Textfield.text = ((PhoneNumber*)[phoneNumbers objectAtIndex:1]).number;
     */
}


@end
