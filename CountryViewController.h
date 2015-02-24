//
//  CountryVewController.h
//  DinerRouge
//
//  Created by Adrian Holzer on 24.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Country.h"
#import <UIKit/UIKit.h>

@interface CountryViewController : UIViewController


@property(strong, nonatomic) IBOutlet UITextView * creditView;
@property(strong, nonatomic) IBOutlet UILabel * giniLabel;
@property(strong, nonatomic) IBOutlet UIView * q1View;
@property(strong, nonatomic) IBOutlet UIView * q2View;
@property(strong, nonatomic) IBOutlet UIView * q3View;
@property(strong, nonatomic) IBOutlet UIView * q4View;
@property(strong, nonatomic) IBOutlet UIView * q5View;

@property(strong, nonatomic) IBOutlet UILabel * titleView;
@property(strong, nonatomic) IBOutlet UITextView * giniInfo;
@property(strong, nonatomic) IBOutlet UITextView * incomeInfo;
@property(strong, nonatomic) IBOutlet UITextView * wealthInfo;
@property(strong, nonatomic) IBOutlet UILabel * whatLabel;
@property(strong, nonatomic) IBOutlet UILabel * howLabel;
@property(strong, nonatomic) IBOutlet UILabel * whoLabel;
@property(strong, nonatomic) IBOutlet UILabel * inequalityLabel;

@property(strong, nonatomic) Country * country;
@property(nonatomic) BOOL isIncome;

@end
