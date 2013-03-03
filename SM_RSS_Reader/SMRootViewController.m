//
//  SMRootViewController.m
//  SM_RSS_Reader
//
//  Created by Jamie Thomason on 3/2/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import "SMRootViewController.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "SMDetailViewController.h"
#import "MWFeedItem.h"

@interface SMRootViewController ()
{
    NSString* detailUrl;
}

@end

@implementation SMRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup
	self.title = @"Loading...";
	formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy (hh:mm a)"];
	parsedItems = [[NSMutableArray alloc] init];
	self.rssItems = [NSArray array];
	
	// Add refresh button to nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refresh)];
	// Get the xml document and parse
    NSURL *feedURL = [NSURL URLWithString:@"http://blog.solstice-mobile.com/feeds/posts/default"];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull;
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
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
    // Return the number of rows in the section.
    return [self.rssItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Configure the cell.
	MWFeedItem *item = [self.rssItems objectAtIndex:indexPath.row];
	if (item) {
		
		// Check for existance of detail items, and replace w/ placeholders if missing
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
		
		// Create the cell
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = itemTitle;
		NSMutableString *subtitle = [NSMutableString string];
		if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
        [subtitle appendString:itemSummary];
		cell.detailTextLabel.text = subtitle;
		
	}
    return cell;
}

#pragma mark - MWFeedParsing utility methods

// Reset and parse again
- (void)refresh {
	
    self.title = @"Refreshing...";
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.25;
}

// Sort parsed items by date, and re-enable tableView, and reload tableView
- (void)updateTableWithParsedItems {
	self.rssItems = [parsedItems sortedArrayUsingDescriptors:
                     [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                          ascending:NO]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

#pragma mark - MWFeedParserDelegate

// Parsing begins
- (void)feedParserDidStart:(MWFeedParser *)parser {
	// NSLog(@"Started Parsing: %@", parser.url);
}

// Parsed title item
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = info.title;
}

// Parsed blog item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

// Parsing finished
- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

// Parsing ended with error
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Save the URL of the rss item.  Will be passed to detailViewController in prepareForSegue
    MWFeedItem* feedItem = [self.rssItems objectAtIndex:indexPath.row];
    detailUrl = feedItem.link;
    [self performSegueWithIdentifier:@"Detail_Segue" sender:self];
}

#pragma mark - prepare to segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check which segue is being called (There's only one, but good to be safe)
    if ([segue.identifier isEqualToString:@"Detail_Segue"])
    {
        // Set the URL for the RSS Item in the detail view controller.  
        SMDetailViewController* detailViewController = segue.destinationViewController;
        detailViewController.urlString = detailUrl;
    }
}

@end
