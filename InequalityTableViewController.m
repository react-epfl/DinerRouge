//
//  ProfileTableViewController.m
//
//  Created by Adrian Holzer on 20.12.11.
//  Copyright (c) 2012 Seance Association. All rights reserved.
//

#import "InequalityTableViewController.h"
#import "BillManager.h"
#import "Country.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "CountryViewController.h"

#define WEALTH 1
#define INCOME 0
#define COUNTRY 0
#define GINI 1
#define FontName @"AvenirNext-Bold"
#define MediumFontSize 18
#define SmallFontSize 12



@implementation InequalityTableViewController

@synthesize wealthCountryArray, incomeCountryArray,currentCountryArray, segmentedControl, sortSegmentedControl,countryTriangleView,giniTriangleView,fixedHeaderView,explanationLine;

#pragma mark - View lifecycle
//=========================
// LOAD VIEW
//=========================
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor whiteColor];
    
//    //setup nav bar title
//    UINavigationItem *navigationItem = [super navigationItem];
//    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
//    customLabel.backgroundColor= [UIColor clearColor];
//    customLabel.textAlignment = NSTextAlignmentCenter;
//    [customLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
//    customLabel.textColor =  [[BillManager sharedBillManager] secondarycolor];
//    navigationItem.titleView = customLabel;
//    customLabel.text=NSLocalizedString(@"INEQUALITY", nil);
    
    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    
    // SEGMENTED CONTROL
    [self.segmentedControl setTitle:NSLocalizedString(@"WEALTH", nil) forSegmentAtIndex:WEALTH];
    [self.segmentedControl setTitle:NSLocalizedString(@"INCOME", nil) forSegmentAtIndex:INCOME];
    [self.segmentedControl setSelectedSegmentIndex:WEALTH];// a small routine to avoid a weird color bug
    [self.segmentedControl setSelectedSegmentIndex:INCOME];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:15], NSFontAttributeName,
                                [[BillManager sharedBillManager] secondarycolor], NSForegroundColorAttributeName, nil  ];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], NSForegroundColorAttributeName, nil  ];
    [self.segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [[BillManager sharedBillManager] secondarycolor], NSForegroundColorAttributeName,
                                        [NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName, nil  ];
    [self.segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    self.navigationItem.titleView = segmentedControl;

    
    
    if (!wealthCountryArray) {
        wealthCountryArray = [self setupDataArrayWithName:@"oecd_wealth"];
        Country * anEqualCountry = [[Country alloc] initWithName:NSLocalizedString(@"Equal Country", nil) gini: [NSNumber numberWithInt:0] q1:[NSNumber numberWithInt:100] q2:[NSNumber numberWithInt:20] q3:[NSNumber numberWithInt:10] q4:[NSNumber numberWithInt:5] q5:[NSNumber numberWithInt:1]];
        [wealthCountryArray addObject:anEqualCountry];
        
    }
    if (!incomeCountryArray) {
        incomeCountryArray = [self setupDataArrayWithName:@"oecd_income"];
        Country * anEqualCountry = [[Country alloc] initWithName:NSLocalizedString(@"Equal Country", nil) gini: [NSNumber numberWithInt:0] q1:[NSNumber numberWithInt:20] q2:[NSNumber numberWithInt:20] q3:[NSNumber numberWithInt:20] q4:[NSNumber numberWithInt:20] q5:[NSNumber numberWithInt:20]];
        [incomeCountryArray addObject:anEqualCountry];
        if ([[BillManager sharedBillManager] gini]) {
            Country * myTableCountry = [[Country alloc] initWithName:NSLocalizedString(@"Your table", nil) gini:[[BillManager sharedBillManager] gini] q1:[[BillManager sharedBillManager] q1] q2:[[BillManager sharedBillManager] q2] q3:[[BillManager sharedBillManager] q3] q4:[[BillManager sharedBillManager] q4] q5:[[BillManager sharedBillManager] q5]];
            myTableCountry.isMyTable=YES;
            [incomeCountryArray addObject:myTableCountry];
        }
        
    }
    

    currentCountryArray = [incomeCountryArray mutableCopy];
    
    // SORT SEGMENTED CONTROL
    [self.sortSegmentedControl setTitle:NSLocalizedString(@"COUNTRY", nil) forSegmentAtIndex:COUNTRY];
    [self.sortSegmentedControl setTitle:NSLocalizedString(@"GINI", nil) forSegmentAtIndex:GINI];
    //self.sortSegmentedControl.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:FontName size:SmallFontSize], NSFontAttributeName,
                                [[BillManager sharedBillManager] secondarycolor], NSForegroundColorAttributeName, nil  ];
    [self.sortSegmentedControl setTitleTextAttributes:attributes2 forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], NSForegroundColorAttributeName, nil  ];
    [self.sortSegmentedControl setTitleTextAttributes:highlightedAttributes2 forState:UIControlStateHighlighted];
    NSDictionary *selectedAttributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [[BillManager sharedBillManager] secondarycolor], NSForegroundColorAttributeName,
                                        [NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName, nil  ];
    [self.sortSegmentedControl setTitleTextAttributes:selectedAttributes2 forState:UIControlStateSelected];
    [self sort];
    

    
    /// FixedHeaderView
    self.fixedHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,65)];
    self.fixedHeaderView.backgroundColor = [[BillManager sharedBillManager] maincolor];
    [self.view addSubview:fixedHeaderView];
    [self.fixedHeaderView addSubview:self.blackBottomView];
    //[self.fixedHeaderView addSubview:self.sortSegmentedControl];
    //[self.fixedHeaderView addSubview:self.segmentedControl];
    [self.fixedHeaderView addSubview:self.countryTriangleView];
    [self.fixedHeaderView addSubview:self.giniTriangleView];
    [self.fixedHeaderView addSubview:self.leftRedLineView];
    [self.fixedHeaderView addSubview:self.topRedLineView];
    [self.fixedHeaderView addSubview:self.rightRedLine];
    self.explanationLine.text=NSLocalizedString(@"EXPLANATION", nil);
    [self.fixedHeaderView addSubview:self.explanationLine];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self placeInputView];
}

- (void)placeInputView{
    CGRect newFrame = fixedHeaderView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y;//+(self.tableView.frame.size.height-fixedHeaderView.frame.size.height);
    fixedHeaderView.frame = newFrame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self sort];
    [self placeInputView]; // need this since view did load does not correctly calculate the size of the screen
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Inequality Screen"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// HANDLES SECTIONS AND ROWS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentCountryArray==nil){
        return 0;
    }
    return [self.currentCountryArray count];
}

// LOADS DATA
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Country* country = [self getCountryForIndex:[indexPath row]];
    
    
    NSString *CellIdentifier = @"DistributionCell";
    if(self.segmentedControl.selectedSegmentIndex==WEALTH){
        CellIdentifier = @"DistributionWealthCell";
    }
    if (country.isMyTable) {
        CellIdentifier = @"MyTableCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:1];
    numberLabel.text=[NSString stringWithFormat:@"%ld", indexPath.row+1];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
    nameLabel.text=country.name;
    UILabel *giniLabel = (UILabel *)[cell viewWithTag:3];
    giniLabel.text= [NSString stringWithFormat:@"%.f%%", [country.gini floatValue] ] ;
    
    UIView *q1View = (UILabel *)[cell viewWithTag:5];
    UIView *q2View = (UILabel *)[cell viewWithTag:6];
    UIView *q3View = (UILabel *)[cell viewWithTag:7];
    UIView *q4View = (UILabel *)[cell viewWithTag:8];
    UIView *q5View = (UILabel *)[cell viewWithTag:9];
    
    
    if(self.segmentedControl.selectedSegmentIndex==INCOME){
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

    
    return cell;
}

// GET MESSAGE FOR INDEX
-(Country*)getCountryForIndex:(NSInteger)index{
    if ([self.currentCountryArray count]>0){
        return (Country  *)[self.currentCountryArray objectAtIndex:index];
    }
    return nil;
}


-(IBAction)sort:(id)sender{
    [self sort];
}


-(void)sort{
    NSInteger selectedSegment = self.sortSegmentedControl.selectedSegmentIndex;
    NSSortDescriptor *sortDescriptor;
    if (selectedSegment == COUNTRY) {
            self.countryTriangleView.hidden=YES;//NO
            self.giniTriangleView.hidden=YES;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    }else if(selectedSegment == GINI){
        self.countryTriangleView.hidden=YES;
        self.giniTriangleView.hidden=YES;//NO
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gini" ascending:YES];
    }
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [currentCountryArray sortedArrayUsingDescriptors:sortDescriptors];
    currentCountryArray=[sortedArray mutableCopy];
    [self.tableView reloadData];
}


-(IBAction)changeType:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    NSInteger selectedSegment = seg.selectedSegmentIndex;
    if (selectedSegment == WEALTH) {
        currentCountryArray= [wealthCountryArray mutableCopy];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_wealth" value:nil] build]];
    }else if(selectedSegment == INCOME){
        currentCountryArray = [incomeCountryArray mutableCopy];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_income" value:nil] build]];
    }
    [self sort];
    [self.tableView reloadData];
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:myIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}



- (NSMutableArray*) setupDataArrayWithName:(NSString*) filename{
    NSMutableArray* countryArray = [NSMutableArray array];
    NSString * myFile = [[NSBundle mainBundle]pathForResource:filename ofType:@""];
    NSError *error = nil;
    NSString *file = [NSString stringWithContentsOfFile:myFile encoding: NSUTF8StringEncoding error:&error];
    NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString* line in allLines) {
        NSArray *elements = [line componentsSeparatedByString:@";"];

        if ([elements count]>1) {
            Country * country;
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * giniNumber = [f numberFromString:elements[1]];
            if ([elements count]<7) {
                country = [[Country alloc] initWithName:elements[0] gini:giniNumber];
            }else{
            country = [[Country alloc] initWithName:elements[0] gini:[f numberFromString:elements[1]] q1:[f numberFromString:elements[2]] q2:[f numberFromString:elements[3]] q3:[f numberFromString:elements[4]] q4:[f numberFromString:elements[5]] q5:[f numberFromString:elements[6]]];
            }
            [countryArray addObject:country];
        }
    }
    return countryArray;
}

-(IBAction)customBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"IncomeToCountrySegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        NSUInteger row = [indexPath row];
        CountryViewController *mvc = (CountryViewController *)[segue destinationViewController];
        [mvc setCountry:[self.currentCountryArray objectAtIndex:row]];
        [mvc setIsIncome:YES];
    }
    if ([[segue identifier] isEqualToString:@"WealthToCountrySegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        NSUInteger row = [indexPath row];
        CountryViewController *mvc = (CountryViewController *)[segue destinationViewController];
        [mvc setCountry:[self.currentCountryArray objectAtIndex:row]];
        [mvc setIsIncome:NO];
    }
}


@end
