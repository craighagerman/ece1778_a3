//
//  CHPhotoRecordDetailViewController.h
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/8/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface CHPhotoRecordDetailViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *myImageView;
@property (retain, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic, strong)Record *selectedRecord ;


-(void)updateImage:(UIImage *)image withLabel:(NSString *)str;



@end
