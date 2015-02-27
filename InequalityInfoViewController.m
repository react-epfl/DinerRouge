//
//  InequalityInfoViewController.m
//  DinerRouge
//
//  Created by Adrian Holzer on 17.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "InequalityInfoViewController.h"

@interface InequalityInfoViewController ()

@end

@implementation InequalityInfoViewController

@synthesize doneButton, giniInfo, titleView, incomeInfo, wealthInfo, whatLabel, whoLabel, howLabel;

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
    whatLabel.text=NSLocalizedString(@"GINI", nil) ;
    giniInfo.text=NSLocalizedString(@"INFO_GINI", nil) ;
    incomeInfo.text=NSLocalizedString(@"INCOME_INFO", nil) ;
    wealthInfo.text=NSLocalizedString(@"WEALTH_INFO", nil) ;
    
    [doneButton setTitle:NSLocalizedString(@"DONE_BUTTON", nil) forState:UIControlStateNormal];
    //[doneButton setImage:[UIImage imageNamed:@"bouton_done_2.png" ] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Inequality Info Screen"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

-(IBAction)done:(id)sender{
    NSLog(@"done");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
