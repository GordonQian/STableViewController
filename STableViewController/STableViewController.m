//
//  STableViewController.m
//  STableViewController
//
//  Created by Shiki on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STableViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize headerView;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView = [[[UITableView alloc] init] autorelease];
  // @todo the height needs to be fixed (in cases where there is a navigation bar)
  //tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  tableView.frame = self.view.bounds;
  tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
  tableView.dataSource = self;
  tableView.delegate = self;
  
  [self.view addSubview:tableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView *)aView
{
  if (!tableView)
    return;
  
  if (headerView && [headerView isDescendantOfView:tableView])
    [headerView removeFromSuperview];
  [headerView release]; headerView = nil;
  
  if (aView) {
    headerView = [aView retain];
    
    CGRect f = headerView.frame;
    headerView.frame = CGRectMake(f.origin.x, 0 - f.size.height, f.size.width, f.size.height);
    headerViewFrame = headerView.frame;
    
    [tableView addSubview:headerView];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerRefreshHeight
{
  if (!CGRectIsEmpty(headerViewFrame))
    return headerViewFrame.size.height;
  else
    return 52;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsMake([self headerRefreshHeight], 0, 0, 0);
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
  [UIView animateWithDuration:0.3 animations:^(void) {
    self.tableView.contentInset = UIEdgeInsetsZero;
  }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginRefresh
{
  isRefreshing = YES;
  
  [self pinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshCompleted
{
  isRefreshing = NO;
  
  [self unpinHeaderView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (isRefreshing)
    return;
  isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (isRefreshing) {
    
  } else if (isDragging && scrollView.contentOffset.y < 0)  {
    [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight] 
                   scrollView:scrollView];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (isRefreshing)
    return;
  
  isDragging = NO;
  if (scrollView.contentOffset.y <= 0 - [self headerRefreshHeight]) {
    [self willBeginRefresh];
    [self refresh];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Methods to override

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willShowHeaderView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refresh
{
  [self performSelector:@selector(refreshCompleted) withObject:nil afterDelay:2.0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
  [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
  [super viewDidUnload];
  
  self.headerView = nil;
  self.tableView = nil;
}

@end
