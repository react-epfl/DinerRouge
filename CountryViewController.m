//
//  CountryVewController.m
//  DinerRouge
//
//  Created by Adrian Holzer on 24.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//
#import "GAI.h"
#import "InfoViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "CountryViewController.h"

@implementation CountryViewController

@synthesize q1View, q2View, q3View, q4View, q5View, country;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // instructionView.text=NSLocalizedString(@"INFO_HOW", nil) ;
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
    customLabel.backgroundColor= [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    [customLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:22]];
    customLabel.textColor =  [UIColor colorWithRed:220.0/255.0 green:210.0/255.0 blue:178.0/255.0 alpha:1.0];
    navigationItem.titleView = customLabel;
    customLabel.text=[self.country.name uppercaseString];
    self.giniLabel.text=[NSString stringWithFormat:@"%.f%%", [self.country.gini floatValue] ];

    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    self.whatLabel.text=NSLocalizedString(@"GINI", nil) ;
    self.giniInfo.text=NSLocalizedString(@"INFO_GINI", nil) ;
    self.incomeInfo.text=NSLocalizedString(@"INCOME_INFO", nil) ;
    self.wealthInfo.text=NSLocalizedString(@"WEALTH_INFO", nil) ;
    

    if(self.isIncome){
         self.inequalityLabel.text=[country inequality:NSLocalizedString(@"INCOME", nil)];
        CGRect frm = q1View.frame;
        frm.size.width = q5View.frame.size.width*[country.q1 floatValue]/100;
        q1View.frame = frm;
        frm = q2View.frame;
        frm.size.width = q5View.frame.size.width*[country.q2 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width;
        q2View.frame = frm;
        frm = q3View.frame;
        frm.size.width = q5View.frame.size.width*[country.q3 floatValue]/100;
        frm.origin.x=q2View.frame.origin.x+q2View.frame.size.width;
        q3View.frame = frm;
        frm = q4View.frame;
        frm.size.width = q5View.frame.size.width*[country.q4 floatValue]/100;
        frm.origin.x=q3View.frame.origin.x+q3View.frame.size.width;
        q4View.frame = frm;
    }else{
         self.inequalityLabel.text=[country inequality:NSLocalizedString(@"WEALTH", nil)];
        CGRect frm = q2View.frame;
        frm.size.width = q1View.frame.size.width*[country.q2 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width-frm.size.width;
        q2View.frame = frm;
        frm = q3View.frame;
        frm.size.width = q1View.frame.size.width*[country.q3 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width-frm.size.width;
        q3View.frame = frm;
        frm = q4View.frame;
        frm.size.width = q1View.frame.size.width*[country.q4 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width-frm.size.width;
        q4View.frame = frm;
        frm = q5View.frame;
        frm.size.width = q1View.frame.size.width*[country.q5 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width-frm.size.width;
        q5View.frame = frm;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Info Screen"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

@end