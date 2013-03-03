//
//  SMRootViewController.h
//  SM_RSS_Reader
//
//  Created by Jamie Thomason on 3/2/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface SMRootViewController : UITableViewController <MWFeedParserDelegate>
{
    MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
}

@property (strong, nonatomic) NSArray* rssItems;


@end
