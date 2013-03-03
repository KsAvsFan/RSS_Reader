//
//  SMDetailViewController.h
//  SM_RSS_Reader
//
//  Created by Jamie Thomason on 3/2/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"

@interface SMDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView* myWebView;
// @property (nonatomic, retain) MWFeedItem *detailItem;
@property (nonatomic, retain) NSString *urlString;

@end
