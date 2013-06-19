//
//  SSItemsViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSItemsViewController.h"
#import "SSDetailViewController.h"
#import "SSItemTableViewCell.h"

typedef enum {
	SSItemsViewControllerActionSheetIndexQRCode,
	SSItemsViewControllerActionSheetIndexManual
} SSItemsViewControllerActionSheetIndex;

@implementation SSItemsViewController

#pragma mark -
#pragma mark Initialization

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[SSModelController sharedInstance].shoppingList.delegate = self;
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}
	switch (buttonIndex) {
		case SSItemsViewControllerActionSheetIndexManual:
			[self performSegueWithIdentifier:@"ShowAddNewShoppingList" sender:self];
			break;
		case SSItemsViewControllerActionSheetIndexQRCode:
			NSLog(@"QR Code");
			break;
	}
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id  sectionInfo = [[[SSModelController sharedInstance].shoppingList sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ShoppingListCell";
	
	SSItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.shoppingListNameLabel.text = [[[SSModelController sharedInstance].shoppingList objectAtIndexPath:indexPath] name];
	
	return cell;
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			SSItemTableViewCell *cell = (SSItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
			cell.shoppingListNameLabel.text = [[[SSModelController sharedInstance].shoppingList objectAtIndexPath:indexPath] name];
			break;
		}
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

#pragma mark -
#pragma mark Actions

- (IBAction)addButtonPushed:(UIBarButtonItem *)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"QR Code", @"Manual", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

#pragma mark -
#pragma mark Overridden methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ShowSelectedShoppingList"]){
		SSDetailViewController *detailVC = [segue destinationViewController];
		
		NSIndexPath *shoppingListIndexPath = [self.tableView indexPathForCell:sender];
		detailVC.selectedShoppingList = [[SSModelController sharedInstance].shoppingList objectAtIndexPath:shoppingListIndexPath];
	}
}

@end