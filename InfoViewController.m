//
//  InfoViewController.m
//  DinerRouge
//
//  Created by Adrian Holzer on 22.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "GAI.h"
#import "InfoViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "BillManager.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize doneButton, creditView, titleView, instructionView, whatLabel, whoLabel, howLabel;

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
    self.view.backgroundColor=[[BillManager sharedBillManager] maincolor];
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
    customLabel.backgroundColor= [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    [customLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
    customLabel.text = NSLocalizedString(@"INFORMATION", nil);
    customLabel.textColor =  [[BillManager sharedBillManager] secondarycolor];
    navigationItem.titleView = customLabel;
    
    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController  action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    instructionView.text=NSLocalizedString(@"INFO_HOW", nil) ;
    creditView.text=NSLocalizedString(@"INFO_WHO", nil) ;
    instructionView.textColor=[[BillManager sharedBillManager] secondarycolor];
    creditView.textColor=[[BillManager sharedBillManager] secondarycolor];
    
    [doneButton setTitle:NSLocalizedString(@"STATS", nil) forState:UIControlStateNormal];
    [self.instructionView setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    [self.creditView setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    doneButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [doneButton  setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    
	//[doneButton setImage:[UIImage imageNamed:@"bouton_done_2.png" ] forState:UIControlStateHighlighted];
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


-(IBAction)done:(id)sender{
    NSLog(@"done");
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)goToWebSite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.dinerrouge.com"]];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"go_to_website" value:nil] build]];
}

@end
