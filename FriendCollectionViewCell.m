//
//  FriendCollectionViewCell.m
//  PayPerPay
//
//  Created by Adrian Holzer on 18.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import "FriendCollectionViewCell.h"

@implementation FriendCollectionViewCell

@synthesize imageView,amountDuelabel,incomelabel, friend,blackBannerLabel,plusLabel,blurImageView, resetButton,addComradeBottom, addComradeTop;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
