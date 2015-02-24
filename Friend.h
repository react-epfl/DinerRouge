//
//  Friend.h
//  PayPerPay
//
//  Created by Adrian Holzer on 17.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic, strong) NSNumber* amountDue;
@property (nonatomic, strong) NSNumber* income;

@property (nonatomic,strong) NSString* imageName;
@property (nonatomic,strong) UIImage* image;

@end
