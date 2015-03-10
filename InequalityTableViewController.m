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

@synthesize wealthCountryArray, incomeCountryArray,currentCountryArray, segmentedControl, countryBySectionArray, sortSegmentedControl,countryTriangleView,giniTriangleView,fixedHeaderView,explanationLine;

#pragma mark - View lifecycle
//=========================
// LOAD VIEW
//=========================
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor=[[BillManager sharedBillManager] maincolor];
    
    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[[BillManager sharedBillManager]backBoutonImage] forState:UIControlStateNormal];
    [newBackButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
    
    // SEGMENTED CONTROL
    [self.segmentedControl setTitle:NSLocalizedString(@"WEALTH", nil) forSegmentAtIndex:WEALTH];
    [self.segmentedControl setTitle:NSLocalizedString(@"INCOME", nil) forSegmentAtIndex:INCOME];
    [self.segmentedControl setSelectedSegmentIndex:WEALTH];// a small routine to avoid a weird color bug
    [self.segmentedControl setSelectedSegmentIndex:INCOME];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:19], NSFontAttributeName,
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
     self.explanationLine.font = [UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:14];
    self.explanationLine.textColor = [[BillManager sharedBillManager] secondarycolor];
    self.explanationLine.text=NSLocalizedString(@"EXPLANATION", nil);
    
 
    
    
    
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


- (void)viewWillAppear:(BOOL)animated
{
    [self sort];
    [self placeInputView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self sort];
    [self placeInputView]; // need this since view did load does not correctly calculate the size of the screen
    
    if ([[BillManager sharedBillManager] styleIsCommunist]) {
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Inequality Table Screen-C"];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    }else{
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Inequality Table Screen-NC"];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfSections=0;
    int j=-1;
    for (int i= 0; i<=100 ; i=i+10) {
         int numberOfCountriesInSection=0;
        for (Country* country in currentCountryArray) {
            if ([country.gini intValue]<=i && [country.gini intValue]>j) {
                numberOfCountriesInSection++;
            }
        }
        if (numberOfCountriesInSection>0) {
            numberOfSections++;
        }
        j=i;
    }
    NSLog(@"NumberOfSections %d", numberOfSections);
    return numberOfSections;
}

// HANDLES SECTIONS AND ROWS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //[self sort];
    int sectionNumber=-1;
    int j=-1;
    for (int i= 0; i<=100 ; i=i+10) {
        int numberOfCountriesInSection=0;
        for (Country* country in currentCountryArray) {
            if ([country.gini intValue]<=i && [country.gini intValue]>j) {
                numberOfCountriesInSection++;
            }
        }
        if (numberOfCountriesInSection>0) {
            sectionNumber++;
            if (sectionNumber==section ) {
                return numberOfCountriesInSection;
            }
        }
        j=i;
    }
    return nil;
}



// LOADS DATA
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Country* country = [self countryForIndexPath:indexPath];
    
    
    //Country* country = [self getCountryForIndex:[indexPath row]];
    
    
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
    numberLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
    numberLabel.text=[NSString stringWithFormat:@"%d", [self countryRankingForIndexPath:indexPath ]];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
    nameLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
    nameLabel.text=country.name;
    UILabel *giniLabel = (UILabel *)[cell viewWithTag:3];
    giniLabel.text= [NSString stringWithFormat:@"%.f", [country.gini floatValue] ] ;
    giniLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
    
    [numberLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    [nameLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
     [giniLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]]];
    
    cell.backgroundColor=[[BillManager sharedBillManager] buttoncolor];
    
    UIView *q1View = (UIView *)[cell viewWithTag:5];
    UIView *q2View = (UIView *)[cell viewWithTag:6];
    UIView *q3View = (UIView *)[cell viewWithTag:7];
    UIView *q4View = (UIView *)[cell viewWithTag:8];
    UIView *q5View = (UIView *)[cell viewWithTag:9];
    
    UIView *redL = (UIView *)[cell viewWithTag:12];
    UIView *redR = (UIView *)[cell viewWithTag:13];
    redL.backgroundColor=[[BillManager sharedBillManager] maincolor];
    redR.backgroundColor=[[BillManager sharedBillManager] maincolor];
    
    self.segmentedControl.tintColor=[[BillManager sharedBillManager] maincolor];
    
    if(self.segmentedControl.selectedSegmentIndex==INCOME){
        CGRect frm = q1View.frame;
        float width = q5View.frame.size.width*[country.q5 floatValue]/100;
        frm.size.width = width;
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
        NSLog(@"%@ %.f %.f",country.name, [country.q1 floatValue], q1View.frame.size.width);
    }else{
        CGRect frm = q2View.frame;
        frm.size.width = q1View.frame.size.width*[country.q5 floatValue]/100;
        q2View.frame = frm;
        frm = q3View.frame;
        frm.size.width = q1View.frame.size.width*[country.q4 floatValue]/100;
        q3View.frame = frm;
        frm = q4View.frame;
        frm.size.width = q1View.frame.size.width*[country.q3 floatValue]/100;
        q4View.frame = frm;
        frm = q5View.frame;
        frm.size.width = q1View.frame.size.width*[country.q2 floatValue]/100;
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
    NSSortDescriptor *sortDescriptor;
   // if (selectedSegment == COUNTRY) {
     //       self.countryTriangleView.hidden=YES;//NO
       //     self.giniTriangleView.hidden=YES;
       // sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //}else if(selectedSegment == GINI){
        self.countryTriangleView.hidden=YES;
        self.giniTriangleView.hidden=YES;//NO
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gini" ascending:YES];
    //}
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
        
        if ([[BillManager sharedBillManager] styleIsCommunist]) {
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_wealth-C" value:nil] build]];
        }else{
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_wealth-NC" value:nil] build]];
        }
    }else if(selectedSegment == INCOME){
        currentCountryArray= [incomeCountryArray mutableCopy];
        
        if ([[BillManager sharedBillManager] styleIsCommunist]) {
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_income-C" value:nil] build]];
        }else{
            [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"change_to_income-NC" value:nil] build]];
        }
        
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
        //NSUInteger row = [indexPath row];
        CountryViewController *mvc = (CountryViewController *)[segue destinationViewController];
        [mvc setCountry:[self countryForIndexPath:indexPath]];
        [mvc setIsIncome:YES];
    }
    if ([[segue identifier] isEqualToString:@"WealthToCountrySegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
        //NSUInteger row = [indexPath row];
        CountryViewController *mvc = (CountryViewController *)[segue destinationViewController];
        //[mvc setCountry:[self.currentCountryArray objectAtIndex:row]];
        [mvc setCountry:[self countryForIndexPath:indexPath]];
        [mvc setIsIncome:NO];
    }
}

// CUSTOM SECTION HEADER
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString*sectionHeaderName;
    NSString* type=@"WEALTH";
    if(self.segmentedControl.selectedSegmentIndex==INCOME){
        type= @"INCOME";
        
    }
    int sectionNumber=-1;
    int j=-1;
    for (int i= 0; i<=100 ; i=i+10) {
        int countryNumberInSection=-1;
        for (Country* c in currentCountryArray) {
            if ([c.gini intValue]<=i && [c.gini intValue]>j) {
                countryNumberInSection++;
                if ((sectionNumber+1)==section){
                     sectionHeaderName=[c inequalityTitle];
                }
            }
        }
        if (countryNumberInSection>=0) {
            sectionNumber++;
        }
        j=i;
    }
    
    UIView *sectionHeaderView = [[UIView alloc] init];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 400, 30)];
    sectionHeader.backgroundColor =  [[BillManager sharedBillManager] maincolor];
    sectionHeaderView.backgroundColor =  [[BillManager sharedBillManager] maincolor];
    sectionHeader.textColor = [[BillManager sharedBillManager] secondarycolor];
    sectionHeader.font = [UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] smallFont]];
    sectionHeader.text = sectionHeaderName;
    [sectionHeaderView addSubview:sectionHeader];
    return sectionHeaderView;
}

-(Country*)countryForIndexPath:(NSIndexPath *)indexPath{
    int sectionNumber=-1;
    int j=-1;
    for (int i= 0; i<=100 ; i=i+10) {
        int countryNumberInSection=-1;
        for (Country* c in currentCountryArray) {
            if ([c.gini intValue]<=i && [c.gini intValue]>j) {
                countryNumberInSection++;
                if ((sectionNumber+1)==indexPath.section&&countryNumberInSection==indexPath.row){
                    return c;
                }
            }
        }
        if (countryNumberInSection>=0) {
            sectionNumber++;
        }
        j=i;
    }
    return nil;
}

-(int)countryRankingForIndexPath:(NSIndexPath *)indexPath{
    int ranking=0;
    int sectionNumber=-1;
    int j=-1;
    for (int i= 0; i<=100 ; i=i+10) {
        int countryNumberInSection=-1;
        for (Country* c in currentCountryArray) {
            if ([c.gini intValue]<=i && [c.gini intValue]>j) {
                countryNumberInSection++;
                ranking++;
                if ((sectionNumber+1)==indexPath.section&&countryNumberInSection==indexPath.row){
                    return ranking;
                }
            }
        }
        if (countryNumberInSection>=0) {
            sectionNumber++;
        }
        j=i;
    }
    return 0;
}


@end
