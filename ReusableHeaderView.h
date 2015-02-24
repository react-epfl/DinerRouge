//
//  ReusableHeaderView.h
//  DinerRouge
//
//  Created by Adrian Holzer on 30.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReusableHeaderView : UICollectionReusableView<UITextFieldDelegate>

@property(strong, nonatomic) IBOutlet UITextField * totalAmountTextField;
@property(strong, nonatomic) IBOutlet UIButton * checkoutButton;
@property (strong, nonatomic) NSMutableString *storedValue;

-(IBAction) okPressed:(id)sender;
@end
