//
//  YouViewController.m
//  DinerRouge
//
//  Created by Adrian Holzer on 26.02.15.
//  Copyright (c) 2015 Adrian Holzer. All rights reserved.
//

#import "YouViewController.h"
#import "GAI.h"
#import "InfoViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "BillManager.h"

#define DONE_BUTTON_WIDTH 80
#define SEND_BUTTON_PADDING 5
#define INPUTVIEW_HEIGHT 115
#define INPUT_LEFT_PADDING 10
#define INPUT_TOP_PADDING 5
#define INPUT_HEIGHT 30
#define SIDE_PADDING 15

@interface YouViewController ()

@end

@implementation YouViewController

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
    self.view.backgroundColor=[[BillManager sharedBillManager] maincolor];
    // instructionView.text=NSLocalizedString(@"INFO_HOW", nil) ;
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
    customLabel.backgroundColor= [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.textColor =  [[BillManager sharedBillManager] secondarycolor];
    navigationItem.titleView = customLabel;
    [customLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
    customLabel.text=[NSLocalizedString(@"Your table", nil) uppercaseString];
    self.giniLabel.text=[NSString stringWithFormat:@"%.f", [[[BillManager sharedBillManager] gini] floatValue] ];
    self.giniLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
    self.giniLabel.backgroundColor=[[BillManager sharedBillManager] buttoncolor];
    // BACK BUTTON
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[[BillManager sharedBillManager]backBoutonImage] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    [self.giniLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size: 65]];
    [self.whatLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
    [self.giniInfo setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    [self.distributionLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    [self.inequalityLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    [self.incomeInfo setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    
    // Go To Button
    UIButton * goToInequalityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToInequalityButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [goToInequalityButton setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    [goToInequalityButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    [goToInequalityButton.titleLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    [goToInequalityButton addTarget:self action:@selector(goToCountries:) forControlEvents:UIControlEventTouchUpInside];
    [goToInequalityButton setTitle:NSLocalizedString(@"SEE COUNTRIES", nil) forState:UIControlStateNormal];
    goToInequalityButton.frame = CGRectMake(SIDE_PADDING, self.view.frame.size.height-(INPUT_HEIGHT+SIDE_PADDING) , self.view.frame.size.width-(2*SIDE_PADDING) , INPUT_HEIGHT);
    goToInequalityButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:goToInequalityButton];
    
    
   // NSString* type = NSLocalizedString(@"INCOME", nil);
    
    self.whatLabel.text=NSLocalizedString(@"GINI", nil) ;
    self.whatLabel.backgroundColor= [[BillManager sharedBillManager] buttoncolor];
    self.whatLabel.textColor= [[BillManager sharedBillManager] buttonTextColor];
    self.giniInfo.text=[NSString stringWithFormat: NSLocalizedString(@"INFO_GINI", nil),[NSString stringWithFormat:@"%.f", [[[BillManager sharedBillManager] gini] floatValue]], [[Country inequalityWithGini:[[BillManager sharedBillManager] gini]] lowercaseString]];
   
    
    self.distributionLabel.text=  NSLocalizedString(@"TOTAL_INCOME_OF_THE_TABLE", nil);
    
    self.distributionLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];

    
    //Get the number of friends
    //for each friend give a size of a new component,
    //for each firend ga
    
    self.inequalityLabel.text=[country inequality:NSLocalizedString(@"INCOME", nil)];
     self.distributionView.backgroundColor= [[BillManager sharedBillManager] buttoncolor];
    self.inequalityLabel.textColor= [[BillManager sharedBillManager] buttonTextColor];
    long numberOfFriends=[[[BillManager sharedBillManager] friends] count];
    float friendNumber=1;
    float x=0;
    float totalIncome = [[[BillManager sharedBillManager] totalIncome] floatValue];
    self.incomeInfo.text=NSLocalizedString(@"TABLE_ONE_PERSON_ONLY_INFO", nil);
    self.incomeInfo.textColor= [[BillManager sharedBillManager] secondarycolor];
    self.giniInfo.textColor= [[BillManager sharedBillManager] secondarycolor];
    for (Friend* friend in [self sortedFriends]){
        UIView* friendView =  [[UIView alloc] initWithFrame:q5View.frame];
        CGRect frm = friendView.frame;
        frm.size.width= ([friend.income floatValue]/totalIncome)*q5View.frame.size.width;
        frm.origin.x=frm.origin.x+x;
        x+=frm.size.width;
        friendView.frame = frm;
        float alpha=0.8*(1-(friendNumber/numberOfFriends));
        [friendView setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:alpha]];
       
        [self.distributionView addSubview:friendView];

        if (friendNumber==2) {
             self.incomeInfo.text=[NSString stringWithFormat:  NSLocalizedString(@"TABLE_INFO", nil), [NSString stringWithFormat:@"%.f", ([friend.income floatValue]/totalIncome)*100]];
        }
        friendNumber++;
    }
    
    

}

- (void)goToCountries:(NSNotification*) notification{
    [self performSegueWithIdentifier:@"CountrySegue" sender:self];
}

-(NSArray*)sortedFriends{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"income" ascending:NO];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    return [[[[BillManager sharedBillManager] friends] mutableCopy] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[BillManager sharedBillManager] styleIsCommunist]) {
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Table Inequality Screen-C"];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    }else{
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Table Inequality Screen-NC"];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    }
}

@end