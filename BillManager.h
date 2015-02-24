//
//  BillManager.h
//  PayPerPay
//
//  Created by Adrian Holzer on 17.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"
#import "BillManagerDelegate.h"

@interface BillManager : NSObject

+(id) sharedBillManager;
-(void) checkOut;
-(void) reset;
-(void) hide;
-(void) reveal;
-(void) addFriendwithImage:(UIImage*) image income:(NSNumber*) income;
-(void) replaceFriendwithImage:(UIImage*) image income:(NSNumber*) income atIndex:(int) index;
-(int) removeFriend:(Friend*) friend;
-(NSNumber*)computeGini;
-(NSString*)yourInequality;
-(void)computeDistribution;


@property (strong, nonatomic) id<BillManagerDelegate> delegate;

@property (nonatomic,strong)  NSMutableArray *friends;
@property (nonatomic, strong) NSNumber* totalAmount;
@property (nonatomic, strong) NSNumber* totalIncome;
@property (nonatomic) BOOL isRevealed;
@property (strong, nonatomic) NSNumber* gini;
@property (strong, nonatomic) NSNumber* q1;
@property (strong, nonatomic) NSNumber* q2;
@property (strong, nonatomic) NSNumber* q3;
@property (strong, nonatomic) NSNumber* q4;
@property (strong, nonatomic) NSNumber* q5;
@property(strong, nonatomic)  NSArray * avatarImages;
@property(strong, nonatomic)  NSMutableArray * avatarImagesLeft;



@end
