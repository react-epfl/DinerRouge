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

@interface FriendCollectionViewController ()



@end

@implementation FriendCollectionViewController


@synthesize totalAmountTextField;

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
}


-(void)viewWillAppear:(BOOL)animated{
    [[self collectionView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BillManager sharedBillManager] setDelegate:self];
    
    
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
    customLabel.backgroundColor= [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    [customLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:22]];
    customLabel.textColor =  [UIColor colorWithRed:220.0/255.0 green:210.0/255.0 blue:178.0/255.0 alpha:1.0];
    navigationItem.titleView = customLabel;
    customLabel.text=@"DINER ROUGE";
    
}

-(IBAction)resetDinerRouge:(id)sender{
    [[BillManager sharedBillManager] reset];
    NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:topPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"reset" value:nil] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatedBillManager{
    [[self collectionView] reloadData];
    NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *bottomPath = [NSIndexPath indexPathForRow:[[[BillManager sharedBillManager] friends] count] inSection:0];
    
    // as long as the amount is not set, scroll to top
    if ([[BillManager sharedBillManager] totalAmount]==0){
        [self.collectionView scrollToItemAtIndexPath:topPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }else{
        //else scroll to bottom
        [self.collectionView scrollToItemAtIndexPath:bottomPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        //unless we just revealed who pays what and we want to return to the top
        if ([[BillManager sharedBillManager] isRevealed]){
            [self.collectionView scrollToItemAtIndexPath:topPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[BillManager sharedBillManager] friends] count]+1;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && [kind isEqual:UICollectionElementKindSectionHeader]) {
        ReusableHeaderView *header = nil;
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyHeader" forIndexPath: indexPath];
        header.totalAmountTextField.text=@"";
        header.totalAmountTextField.placeholder=NSLocalizedString(@"CHECK_FIELD_PLACEHOLDER", nil);
        if([[BillManager sharedBillManager] totalAmount]>0){
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            NSNumber *currencyNumber =[[BillManager sharedBillManager] totalAmount];
            [nf setMaximumFractionDigits:2];
            [nf setMinimumFractionDigits:0];
            if([nf.currencySymbol isEqualToString:@"CHF"] || [nf.currencySymbol isEqualToString:@"$"] ){
                [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            }else{
                 [nf setNumberStyle:NSNumberFormatterNoStyle];
                
            }
            [header.totalAmountTextField setText:[nf stringFromNumber:currencyNumber]];
        }
        return header;
    }
    
    if (indexPath.section==0 && [kind isEqual:UICollectionElementKindSectionFooter]) {
        ReusableFooterView *footer = nil;
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyFooter" forIndexPath: indexPath];
        footer.revealButton.hidden=NO;
        
        
        [footer.revealButton setTitle:NSLocalizedString(@"REVEAL_BUTTON", nil) forState:UIControlStateNormal];
        [footer.hideButton setTitle:NSLocalizedString(@"HIDE", nil) forState:UIControlStateNormal];
        [footer.statButton setTitle:NSLocalizedString(@"STAT", nil) forState:UIControlStateNormal];
        [footer.youButton setTitle:[[BillManager sharedBillManager] yourInequality] forState:UIControlStateNormal];
        
        
        if([[BillManager sharedBillManager] isRevealed]){
            footer.youButton.hidden=NO;
            footer.statButton.hidden=NO;
            footer.revealButton.hidden=YES;
            footer.hideButton.hidden=NO;
        }else{
            footer.hideButton.hidden=YES;
           footer.youButton.hidden=YES;
            footer.statButton.hidden=YES;
        }
        if ([[[BillManager sharedBillManager] friends] count]==0 || [[BillManager sharedBillManager] totalAmount]==0){
            footer.revealButton.hidden=YES;
            footer.youButton.hidden=YES;
            footer.statButton.hidden=YES;
            footer.hideButton.hidden=YES;
        }
        if ([[[BillManager sharedBillManager] friends] count]<2 || [[BillManager sharedBillManager] totalAmount]==0){
            footer.youButton.hidden=YES;
            footer.statButton.hidden=YES;
        }
        return footer;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.blurImageView setAlpha:0.0];
    cell.amountDuelabel.hidden=NO;
    cell.incomelabel.hidden=NO;

    
    if((indexPath.section*2 + indexPath.row)>=[[[BillManager sharedBillManager] friends] count]){
        // if it is the last friend
        cell.incomelabel.text = @"";
        cell.amountDuelabel.text = @"";
        cell.friend = nil;
        cell.imageView.hidden=YES;
        cell.plusLabel.hidden=YES;
        [cell.resetButton setTitle:NSLocalizedString(@"RESET", nil)forState:UIControlStateNormal] ;
        cell.resetButton.hidden=NO;
        cell.addComradeTop.hidden=NO;
        cell.addComradeBottom.hidden=NO;
        cell.addComradeTop.text=NSLocalizedString(@"ADD_COMRADE_LABEL_TOP", nil);
        cell.addComradeBottom.text=NSLocalizedString(@"ADD_COMRADE_LABEL_BOTTOM", nil);
        
    }else{
        cell.resetButton.hidden=YES;
        cell.addComradeTop.hidden=YES;
        cell.addComradeBottom.hidden=YES;
        cell.plusLabel.hidden=YES;
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
            //if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                [cell.blurImageView setAlpha:0.4];
           // }
           // else{
            //    cell.blurImageView.image = friend.image;
            //    [cell.blurImageView setAlpha:1];
             //   UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
             //   UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
              //  effectView.frame = cell.blurImageView.bounds;
              //  [cell.blurImageView addSubview:effectView];
           // }
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




@end
