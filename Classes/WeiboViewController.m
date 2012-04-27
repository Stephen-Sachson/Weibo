//
//  WeiboViewController.m
//  Weibo
//
//  Created by Stephen on 4/22/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import "WeiboViewController.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>


@implementation WeiboViewController
@synthesize engine1;
@synthesize label1,label2,label3,label4;
@synthesize imageView;
@synthesize button;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
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
	WBEngine *engine=[[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
	engine.delegate=self;
	engine.rootViewController=self;
	self.engine1=engine;
	[engine release];
	if([engine1 isLoggedIn])
		[self engineDidLogIn:engine1];
	shouldRefresh=NO;
	shallSendViewShow=YES;
	/*
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:kAppKey, @"client_id",
							@"code", @"response_type",
							@"http://", @"redirect_uri", 
							@"mobile", @"display", nil];
	NSString *urlString = [WBRequest serializeURL:@"https://api.weibo.com/oauth2/authorize"
                                           params:params
                                       httpMethod:@"GET"];
	NSURLRequest *request=[[NSURLRequest alloc] 
						   initWithURL:[NSURL URLWithString:urlString]];
	UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
	[webView loadRequest:request];
	self.view=webView;
	*/
}

- (IBAction)shouQuan {
	if (shouldRefresh) [self engineDidLogIn:engine1];
	else 
	[engine1 logIn];
}

- (IBAction)faWeibo {
	if (shallSendViewShow) {
		NSLog(@"send");
		textField1=[[UITextField alloc] initWithFrame:CGRectMake(20, 60, 280, 40)];
		textField1.delegate=self;
		textField1.borderStyle=UITextBorderStyleBezel;
		textField1.backgroundColor=[UIColor whiteColor];
		textField1.placeholder=@"在这儿写微博";
		dim=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		dim.backgroundColor=[UIColor purpleColor];
		dim.alpha=0.5;
		imageToSend=[[UIImageView alloc] initWithFrame:CGRectMake(100, 120, 120, 148.34)];
		imageToSend.image=[UIImage imageNamed:@"momo.jpg"]; 
		
		[self.view addSubview:dim];
        [self.view addSubview:textField1];
		[self.view addSubview:imageToSend];
		shallSendViewShow=NO;
	}
	
}
- (void)engineDidLogIn:(WBEngine *)engine {
	[engine1 loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:nil
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result {
	shouldRefresh=YES;
	NSDictionary *dict=(NSDictionary *)result;
	if ([dict objectForKey:@"statuses"]!=nil) {
		NSArray *array=[[NSArray alloc] initWithArray:[dict objectForKey:@"statuses"]];
		NSDictionary *dict1=[[NSDictionary alloc] initWithDictionary:[array objectAtIndex:0]];
		
		tweetID=[dict1 objectForKey:@"mid"];
		NSString *string=[[NSString alloc] initWithString:[dict1 objectForKey:@"text"]];
		label3.text=string;
		label1.text=[[dict1 objectForKey:@"user"] objectForKey:@"screen_name"];
		label2.text=[NSString stringWithFormat:@"%i comments",[[dict1 objectForKey:@"comments_count"] intValue]];
		a=[[dict1 objectForKey:@"comments_count"] intValue];
		if([dict1 objectForKey:@"thumbnail_pic"]!=nil) {
			NSString *string1=[NSString stringWithString:[dict1 objectForKey:@"thumbnail_pic"]];
			NSURL *url=[NSURL URLWithString:string1];
			NSData *data=[NSData dataWithContentsOfURL:url];
			UIImage *image1=[UIImage imageWithData:data];
			imageView.image=image1;
		}					
		NSURL *url1=[NSURL URLWithString:[[dict1 objectForKey:@"user"] objectForKey:@"profile_image_url"]];
		NSData *data1=[NSData dataWithContentsOfURL:url1];
		[button setImage:[UIImage imageWithData:data1] forState:UIControlStateNormal];
	}
	else { if(a!=0) {
		NSArray *array1=[NSArray arrayWithArray:[dict objectForKey:@"comments"]];
		NSDictionary *dict2=[NSDictionary dictionaryWithDictionary:[array1 objectAtIndex:0]];
		label4.text=[dict2 objectForKey:@"text"];
	}
	else label4.text=@"没有评论";
	}

}
	
- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error {
	NSLog(@"%@",error);
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[engine1 sendWeiBoWithText:textField1.text image:[UIImage imageNamed:@"momo.jpg"]];
	[textField1 resignFirstResponder];
	[textField1 removeFromSuperview];
	[imageToSend removeFromSuperview];
	[dim removeFromSuperview];
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"发出去了！" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
	[alert show];
	[alert release];
	shallSendViewShow=YES;
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textField1 release];
	[imageToSend release];
	[dim release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch=[touches anyObject];
	CGPoint point=[touch locationInView:self.view];
	float x,y,w,h;
	x=label2.frame.origin.x;
	y=label2.frame.origin.y;
	w=label2.frame.size.width+x;
	h=label2.frame.size.height+y;
	BOOL horizontal=point.x>x && point.x<w;
	BOOL vertical=point.y>y && point.y<h;
	if(horizontal && vertical) {
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
		[params setObject:engine1.accessToken forKey:@"access_token"];
		[params setObject:tweetID forKey:@"id"];
		[engine1 loadRequestWithMethodName:@"comments/show.json" 
								httpMethod:@"GET" 
									params:params 
							  postDataType:kWBRequestPostDataTypeNone
						  httpHeaderFields:nil];
	}
}
@end
