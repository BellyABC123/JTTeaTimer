//
//  TimerListViewController.m
//  Coffe Timer
//
//  Created by Jack Thompson on 23/11/14.
//  Copyright (c) 2014 Jack Thompson. All rights reserved.
//

#import "TimerListViewController.h"
#import "TimerDetailViewController.h"
#import "TimerEditViewController.h"
#import "TimerModel.h"
#import "AppDelegate.h"

enum {
    TimerListCoffeeSection=0,
    TimerListTeaSection,
    TimerListNumberOfSections
};

@interface TimerListViewController ()

@property (nonatomic,strong) NSFetchedResultsController* fetchController;
@property (nonatomic,assign) BOOL userReorderingCells;

@end

@implementation TimerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError* fetchError;
    if(![self.fetchController performFetch:&fetchError]){
        NSLog(@"Error fetching %@",fetchError);
    }
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
}

-(NSFetchedResultsController*)fetchController{
    if(!_fetchController){
        NSFetchRequest* req=[NSFetchRequest fetchRequestWithEntityName:@"TimerModel"];
        req.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES],
                              [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
        NSManagedObjectContext* managedContext=[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
        _fetchController=[[NSFetchedResultsController alloc]initWithFetchRequest:req
                                                            managedObjectContext:managedContext
                                                              sectionNameKeyPath:@"type"
                                                                       cacheName:nil];
        _fetchController.delegate=self;
    }
    
    return _fetchController;
}

-(void)controller:(NSFetchedResultsController*)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath{
    if (self.userReorderingCells)
        return;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController*)controller{
    if (self.userReorderingCells)
        return;
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController*)controller{
    if (self.userReorderingCells)
        return;
    [self.tableView endUpdates];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.presentedViewController != nil){
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> info= self.fetchController.sections[section];
    return info.numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TimerModel* tm=[self timerModelForIndexPath:indexPath];
    
    cell.textLabel.text= tm.name;
    
    return cell;
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==TimerListCoffeeSection){
        return NSLocalizedString(@"Coffee",@"Coffee");
    }else if(section==TimerListTeaSection){
        return NSLocalizedString(@"Teas",@"Teas");
    }
    
    return @"";
}

#pragma mark - Delete row

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle== UITableViewCellEditingStyleDelete){
        TimerModel* tm=[self timerModelForIndexPath:indexPath];
        [tm.managedObjectContext deleteObject:tm];
    }
}

#pragma mark - Move Rows

-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (sourceIndexPath.section==proposedDestinationIndexPath.section) {
        return proposedDestinationIndexPath;
    }
    
    if (sourceIndexPath.section==TimerListCoffeeSection) {
        NSInteger ncell=[self.fetchController.sections[TimerListCoffeeSection] numberOfObjects];
        return [NSIndexPath indexPathForRow:ncell-1 inSection:TimerListCoffeeSection];
    }else if (sourceIndexPath.section==TimerListTeaSection) {
        return [NSIndexPath indexPathForRow:0 inSection:TimerListTeaSection];
    }
    
    return sourceIndexPath;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    self.userReorderingCells=YES;
    
    NSMutableArray* sectionO=[[[self.fetchController sections][sourceIndexPath.section] objects] mutableCopy];
    NSManagedObject* obj= [[self fetchController]objectAtIndexPath:sourceIndexPath];
    [sectionO removeObject:obj];
    [sectionO insertObject:obj atIndex:destinationIndexPath.row];

    for (NSInteger i=0; i<sectionO.count; i++) {
        TimerModel* tm=sectionO[i];
        tm.displayOrder=i;
    }
    [obj.managedObjectContext save:nil];
    self.userReorderingCells=NO;

}

#pragma mark - Copy

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    NSLog(@"Can perform %@ ?",NSStringFromSelector(action));
    if([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    TimerModel* tm=[self timerModelForIndexPath:indexPath];
    
    UIPasteboard* clip=[UIPasteboard generalPasteboard];
    [clip setString:tm.name];
    
}

#pragma mark - Navigation: editDetail

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"pushDetail"]){
        if(self.tableView.isEditing)
            return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isEditing){
        [self performSegueWithIdentifier:@"editDetail" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Navigation: Others

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([sender isKindOfClass:[UITableViewCell class]]){
        UITableViewCell* cell=sender;
        NSIndexPath* index=[self.tableView indexPathForCell:cell];
        
        TimerModel* tm=[self timerModelForIndexPath:index];
        
        if([segue.identifier isEqualToString:@"pushDetail"]){
            TimerDetailViewController* vc=segue.destinationViewController;
            vc.timerModel=tm;
        }else if([segue.identifier isEqualToString:@"editDetail"]){
            UINavigationController* nc=(UINavigationController*) segue.destinationViewController;
            TimerEditViewController* vc=(TimerEditViewController* )nc.topViewController;
            vc.delegate=self;
            vc.timerModel=tm;
        }
    }else{
        if([segue.identifier isEqualToString:@"newTimer"]){
            NSManagedObjectContext* managedC=[ (AppDelegate*)[[UIApplication sharedApplication]delegate] managedObjectContext];
            TimerModel* tm=[NSEntityDescription
                            insertNewObjectForEntityForName:@"TimerModel"
                                     inManagedObjectContext:managedC];
            
            UINavigationController* nc=(UINavigationController*) segue.destinationViewController;
            TimerEditViewController* vc=(TimerEditViewController*)nc.topViewController;
            vc.delegate=self;
            vc.creatingNewTimer=YES;
            vc.timerModel=tm;
        }
    }
}

#pragma mark - Save stuff

-(void)timerEditViewControllerDidSaveTimerModel:(TimerEditViewController *)viewController{
    [viewController.timerModel.managedObjectContext save:nil];
}

-(void)timerEditViewControllerDidCancel:(TimerEditViewController *)viewController{
    if(viewController.creatingNewTimer){
        [viewController.timerModel.managedObjectContext deleteObject:viewController.timerModel];
    }
}

#pragma mark - Utility Methods

-(TimerModel*)timerModelForIndexPath:(NSIndexPath*)indexPath{
    
    TimerModel* tm=[self.fetchController objectAtIndexPath:indexPath];
    return tm;
}

@end
