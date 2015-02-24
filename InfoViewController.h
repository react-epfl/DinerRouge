//
//  InfoViewController.h
//  DinerRouge
//
//  Created by Adrian Holzer on 22.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "GAITrackedViewController.h"
#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController 

-(IBAction)done:(id)sender;
-(IBAction)goToWebSite;


@property(strong, nonatomic) IBOutlet UIButton * doneButton;
@property(strong, nonatomic) IBOutlet UILabel * titleView;
@property(strong, nonatomic) IBOutlet UITextView * instructionView;
@property(strong, nonatomic) IBOutlet UITextView * creditView;
@property(strong, nonatomic) IBOutlet UILabel * whatLabel;
@property(strong, nonatomic) IBOutlet UILabel * howLabel;
@property(strong, nonatomic) IBOutlet UILabel * whoLabel;

@end
