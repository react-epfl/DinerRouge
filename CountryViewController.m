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

@synthesize q1View, q2View, q3View, q4View, q5View,q2ViewIndicator, q3ViewIndicator, q4ViewIndicator, q5ViewIndicator, country,distributionView,distributionLabel,q2ViewIndicatorLabel, q3ViewIndicatorLabel, q4ViewIndicatorLabel, q5ViewIndicatorLabel;

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
    self.giniLabel.text=[NSString stringWithFormat:@"%.f", [self.country.gini floatValue] ];

    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    //check if the q5 exists
    NSString* pourcentString=@"1";
    float value = [country.q5 intValue];
    if (value == 0) {
        pourcentString=@"5";
        value = [country.q4 intValue];
    }if (value == 0) {
        pourcentString=@"10";
        value = [country.q3 intValue];
    }if (value == 0) {
        pourcentString=@"20";
        value = [country.q2 intValue];
    }
    
    self.wealthInfo.text=[NSString stringWithFormat:  NSLocalizedString(@"WEALTH_INFO", nil), pourcentString,[NSString stringWithFormat:@"%.f",value]]   ;
    NSString* type = NSLocalizedString(@"WEALTH", nil);
    if(self.isIncome){
        type = NSLocalizedString(@"INCOME", nil);
    }
    self.whatLabel.text=NSLocalizedString(@"GINI", nil) ;
    self.giniInfo.text=[NSString stringWithFormat: NSLocalizedString(@"INFO_GINI", nil),[NSString stringWithFormat:@"%.f", [self.country.gini floatValue]], [[country inequality:NSLocalizedString(type , nil)] lowercaseString]];
    self.incomeInfo.text=[NSString stringWithFormat:  NSLocalizedString(@"INCOME_INFO", nil), [NSString stringWithFormat:@"%.f", [country.q5 floatValue]],[NSString stringWithFormat:@"%.f", [country.q1 floatValue]]]   ;
    self.distributionLabel.text= [[NSString stringWithFormat:  NSLocalizedString(@"DISTRIBUTION_LABEL", nil),  NSLocalizedString(type, nil),  NSLocalizedString(self.country.name, nil)]  uppercaseString];

    if(self.isIncome){
         self.inequalityLabel.text=[country inequality:NSLocalizedString(@"INCOME", nil)];
        CGRect frm = q1View.frame;
        frm.size.width = q5View.frame.size.width*[country.q5 floatValue]/100;
        q1View.frame = frm;
        frm = q2View.frame;
        frm.size.width = q5View.frame.size.width*[country.q4 floatValue]/100;
        frm.origin.x=q1View.frame.origin.x+q1View.frame.size.width;
        q2View.frame = frm;
        frm = q3View.frame;
        frm.size.width = q5View.frame.size.width*[country.q3 floatValue]/100;
        frm.origin.x=q2View.frame.origin.x+q2View.frame.size.width;
        q3View.frame = frm;
        frm = q4View.frame;
        frm.size.width = q5View.frame.size.width*[country.q2 floatValue]/100;
        frm.origin.x=q3View.frame.origin.x+q3View.frame.size.width;
        q4View.frame = frm;

    }else{
         self.inequalityLabel.text=[country inequality:NSLocalizedString(@"WEALTH", nil)];
        CGRect frm = q2View.frame;
        frm.size.width = q1View.frame.size.width*[country.q2 floatValue]/100;
        q2View.frame = frm;
        frm = q3View.frame;
        frm.size.width = q1View.frame.size.width*[country.q3 floatValue]/100;
        q3View.frame = frm;
        frm = q4View.frame;
        frm.size.width = q1View.frame.size.width*[country.q4 floatValue]/100;
        q4View.frame = frm;
        frm = q5View.frame;
        frm.size.width = q1View.frame.size.width*[country.q5 floatValue]/100;
        q5View.frame = frm;
        
        frm = q2ViewIndicator.frame;
        frm.origin.x=q2View.frame.origin.x+q2View.frame.size.width-1;
        q2ViewIndicator.frame=frm;
        frm = q3ViewIndicator.frame;
        frm.origin.x=q3View.frame.origin.x+q3View.frame.size.width-1;
        q3ViewIndicator.frame=frm;
        frm = q4ViewIndicator.frame;
        frm.origin.x=q4View.frame.origin.x+q4View.frame.size.width-1;
        q4ViewIndicator.frame=frm;
        frm = q5ViewIndicator.frame;
        frm.origin.x=q5View.frame.origin.x+q5View.frame.size.width-1;
        q5ViewIndicator.frame=frm;

        q2ViewIndicatorLabel.text=NSLocalizedString(@"The richest 20%", nil);
        q3ViewIndicatorLabel.text=NSLocalizedString(@"The richest 10%", nil);
        q4ViewIndicatorLabel.text=NSLocalizedString(@"The richest 5%", nil);
        q5ViewIndicatorLabel.text=NSLocalizedString(@"The 1%", nil);
        
        if ([country.q2 intValue] == 0) {
            [q2ViewIndicator setHidden:YES];
            [q2ViewIndicatorLabel setHidden:YES];
        }
        if ([country.q3 intValue] == 0) {
            [q3ViewIndicator setHidden:YES];
            [q3ViewIndicatorLabel setHidden:YES];
        }
        if ([country.q4 intValue] == 0) {
            [q4ViewIndicator setHidden:YES];
            [q4ViewIndicatorLabel setHidden:YES];
        }
        if ([country.q5 intValue] == 0) {
            [q5ViewIndicator setHidden:YES];
            [q5ViewIndicatorLabel setHidden:YES];
        }
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