//
//  FriendCollectionViewController.m
//  PayPerPay
//
//  Created by Adrian Holzer on 18.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "FriendCollectionViewController.h"
#import "EditFriendViewController.h"
#import "BillManager.h"
#import "FriendCollectionViewCell.h"
#import "Friend.h"
#import "ReusableHeaderView.h"
#import "ReusableFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import "CountryViewController.h"

#define DONE_BUTTON_WIDTH 80
#define SEND_BUTTON_PADDING 5
#define INPUTVIEW_HEIGHT 50
#define INPUT_LEFT_PADDING 10
#define INPUT_TOP_PADDING 5
#define INPUT_HEIGHT 30
#define SIDE_PADDING 15

@interface FriendCollectionViewController ()



@end

@implementation FriendCollectionViewController


@synthesize totalAmountTextField,inputView,addFriendDoneButton,keyboardHeight,backButton,customLabel,keyboardIsVisible,STEP,amountDoneButton, amountLabel, amountTextField, statButton, tutorialTextView ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Home Screen"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
     [self placeInputView];
}


-(void)viewWillAppear:(BOOL)animated{
    [[self collectionView] reloadData];
    [self placeInputView];
    if ([[[BillManager sharedBillManager] friends] count]>0 && STEP==STEP0) {
        STEP=STEP1;
        [self placeInputView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.STEP = STEP0;
    [self.navigationController.navigationBar setBarTintColor:[[BillManager sharedBillManager] maincolor]];
    //self.navigationItem.titleView.backgroundColor = [[BillManager sharedBillManager] maincolor];
    
       // self.navigationController.navigationBar.tintColor = [[BillManager sharedBillManager] maincolor];
    self.collectionView.backgroundColor=[[BillManager sharedBillManager] maincolor];
    
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    self.customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    self.customLabel.backgroundColor= [UIColor clearColor];
    self.customLabel.textAlignment = NSTextAlignmentCenter;
    [self.customLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
    self.customLabel.adjustsFontSizeToFitWidth = YES;
    [self.customLabel setMinimumScaleFactor:0.2f];
    self.customLabel.textColor =  [[BillManager sharedBillManager] secondarycolor];
    navigationItem.titleView = self.customLabel;
    self.customLabel.text=@"DINER ROUGE";
    
    self.keyboardIsVisible=NO;
    self.keyboardHeight=0;
    
    
    // INPUT VIEW
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0,self.collectionView.contentOffset.y+(self.collectionView.frame.size.height-INPUTVIEW_HEIGHT),self.view.frame.size.width,INPUTVIEW_HEIGHT)];
    self.inputView.backgroundColor = [[BillManager sharedBillManager] maincolor];
    [self.view addSubview:inputView];

    
    // TUTORIAL TEXT VIEW
    self.tutorialTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,250,self.view.frame.size.width,500)];
    self.tutorialTextView.backgroundColor = [[BillManager sharedBillManager] maincolor];
    [self.tutorialTextView setTextColor: [[BillManager sharedBillManager] secondarycolor]];
    [self.tutorialTextView setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    [self.tutorialTextView setEditable:NO];
    self.tutorialTextView.text=@"SPLIT THE BILL BY INCOME \n1) ADD FRIENDS \n2) ENTER AMOUNT TO PAY \n3) REVEAL SPLIT \n4) SEE STATISTICS \n5) DISCUSS INEQUALITY";
    [self.view addSubview:tutorialTextView];
    
    // STATISTICS BUTTON
    self.statButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.statButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [self.statButton setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    [self.statButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.statButton.titleLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    [self.statButton addTarget:self action:@selector(seeStatistics:) forControlEvents:UIControlEventTouchUpInside];
    [self.statButton setTitle:NSLocalizedString(@"SEE INEQUALITY", nil) forState:UIControlStateNormal];
    self.statButton.frame = CGRectMake(SIDE_PADDING, INPUT_TOP_PADDING , self.view.frame.size.width-(2*SIDE_PADDING) , INPUT_HEIGHT);
    self.statButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.inputView addSubview:statButton];
    
    // ADD FRIEND BUTTON
    self.addFriendDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addFriendDoneButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [self.addFriendDoneButton setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    [self.addFriendDoneButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.addFriendDoneButton.titleLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    [self.addFriendDoneButton addTarget:self action:@selector(addFriendDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.addFriendDoneButton setTitle:NSLocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    self.addFriendDoneButton.frame = CGRectMake(SIDE_PADDING, INPUT_TOP_PADDING , self.view.frame.size.width-(2*SIDE_PADDING) , INPUT_HEIGHT);
    self.addFriendDoneButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.inputView addSubview:addFriendDoneButton];
    
    //AMOUNT FIELD
    self.amountTextField = [[UITextField alloc] init];
    self.amountTextField.backgroundColor=[UIColor whiteColor];
    self.amountTextField.frame= CGRectMake(SIDE_PADDING, INPUT_TOP_PADDING , self.view.frame.size.width-(3*SIDE_PADDING+DONE_BUTTON_WIDTH) , INPUT_HEIGHT);
    [self.amountTextField setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    self.amountTextField.placeholder=NSLocalizedString(@"CHECK_FIELD_PLACEHOLDER", nil);
    [self.amountTextField setClearButtonMode:UITextFieldViewModeAlways];
    self.amountTextField.textAlignment= NSTextAlignmentRight;
    [self.amountTextField setDelegate:self];
    [self.amountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.inputView addSubview:amountTextField];
    
    // AMOUNT DONE BUTTON
    self.amountDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.amountDoneButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [self.amountDoneButton setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    [self.amountDoneButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.amountDoneButton.titleLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] mediumFont]]];
    [self.amountDoneButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.amountDoneButton setTitle:NSLocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    self.amountDoneButton.frame = CGRectMake(self.amountTextField.frame.size.width+ 2*SIDE_PADDING, INPUT_TOP_PADDING , DONE_BUTTON_WIDTH , INPUT_HEIGHT);
    self.amountDoneButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.inputView addSubview:amountDoneButton];
    
    // BACK BUTTON START
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreviousStep:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // MANAGE KEYBOARD
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];
    [self placeInputView];
}

- (void)addFriendDone: (NSNotification*) notification{
    STEP=STEP2;
    [[self collectionView] reloadData];
    [self placeInputView];
}

- (void)seeStatistics:(NSNotification*) notification{
    [self performSegueWithIdentifier:@"InequalitySegue" sender:self];
}

- (void)backToPreviousStep:(NSNotification*) notification{
    if (self.STEP==STEP1) {
        [self resetDinerRouge];
    }
    if (self.STEP>STEP1) {
        self.STEP--;
        [[self collectionView] reloadData];
        [self placeInputView];
    }
    if (self.STEP<STEP3) {
        self.customLabel.text=@"DINER ROUGE";
    }
}

-(IBAction) okPressed:(NSNotification*) notification{
    self.customLabel.text =[[BillManager sharedBillManager] totalAmountString];
    STEP=STEP3;
    [[BillManager sharedBillManager] reveal];
    [[self collectionView] reloadData];
    [self placeInputView];
    [[BillManager sharedBillManager] checkOut];
    [self.amountTextField resignFirstResponder];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"ok_amount" value:nil] build]];
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    //[inputTextView resignFirstResponder ]; // removes keyboard
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self placeInputView];
}

- (void)placeInputView{
    [self.backButton setHidden:NO];
    [self.amountTextField setHidden:YES];
    [self.amountLabel setHidden:YES];
    [self.amountDoneButton setHidden:YES];
    [self.addFriendDoneButton setHidden:YES];
    [self.statButton setHidden:YES];
    [self.tutorialTextView setHidden:YES];
    if (STEP==STEP0) {
         [self.backButton setHidden:YES];
        [self.tutorialTextView setHidden:NO];
    }else if (STEP==STEP1) {
        [self.addFriendDoneButton setHidden:NO];
    }else if (STEP==STEP2) {
         [self.amountTextField setHidden:NO];
         [self.amountLabel setHidden:NO];
        [self.amountDoneButton setHidden:NO];
    }else {
        [self.statButton setHidden:NO];
    }
    
    CGRect newFrame = inputView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = (self.collectionView.frame.size.height-inputView.frame.size.height)-keyboardHeight;
    NSLog(@"y=%f",newFrame.origin.y);
    inputView.frame = newFrame;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.STEP==STEP0||self.STEP==STEP1) {
        return [[[BillManager sharedBillManager] friends] count]+1;
    }
    return [[[BillManager sharedBillManager] friends] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellName;
    if (STEP==STEP3) {
        cellName=@"CellStep3";
    }else{
        cellName=@"CellStep012";
    }
    
        
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    [cell.blurImageView setAlpha:0.0];
    cell.amountDuelabel.hidden=NO;
    cell.incomelabel.hidden=NO;
    
    cell.plusLabel.backgroundColor= [[BillManager sharedBillManager] buttoncolor];
    cell.blackBannerLabel.backgroundColor= [[BillManager sharedBillManager] buttoncolor];
    
    if((indexPath.section*2 + indexPath.row)>=[[[BillManager sharedBillManager] friends] count]){
        // if it is the last friend
        cell.incomelabel.text = @"";
        cell.amountDuelabel.text = @"";
        cell.friend = nil;
        cell.imageView.hidden=YES;
        //cell.plusLabel.hidden=YES;
        [cell.resetButton setTitle:NSLocalizedString(@"RESET", nil)forState:UIControlStateNormal] ;
        cell.resetButton.hidden=NO;
        cell.addComradeTop.hidden=NO;
        cell.addComradeBottom.hidden=NO;
        cell.addComradeBottom.textColor=[[BillManager sharedBillManager] buttonTextColor];
        cell.addComradeTop.textColor=[[BillManager sharedBillManager] buttonTextColor];
        cell.addComradeTop.text=NSLocalizedString(@"ADD_COMRADE_LABEL_TOP", nil);
        cell.addComradeBottom.text=NSLocalizedString(@"ADD_COMRADE_LABEL_BOTTOM", nil);
        
    }else{
        cell.resetButton.hidden=YES;
        cell.addComradeTop.hidden=YES;
        cell.addComradeBottom.hidden=YES;
        //cell.plusLabel.hidden=YES;
        cell.blackBannerLabel.hidden=NO;
        
        
        Friend  *friend = [[[BillManager sharedBillManager] friends] objectAtIndex:(indexPath.section*2 + indexPath.row)];
        [cell setFriend:friend];
        if([friend.income doubleValue]<100000000){
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *friendIncome = [formatter stringFromNumber: friend.income];
            cell.incomelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"EARNS", nil), friendIncome];
        }else{
            cell.incomelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"EARNS", nil), NSLocalizedString(@"EARNS_TOO_MUCH", nil)];
        }
        if([friend.amountDue doubleValue]<100000){
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:2];
            [formatter setMinimumFractionDigits:0];
            NSString *friendShare = [formatter stringFromNumber: friend.amountDue];
            
            cell.amountDuelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"PAYS", nil), friendShare];
        }else{
            cell.amountDuelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"PAYS", nil), NSLocalizedString(@"PAYS_TOO_MUCH", nil)];
        }
        cell.amountDuelabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
        cell.incomelabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
        cell.amountDuelabel.hidden=NO;
        cell.incomelabel.hidden=NO;
        
        //if hidden
        if([[BillManager sharedBillManager] totalAmount]==0 || ![[BillManager sharedBillManager] isRevealed]){
            cell.amountDuelabel.hidden=YES;
            cell.incomelabel.hidden=YES;
        }
        
        cell.imageView.image = friend.image;
        cell.imageView.hidden=NO;

        if(![[BillManager sharedBillManager] isRevealed]){
                [cell.blurImageView setAlpha:0.4];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        NSLog(@"editing");
        // Open an action sheet with the possible editing actions
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EDIT_SEGUE"]) {
        EditFriendViewController *editViewController  = (EditFriendViewController *)[segue destinationViewController];
        FriendCollectionViewCell *cell = (FriendCollectionViewCell *)sender;
        [editViewController setFriend:[cell friend]];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
    keyboardIsVisible=YES;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.keyboardHeight= keyboardFrameBeginRect.size.height;
   // [UIView animateWithDuration:0.3f animations:^{
    if (self.STEP==STEP2) {
        [self.inputView setFrame:CGRectMake(0,self.inputView.frame.origin.y-keyboardFrameBeginRect.size.height,self.inputView.frame.size.width,self.inputView.frame.size.height)];
    }
   // }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //Assign new frame to your view
    keyboardIsVisible=NO;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.keyboardHeight= 0;
   // [UIView animateWithDuration:0.3 animations:^{
        [self.inputView setFrame:CGRectMake(0,self.inputView.frame.origin.y+keyboardFrameBeginRect.size.height,self.inputView.frame.size.width,self.inputView.frame.size.height)];
   // }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    //[nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:0];
    
    NSString *decimalSeperator = nf.decimalSeparator;
    NSString *currencySymbol = nf.currencySymbol;
    NSString *currencyGroupingSeparator = nf.currencyGroupingSeparator;
    // Grab the contents of the text field
    NSString *text = [textField text];
    
    NSString *replacementText = [text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString *newReplacement = [[ NSMutableString alloc ] initWithString:replacementText];
    
    if(![currencySymbol isEqualToString:@"CHF"] && ![currencySymbol isEqualToString:@"$"] ){
        [textField setText:newReplacement];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [f numberFromString:newReplacement];
        [[BillManager sharedBillManager] setTotalAmount: number];
        return NO;
    }
    if ([string isEqualToString:decimalSeperator] && [text rangeOfString:decimalSeperator].length == 0) {
        [textField setText:newReplacement];
    }
    else if([string isEqualToString:currencySymbol]&& [text rangeOfString:currencySymbol].length == 0) {
        [textField setText:newReplacement];
        
    } else if([newReplacement isEqualToString:currencySymbol]) {
        [[BillManager sharedBillManager] setTotalAmount:0];
        [self.amountTextField setText:@""];
        return NO;
    }else {
        
        [newReplacement replaceOccurrencesOfString:currencyGroupingSeparator withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        [newReplacement replaceOccurrencesOfString:currencySymbol withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        [newReplacement replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [f numberFromString:newReplacement];
        
        if([newReplacement isEqualToString:@" "] || [newReplacement isEqualToString:@""]) {
            number=0;
        }
        else{
            [nf setNumberStyle:NSNumberFormatterDecimalStyle];
            number = [nf numberFromString:newReplacement];
            if (number == nil) {
                return NO;
            }
        }
        
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        text = [nf stringFromNumber:number];
        [[BillManager sharedBillManager] setTotalAmount:number];
        [self.amountTextField setText:text];
        [[BillManager sharedBillManager] setTotalAmountString:text];
    }
    
    return NO; // we return NO because we have manually edited the textField contents.
}

-(BOOL)textFieldShouldClear:(UITextField*)textField
{
    [[BillManager sharedBillManager] setTotalAmount:0];
    return YES;
}


-(void)resetDinerRouge{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Do you want to restart? This will remove all your friends.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[BillManager sharedBillManager] reset];
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"reset" value:nil] build]];
        self.STEP--;
        [[self collectionView] reloadData];
        [self placeInputView];
    }
}


@end
