//
//  WebViewController.h
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	UIWebView	*theWebView;
	NSString	*urlString;
    UIActivityIndicatorView  *whirl;

}

-(void) updateToolbar;

@property (nonatomic, retain) NSString *urlString;

@end
