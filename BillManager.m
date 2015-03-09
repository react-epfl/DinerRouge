//
//  BillManager.m
//  PayPerPay
//
//  Created by Adrian Holzer on 17.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "Friend.h"
#import "BillManager.h"

@implementation BillManager

@synthesize totalAmount,totalIncome, friends, delegate,isRevealed, avatarImages, avatarImagesLeft, gini,buttonTextColor,totalAmountString,largeFont, mediumFont, smallFont, maincolor, secondarycolor, buttoncolor, fontName,fontNameBold,styleIsCommunist, backBoutonImage, cameraImage, infoImage, refreshImage,friendOrComrade;

static BillManager   *sharedBillManager = nil;

+(id) sharedBillManager{
    @synchronized(self) {
        if (sharedBillManager == nil){
            sharedBillManager = [[self alloc] init];
            [sharedBillManager reset];
            sharedBillManager.gini=nil;
            sharedBillManager.largeFont=22;
            sharedBillManager.mediumFont=18;
            sharedBillManager.smallFont=14;
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([defaults boolForKey:@"isCommunist"]){
                sharedBillManager.styleIsCommunist = [defaults boolForKey:@"isCommunist"];
            }else {
                sharedBillManager.styleIsCommunist=NO;
                int randomNumber = (int)arc4random_uniform(1000) % 2;
                if (randomNumber==1) {
                    NSLog(@"IS COMMUNIST");
                    sharedBillManager.styleIsCommunist=YES;
                    [defaults setBool:sharedBillManager.styleIsCommunist forKey:@"isCommunist"];
                }else{
                    NSLog(@"IS NOT COMMUNIST");
                }
                
            }
            
            sharedBillManager.styleIsCommunist=NO;

            
            sharedBillManager.maincolor=[UIColor colorWithRed:241.0/255.0 green:0.0/255.0 blue:35.0/255.0 alpha:1.0];
            
            if (sharedBillManager.styleIsCommunist) {
                sharedBillManager.fontNameBold=@"AvenirNext-Bold";
                sharedBillManager.fontName=@"AvenirNext";
                sharedBillManager.secondarycolor=[UIColor colorWithRed:220.0/255.0 green:210.0/255.0 blue:178.0/255.0 alpha:1.0];
                sharedBillManager.buttonTextColor=sharedBillManager.secondarycolor;
                sharedBillManager.buttoncolor=[UIColor blackColor];
                sharedBillManager.avatarImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"guest0.png"],[UIImage imageNamed:@"guest1.png"],[UIImage imageNamed:@"guest2.png"],[UIImage imageNamed:@"guest3.png"],[UIImage imageNamed:@"guest4.png"],[UIImage imageNamed:@"guest5.png"],[UIImage imageNamed:@"guest6.png"],nil];
                
                sharedBillManager.refreshImage=[UIImage imageNamed: @"refresh.png"];
                 sharedBillManager.backBoutonImage=[UIImage imageNamed: @"a_bouton_back.png"];
                 sharedBillManager.cameraImage=[UIImage imageNamed: @"cameraButton.png"];
                 sharedBillManager.infoImage=[UIImage imageNamed: @"a_bouton_info.png"];
                sharedBillManager.friendOrComrade=NSLocalizedString(@"CORMADE", nil);
            }else{
                sharedBillManager.fontNameBold=@"ArialRoundedMTBold";
                sharedBillManager.fontName=@"ArialRoundedMTBold";
                sharedBillManager.buttonTextColor=[UIColor whiteColor];
                sharedBillManager.secondarycolor=[UIColor whiteColor];
                sharedBillManager.buttoncolor=[UIColor blackColor];
                sharedBillManager.avatarImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"Xguest0.png"],[UIImage imageNamed:@"Xguest1.png"],[UIImage imageNamed:@"Xguest2.png"],[UIImage imageNamed:@"Xguest3.png"],[UIImage imageNamed:@"Xguest4.png"],[UIImage imageNamed:@"Xguest5.png"],[UIImage imageNamed:@"Xguest6.png"],nil];
                
                sharedBillManager.refreshImage=[UIImage imageNamed: @"Xrefresh.png"];
                sharedBillManager.backBoutonImage=[UIImage imageNamed: @"Xa_bouton_back.png"];
                sharedBillManager.cameraImage=[UIImage imageNamed: @"XcameraButton.png"];
                sharedBillManager.infoImage=[UIImage imageNamed: @"Xa_bouton_info.png"];
                sharedBillManager.friendOrComrade=NSLocalizedString(@"FRIEND", nil);
            }
            
            sharedBillManager.avatarImagesLeft=[sharedBillManager.avatarImages mutableCopy];
        }
    }
    return sharedBillManager;
}

-(void) addFriendwithImage:(UIImage*) image income:(NSNumber*) income{
    
    Friend* newFriend = [[Friend alloc] init];
    [newFriend setImage:image];
    [newFriend setIncome:income];
    [newFriend setAmountDue:0];
    [self.friends addObject:newFriend];
    [delegate updatedBillManager];
}

-(void) replaceFriendwithImage:(UIImage*) image income:(NSNumber*) income atIndex:(int) index{
    Friend* newFriend = [[Friend alloc] init];
    [newFriend setImage:image];
    [newFriend setIncome:income];
    [newFriend setAmountDue:0];
    [self.friends replaceObjectAtIndex: index withObject:newFriend];
    [delegate updatedBillManager];
}



-(int) removeFriend: (Friend *) friend{
    long index = [friends indexOfObject:friend];
    [friends removeObject:friend];
    [delegate updatedBillManager];
    return (int)index;
}


-(void) hide{
    isRevealed=NO;
    [delegate updatedBillManager];
}

-(void) reveal{
    isRevealed=YES;
    [delegate updatedBillManager];
}

-(void) reset{
    self.friends = [[NSMutableArray alloc] init];
    self.totalAmount=0;
    self.totalIncome=0;
    self.gini=nil;
    self.isRevealed=NO;
    [[BillManager sharedBillManager] setAvatarImagesLeft:[[[BillManager sharedBillManager] avatarImages] mutableCopy]];
    [delegate updatedBillManager];
}

-(void) checkOut{
    NSLog(@"so far total amount is: %f", [totalAmount doubleValue]);
    if(totalAmount>0){
        totalIncome=0;
        
        for (Friend* friend in friends){
            totalIncome=[NSNumber numberWithDouble:[totalIncome doubleValue]+[[friend income] doubleValue]];
            NSLog(@"a friend with %.0f income ", [[friend income] doubleValue]);
        }
        NSLog(@"=============== ");
        NSLog(@"a totalAmount of %.0f ", [totalAmount doubleValue]);
        double  amountPerUnit =  [totalAmount doubleValue] / [totalIncome doubleValue];
        for (Friend* friend in friends){
            [friend setAmountDue: [NSNumber numberWithDouble: [[friend income] doubleValue] *amountPerUnit]];
            NSLog(@"a friend must pay %.2f  ", [[friend amountDue] doubleValue] );
        }
    }
    self.gini = [self computeGini];
    [self computeDistribution];
    
    [delegate updatedBillManager];
    
}


-(NSNumber*) computeGini{
    //G = (sum(1 to n (2i - n - 1)x_i))/ mean*n^2 from http://mathworld.wolfram.com/GiniCoefficient.html
    // multiply by n/(n-1) to become an unbiased estimator
    if ([friends count]<2) {
        return nil;
    }
    // calculating the sum
    long n = [friends count];
    double sum= 0;
    NSMutableArray* sortedFriends = [self sortFriendsByIncome: [friends mutableCopy]];
    for(int i = 1; i <= n ; i++){
        Friend * friend = sortedFriends[i-1];
        long income= [friend.income longValue];
        sum += ((2*i - n - 1)* income);
    }
    // calculating mean income
    double totalofAllIncome = 0;
    for (Friend *friend in self.friends){
        totalofAllIncome+= [friend.income intValue];
    }
    double meanIncome = totalofAllIncome/n;
    // calculating gini
    float g = sum / (meanIncome*pow(n,2));
    float gCorrected = g*(n/(n-1));
    // returning gini in string format
    return [NSNumber numberWithFloat: gCorrected*100]  ;
}


-(void) computeDistribution{
    NSMutableArray *qs = [NSMutableArray array];
    self.q1=[NSNumber numberWithInt:0];
    self.q2=[NSNumber numberWithInt:0];
    self.q3=[NSNumber numberWithInt:0];
    self.q4=[NSNumber numberWithInt:0];
    self.q5=[NSNumber numberWithInt:0];
    // calculating the sum
    long n = [friends count];
    double sum= 0;
    NSMutableArray* sortedFriends = [self sortFriendsByIncome: [friends mutableCopy]];
    for(int i = 1; i <= n ; i++){
        Friend * friend = sortedFriends[i-1];
        int income= [friend.income intValue];
        sum += income;
    }
    
    int numberOfbuckets=1;
    long n_per_q=0;
    if (n%5==0) {
        numberOfbuckets=5;
        n_per_q=n/numberOfbuckets;
    }else if (n%4==0) {
        numberOfbuckets=4;
        n_per_q=n/numberOfbuckets;
    }else if (n%3==0) {
        numberOfbuckets=3;
        n_per_q=n/numberOfbuckets;
    }else if (n%2==0) {
        numberOfbuckets=2;
        n_per_q=n/numberOfbuckets;
    }else if (n==7){
        numberOfbuckets=4;
        n_per_q=2;
    }else if (n==11){
        numberOfbuckets=4;
        n_per_q=3;
    }else if (n==13){
        numberOfbuckets=4;
        n_per_q=4;
    }else if (n==17){
        numberOfbuckets=5;
        n_per_q=4;
    }
    
    for(int i = 0; i < numberOfbuckets ; i++){
        double sum_per_q= 0;
        long startIndex=i*n_per_q;
        long stopIndex=startIndex+n_per_q;
        for(long j = startIndex; j <stopIndex ; j++){
            if ([sortedFriends count]>j) {
                Friend * friend = sortedFriends[j];
                long income= [friend.income integerValue];
                sum_per_q += income;
            }
        }
        qs[i]=[NSNumber numberWithDouble: (sum_per_q/sum)*100];
    }
    if ([qs count]>0) {
        self.q1=qs[0];
    }
    if ([qs count]>1) {
        self.q2=qs[1];
    }
    if ([qs count]>2) {
        self.q3=qs[2];
    }
    if ([qs count]>3) {
        self.q4=qs[3];
    }
    if ([qs count]>4) {
        self.q5=qs[4];
    }
}

-(NSString*)yourInequality{
    NSString* adjective;
    if ([gini intValue]==0 ) {
        adjective= NSLocalizedString(@"INEXISTANT", nil);
    }else if ([gini intValue]<10 ) {
        adjective=  NSLocalizedString(@"ALMOST INEXISTANT", nil);
    }else
        if ([gini intValue]<20 ) {
            adjective=  NSLocalizedString(@"VERY LOW", nil);
        }else
            if ([gini intValue]<30 ) {
                adjective=  NSLocalizedString(@"LOW", nil);
            }else
                if ([gini intValue]<40 ) {
                    adjective=  NSLocalizedString(@"MEDIUM", nil);
                }else
                    if ([gini intValue]<50 ) {
                        adjective=  NSLocalizedString(@"MEDIUM HIGH", nil);
                    }else
                        if ([gini intValue]<60 ) {
                            adjective=  NSLocalizedString(@"HIGH", nil);
                        }else
                            if ([gini intValue]<70 ) {
                                adjective=  NSLocalizedString(@"VERY HIGH", nil);
                            }else
                                if ([gini intValue]<80 ) {
                                    adjective=  NSLocalizedString(@"VERY VERY HIGH", nil);
                                }else
                                    if ([gini intValue]<90 ) {
                                        adjective=  NSLocalizedString(@"EXTREME", nil);
                                    }else
                                        if ([gini intValue]<100 ) {
                                            adjective=  NSLocalizedString(@"ALMOST MAXIMAL", nil);
                                        }else{
                                            adjective=  NSLocalizedString(@"MAXIMAL", nil);
                                        }
    NSString* prePhrase=[NSString stringWithFormat:  NSLocalizedString(@"YOU_INEQUALITY", nil)];
    return [NSString stringWithFormat:@"%@ %@", prePhrase, adjective];
}


-(NSMutableArray*) sortFriendsByIncome:(NSMutableArray*)some_friends{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"income" ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [some_friends sortedArrayUsingDescriptors:sortDescriptors];
    return [sortedArray mutableCopy];
}


@end
