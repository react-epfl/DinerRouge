//
//  Country.m
//  DinerRouge
//
//  Created by Adrian Holzer on 15.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//

#import "Country.h"

@implementation Country

@synthesize name, gini,isMyTable, q1, q2, q3, q4, q5;

- (id)initWithName:(NSString*) aName gini:(NSNumber *)aGini{
    self = [super init];
    if(self){
        self.name=aName;
        self.gini=aGini;
        self.isMyTable=NO;
    }
    return self;
}

- (id)initWithName:(NSString*) aName gini:(NSNumber *)aGini q1:(NSNumber *)aQ1 q2:(NSNumber *)aQ2 q3:(NSNumber *)aQ3 q4:(NSNumber *)aQ4 q5:(NSNumber *)aQ5{
    self = [super init];
    if(self){
        self.name=aName;
        self.gini=aGini;
        self.isMyTable=NO;
        self.q1=aQ1;
        self.q2=aQ2;
        self.q3=aQ3;
        self.q4=aQ4;
        self.q5=aQ5;
    }
    return self;
}


-(NSString*)inequality:(NSString*) type{
    NSString* adjective;
    if ([gini intValue]==0 ) {
        adjective= NSLocalizedString(@"INEXISTANT", nil);
    }else if ([gini intValue]<=10 ) {
        adjective=  NSLocalizedString(@"ALMOST INEXISTANT", nil);
    }else
    if ([gini intValue]<=20 ) {
        adjective=  NSLocalizedString(@"VERY LOW", nil);
    }else
    if ([gini intValue]<=30 ) {
        adjective=  NSLocalizedString(@"LOW", nil);
    }else
    if ([gini intValue]<=40 ) {
        adjective=  NSLocalizedString(@"MEDIUM", nil);
    }else
    if ([gini intValue]<=50 ) {
        adjective=  NSLocalizedString(@"MEDIUM HIGH", nil);
    }else
    if ([gini intValue]<=60 ) {
        adjective=  NSLocalizedString(@"HIGH", nil);
    }else
    if ([gini intValue]<=70 ) {
        adjective=  NSLocalizedString(@"VERY HIGH", nil);
    }else
    if ([gini intValue]<=80 ) {
        adjective=  NSLocalizedString(@"EXTREME", nil);
    }else
    if ([gini intValue]<=90 ) {
        adjective=  NSLocalizedString(@"ALMOST MAXIMAL", nil);
    }else
    if ([gini intValue]<=100 ) {
        adjective=  NSLocalizedString(@"MAXIMAL", nil);
    }else{
    adjective=  NSLocalizedString(@"MAXIMAL", nil);
    }
    
    NSString* prePhrase=[NSString stringWithFormat:  NSLocalizedString(@"HERE_INEQUALITY", nil),type];
    
    return [NSString stringWithFormat:@"%@ %@", prePhrase, adjective];
}


-(NSString*)inequalityTitle{
    NSString* adjective;
    if ([gini intValue]==0 ) {
        adjective= NSLocalizedString(@"INEXISTANT", nil);
    }else if ([gini intValue]<=10 ) {
        adjective=  NSLocalizedString(@"ALMOST INEXISTANT", nil);
    }else
        if ([gini intValue]<=20 ) {
            adjective=  NSLocalizedString(@"VERY LOW", nil);
        }else
            if ([gini intValue]<=30 ) {
                adjective=  NSLocalizedString(@"LOW", nil);
            }else
                if ([gini intValue]<=40 ) {
                    adjective=  NSLocalizedString(@"MEDIUM", nil);
                }else
                    if ([gini intValue]<=50 ) {
                        adjective=  NSLocalizedString(@"MEDIUM HIGH", nil);
                    }else
                        if ([gini intValue]<=60 ) {
                            adjective=  NSLocalizedString(@"HIGH", nil);
                        }else
                            if ([gini intValue]<=70 ) {
                                adjective=  NSLocalizedString(@"VERY HIGH", nil);
                            }else
                                if ([gini intValue]<=80 ) {
                                    adjective=  NSLocalizedString(@"EXTREME", nil);
                                }else
                                    if ([gini intValue]<=90 ) {
                                        adjective=  NSLocalizedString(@"ALMOST MAXIMAL", nil);
                                    }else
                                        if ([gini intValue]<=100 ) {
                                            adjective=  NSLocalizedString(@"MAXIMAL", nil);
                                        }else{
                                            adjective=  NSLocalizedString(@"MAXIMAL", nil);
                                        }
    
    
    return [NSString stringWithFormat:  NSLocalizedString(@"COUNTRIES_INEQUALITY", nil),[adjective lowercaseString]];
}


+(NSString*)inequalityWithGini:(NSNumber*)aGini{
    if ([aGini intValue]==0 ) {
        return NSLocalizedString(@"INEXISTANT", nil);
    }else if ([aGini intValue]<=10 ) {
        return  NSLocalizedString(@"ALMOST INEXISTANT", nil);
    }else
        if ([aGini intValue]<=20 ) {
           return NSLocalizedString(@"VERY LOW", nil);
        }else
            if ([aGini intValue]<=30 ) {
                return  NSLocalizedString(@"LOW", nil);
            }else
                if ([aGini intValue]<=40 ) {
                    return NSLocalizedString(@"MEDIUM", nil);
                }else
                    if ([aGini intValue]<=50 ) {
                        return NSLocalizedString(@"MEDIUM HIGH", nil);
                    }else
                        if ([aGini intValue]<=60 ) {
                            return NSLocalizedString(@"HIGH", nil);
                        }else
                            if ([aGini intValue]<=70 ) {
                                return NSLocalizedString(@"VERY HIGH", nil);
                            }else
                                if ([aGini intValue]<=80 ) {
                                    return  NSLocalizedString(@"EXTREME", nil);
                                }else
                                    if ([aGini intValue]<=90 ) {
                                        return  NSLocalizedString(@"ALMOST MAXIMAL", nil);
                                    }else
                                        if ([aGini intValue]<=100 ) {
                                           return  NSLocalizedString(@"MAXIMAL", nil);
                                        }else{
                                           return  NSLocalizedString(@"MAXIMAL", nil);
                                        }
    
}

@end
