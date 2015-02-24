//
//  Country.h
//  DinerRouge
//
//  Created by Adrian Holzer on 15.11.14.
//  Copyright (c) 2014 Adrian Holzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

- (id)initWithName:(NSString*) aName gini:(NSNumber *)aGini;
- (id)initWithName:(NSString*) aName gini:(NSNumber *)aGini q1:(NSNumber *)aQ1 q2:(NSNumber *)aQ2 q3:(NSNumber *)aQ3 q4:(NSNumber *)aQ4 q5:(NSNumber *)aQ5;

-(NSString*)inequality:(NSString*) type;

@property (nonatomic,strong)  NSString *name;
@property (nonatomic, strong) NSNumber *gini;
@property (nonatomic, strong) NSNumber *q1;
@property (nonatomic, strong) NSNumber *q2;
@property (nonatomic, strong) NSNumber *q3;
@property (nonatomic, strong) NSNumber *q4;
@property (nonatomic, strong) NSNumber *q5;
@property (nonatomic) BOOL isMyTable;


@end
