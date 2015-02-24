//
//  ReusableFooterView.h
//  DinerRouge
//
//  Created by Adrian Holzer on 31.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReusableFooterView : UICollectionReusableView

@property(strong, nonatomic) IBOutlet UIButton * revealButton;
@property(strong, nonatomic) IBOutlet UIButton * statButton;
@property(strong, nonatomic) IBOutlet UIButton * youButton;
@property(strong, nonatomic) IBOutlet UIButton * hideButton;

-(IBAction) revealPressed:(id)sender;
-(IBAction) hidePressed:(id)sender;

@end
