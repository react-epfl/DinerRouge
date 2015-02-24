//
//  InequalityInfoViewController.h
//  DinerRouge
//
//  Created by Adrian Holzer on 17.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InequalityInfoViewController : UIViewController

-(IBAction)done:(id)sender;

@property(strong, nonatomic) IBOutlet UIButton * doneButton;
@property(strong, nonatomic) IBOutlet UILabel * titleView;
@property(strong, nonatomic) IBOutlet UITextView * giniInfo;
@property(strong, nonatomic) IBOutlet UITextView * incomeInfo;
@property(strong, nonatomic) IBOutlet UITextView * wealthInfo;
@property(strong, nonatomic) IBOutlet UILabel * whatLabel;
@property(strong, nonatomic) IBOutlet UILabel * howLabel;
@property(strong, nonatomic) IBOutlet UILabel * whoLabel;

@end
