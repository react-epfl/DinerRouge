//
//  FriendCollectionViewController.h
//  PayPerPay
//
//  Created by Adrian Holzer on 18.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillManagerDelegate.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define STEP0 0
#define STEP1 1
#define STEP2 2
#define STEP3 3



@interface FriendCollectionViewController : UICollectionViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property(strong, nonatomic) IBOutlet UITextField * totalAmountTextField;
@property(strong, nonatomic) IBOutlet UIButton * checkoutButton;

@property(strong, nonatomic)  UIView * inputView;

@property(strong, nonatomic)  UITextView * tutorialTextView;
@property(strong, nonatomic)  UITextField * amountTextField;
@property(strong, nonatomic)  UILabel * amountLabel;
@property(strong, nonatomic)  UIButton * amountDoneButton;
@property(strong, nonatomic)  UIButton * addFriendDoneButton;
@property(strong, nonatomic)  UIButton * statButton;
@property(strong, nonatomic)  UIButton * backButton;
@property(strong, nonatomic)  UILabel *customLabel;
@property(nonatomic) int keyboardHeight;
@property(nonatomic)  BOOL keyboardIsVisible;
@property(nonatomic) int STEP;



@end
