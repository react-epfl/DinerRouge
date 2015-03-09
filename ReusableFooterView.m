//
//  ReusableFooterView.m
//  DinerRouge
//
//  Created by Adrian Holzer on 31.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ReusableFooterView.h"
#import "BillManager.h"

@implementation ReusableFooterView

@synthesize revealButton,statButton,youButton,hideButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [revealButton setHidden:YES];
        [hideButton setHidden:YES];
        [youButton setHidden:YES];
        [statButton setHidden:YES];
    }
    return self;
}

-(IBAction) hidePressed:(id)sender{
    [[BillManager sharedBillManager] hide];
    //[[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"hide" value:nil] build]];
}

-(IBAction) revealPressed:(id)sender{
        [[BillManager sharedBillManager] reveal];
      //  [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"reveal" value:nil] build]];
}

@end
