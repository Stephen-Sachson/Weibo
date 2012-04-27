//
//  WeiboViewController.h
//  Weibo
//
//  Created by Stephen on 4/22/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface WeiboViewController : UIViewController <WBEngineDelegate,UITextFieldDelegate>{
	WBEngine *engine1;
	
	UILabel *label1,*label2,*label3,*label4;
	UIImageView *imageView;
	UIButton *button;
	NSNumber *tweetID;
	BOOL shouldRefresh,shallSendViewShow;
	UITextField *textField1;
	UIView *dim;
	UIImageView *imageToSend;
	int a;
}
@property (nonatomic, retain) WBEngine *engine1;
@property (nonatomic, retain) IBOutlet UILabel *label1,*label2,*label3,*label4;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)shouQuan;
- (IBAction)faWeibo;
@end

