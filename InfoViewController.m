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
    instructionView.text=NSLocalizedString(@"INFO_HOW", nil) ;
    titleView.text=NSLocalizedString(@"INFO_WHAT", nil) ;
    creditView.text=NSLocalizedString(@"INFO_WHO", nil) ;
    whoLabel.text=NSLocalizedString(@"WHO", nil) ;
    whatLabel.text=NSLocalizedString(@"WHAT", nil) ;
    howLabel.text=NSLocalizedString(@"HOW", nil) ;
    
    [doneButton setTitle:NSLocalizedString(@"DONE_BUTTON", nil) forState:UIControlStateNormal];
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
