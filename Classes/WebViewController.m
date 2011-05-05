    //
//  WebViewController.m
//  WebView
//
//  Created by Ajay Chainani on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize urlString;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationController setToolbarHidden:NO animated:YES];
	
	UIBarButtonItem *backButton =	[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:theWebView action:@selector(goBack)];
	UIBarButtonItem *forwardButton =	[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardIcon.png"] style:UIBarButtonItemStylePlain target:theWebView action:@selector(goForward)];
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:theWebView action:@selector(reload)];
	UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
	UIBarButtonItem *spacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray *contents = [[NSArray alloc] initWithObjects:backButton, spacing, forwardButton, spacing, refreshButton, spacing, openButton, nil];
	[backButton release];
	[forwardButton release];
	[refreshButton release];
	[openButton release];
	[spacing release];
	
	[self setToolbarItems:contents animated:YES];

}

- (void)dealloc
{
    //make sure that it has stopped loading before deallocating
    if (theWebView.loading)
        [theWebView stopLoading];

    //deallocate web view
	theWebView.delegate = nil;
	[theWebView release];
	
	[urlString release];
	
	[super dealloc];
}

- (void)refreshWeb:(id)sender {
	[theWebView reload];
}



- (void)loadView
{	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];	
	contentView.autoresizesSubviews = YES;
	self.view = contentView;	
	[contentView release];
	
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y = 0;	
	
	theWebView = [[UIWebView alloc] initWithFrame:webFrame];
	theWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	theWebView.scalesPageToFit = YES;
	theWebView.delegate = self;
	
	NSURL *url = [NSURL URLWithString:urlString];
	[urlString release];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[theWebView loadRequest:req];
	
	[self.view addSubview: theWebView];
}

#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
	UIActivityIndicatorView  *whirl = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	whirl.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
	whirl.center = self.view.center;
	[whirl startAnimating];
	self.navigationItem.titleView = whirl;
	[whirl release];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.navigationItem.titleView = nil;
	self.title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"]; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:theWebView.request.URL];
	}
}

- (void)shareAction {

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
										cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
										otherButtonTitles:@"Open in Safari", nil];
	
	[actionSheet showInView: self.view];
	[actionSheet release];
	
}


@end
