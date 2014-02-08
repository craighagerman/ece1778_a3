//
//  CHListViewController.m
//  ece1778_a3
//
//  Created by Craig Hagerman on 2/7/14.
//  Copyright (c) 2014 ece1778. All rights reserved.
//

#import "CHListViewController.h"
#import "CHAppDelegate.h"
#import "Record.h"
#import "CHPhotoRecordDetailViewController.h"

@interface CHListViewController ()

//@property (copy, nonatomic) NSArray *dwarves;
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation CHListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getAllRecords];
    
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:self.editButtonItem.style
                                                                             target:self
                                                                             action:@selector(editButtonPressed)];
    */
    [self.tableView reloadData];
    
    /*
    self.dwarves = @[@"Sleepy", @"Sneezy", @"Bashful", @"Happy",
                     @"Doc", @"Grumpy", @"Dopey",
                     @"Thorin", @"Dorin", @"Nori",
                     @"Ori", @"Balin", @"Dwalin",
                     @"Fili", @"Kili", @"Oin",
                     @"Gloin", @"Bifur", @"Bofur", @"Bombur"];
    */
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
 
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.dwarves count];
    return [self.fetchedRecordsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    Record * record = [self.fetchedRecordsArray objectAtIndex:indexPath.row];

    
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    
    
    //NSString *filepath  = [NSString stringWithFormat:@"/Volumes/Cabinet/craig/Library/Application Support/iPhone Simulator/7.0.3/Applications/53D7E0D2-7F02-42E3-83F4-7D869494546E/Documents/imageWhatever1"];
    //UIImage *image = [UIImage imageWithContentsOfFile:filepath];
    
    //UIImage *image = [UIImage imageNamed:@"star"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:record.imagePath];
    
    
    
    cell.imageView.image = image;
    //cell.textLabel.text = self.dwarves[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,  %@",record.latitude,record.longitude];
    
    return cell;
}




    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPhotoRecordDetailViewController* detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerIdentifier"];
    // assign the object tapped row to 'detailController.selectedRecord'
    detailController.selectedRecord = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
    
    //NSString*rowValue=self.dwarves[indexPath.row];
    //NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Yes I Did"
                                          otherButtonTitles:nil];
    [alert show];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





    
    
    

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.managedObjectContext deleteObject:[self.fetchedRecordsArray objectAtIndex:indexPath.row]];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.fetchedRecordsArray = [appDelegate getAllRecords];
        [tableView endUpdates];
        
        
        /*
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:managedObject];
        [self.managedObjectContext save:nil];
        */
        
        /*
        ////////////////////////////////
        NSLog(@"Deleting recent entries");
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSArray *ra = [appDelegate getAllRecords];
        Record *record = [ra objectAtIndex:row];
        [self.managedObjectContext deleteObject:record];
        [self.managedObjectContext save:nil];
        */

        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}









/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
