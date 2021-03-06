//
//  SSDetailViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSDetailViewController.h"
#import "SSElementViewController.h"
#import "SSDetailTableViewCell.h"
#import "SSWebservice.h"

@interface SSDetailViewController() {
	__block EGORefreshTableHeaderView *_refreshHeaderView;
	
	__block BOOL _reloading;
}

@end

@interface SSDetailViewController(SSDetailViewControllerPrivate)
- (void)doneLoadingTableViewData:(NSError *)anError;
@end

#pragma mark -

@implementation SSDetailViewController

#pragma mark -
#pragma mark Properties

@synthesize selectedShoppingList = _selectedShoppingList;

#pragma mark -
#pragma mark Initialization

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[SSModelController sharedInstance].shoppingListElement.delegate = self;
	
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
	_refreshHeaderView.delegate = self;
	[self.tableView addSubview:_refreshHeaderView];
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_refreshHeaderView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Getters and setters

- (SSShoppingList *)selectedShoppingList {
	return _selectedShoppingList;
}

- (void)setSelectedShoppingList:(SSShoppingList *)selectedShoppingList {
	if (_selectedShoppingList != selectedShoppingList) {
		[_selectedShoppingList release];
		_selectedShoppingList = [selectedShoppingList retain];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shoppingList == %@)", selectedShoppingList];
		[SSModelController sharedInstance].shoppingListElement.fetchRequest.predicate = predicate;
		[[SSModelController sharedInstance].shoppingListElement performFetch:nil];
		
		[self.tableView reloadData];
		
		self.navigationItem.title = _selectedShoppingList.name;
	}
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id sectionInfo = [[[SSModelController sharedInstance].shoppingListElement sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ElementCell";
	SSDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	SSShoppingListElement *element = [[SSModelController sharedInstance].shoppingListElement objectAtIndexPath:indexPath];
	cell.nameLabel.text = element.name;
	cell.priceLabel.text = [element.price stringValue];
	cell.amountLabel.text = [element.amount stringValue];
	
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		__block UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
		UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[activity startAnimating];
		[alert addSubview:activity];
		[activity release];
		[alert show];
		[alert release];
		
		[activity setCenter:CGPointMake(alert.bounds.size.width * .5, alert.bounds.size.height * .5)];
		
		SSShoppingListElement *element = [[SSModelController sharedInstance].shoppingListElement objectAtIndexPath:indexPath];
		[[SSWebservice sharedInstance] deleteShoppingListElement:element withCompletionBlock:^{
			[alert dismissWithClickedButtonIndex:0 animated:YES];
		} andFailBlock:^(NSError *error) {
			[alert dismissWithClickedButtonIndex:0 animated:YES];
		}];
    }
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(SSShoppingListElement *)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate: {
			SSDetailTableViewCell *cell = (SSDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
			cell.nameLabel.text = anObject.name;
			cell.priceLabel.text = [anObject.price stringValue];
			cell.amountLabel.text = [anObject.amount stringValue];
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
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	_reloading = YES;
	__block SSDetailViewController *weakSelf = self;
	[[SSWebservice sharedInstance] refreshShoppingListElementsInShoppingList:self.selectedShoppingList withCompletionBlock:^{
		[weakSelf performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:nil waitUntilDone:NO];
	} andFailBlock:^(NSError *error) {
		[weakSelf performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:error waitUntilDone:NO];
	}];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	return [NSDate date];
}

#pragma mark -
#pragma mark Overridden methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier rangeOfString:@"ElementDetailSegue"].location == 0) {
		SSElementViewController *elementVC = [segue destinationViewController];
		elementVC.shoppingList = self.selectedShoppingList;
		if ([sender isKindOfClass:[UIBarButtonItem class]]) {
			elementVC.navigationItem.title = @"Add New Item";
		} else {
			NSIndexPath *indexPath = [self.tableView indexPathForCell:(SSDetailTableViewCell *)sender];
			SSShoppingListElement *element = [[SSModelController sharedInstance].shoppingListElement objectAtIndexPath:indexPath];
			elementVC.navigationItem.title = @"Update Item";
			elementVC.shoppingListElement = element;
		}
	}
}

@end

#pragma mark -

@implementation SSDetailViewController(SSDetailViewControllerPrivate)

- (void)doneLoadingTableViewData:(NSError *)anError {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
	if (anError) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[anError localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
		[alert release];
	}
}

@end