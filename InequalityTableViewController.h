//
//  ProfileTableViewController.h
//  SpeakUp
//
//  Created by Adrian Holzer on 20.12.11.
//  Copyright (c) 2012 Seance Association. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InequalityTableViewController : UITableViewController<UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property(strong, nonatomic) IBOutlet UISegmentedControl* segmentedControl ;
@property(strong, nonatomic) IBOutlet UISegmentedControl* sortSegmentedControl ;
@property(strong, nonatomic) IBOutlet UIImageView* countryTriangleView ;
@property(strong, nonatomic) IBOutlet UIImageView* giniTriangleView ;
@property(strong, nonatomic) IBOutlet UIView* topRedLineView ;
@property(strong, nonatomic) IBOutlet UIView* leftRedLineView ;
@property(strong, nonatomic) IBOutlet UIView* blackBottomView ;
@property(strong, nonatomic) IBOutlet UIView* fixedHeaderView ;
@property(strong, nonatomic) IBOutlet UIView* rightRedLine ;
@property(strong, nonatomic) IBOutlet UITextView* explanationLine ;
@property(strong, nonatomic)  NSMutableArray * wealthCountryArray;
@property(strong, nonatomic)  NSMutableArray * incomeCountryArray;
@property(strong, nonatomic)  NSMutableArray * currentCountryArray;
@property(strong, nonatomic)  NSMutableDictionary* countryBySectionArray;


@end
