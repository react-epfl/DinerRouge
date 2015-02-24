//
//  FriendCollectionViewCell.h
//  PayPerPay
//
//  Created by Adrian Holzer on 18.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface FriendCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) Friend  *friend;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *blurImageView;
@property (strong, nonatomic) IBOutlet UILabel *incomelabel;
@property (strong, nonatomic) IBOutlet UILabel *amountDuelabel;
@property (strong, nonatomic) IBOutlet UILabel *blackBannerLabel;
@property (strong, nonatomic) IBOutlet UILabel *plusLabel;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UILabel *addComradeTop;
@property (strong, nonatomic) IBOutlet UILabel *addComradeBottom;

@end
