//
//  ReusableHeaderView.m
//  DinerRouge
//
//  Created by Adrian Holzer on 30.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ReusableHeaderView.h"
#import "BillManager.h"

@implementation ReusableHeaderView

@synthesize totalAmountTextField,storedValue,totalAmountLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [totalAmountTextField setPlaceholder:NSLocalizedString(@"CHECK_FIELD_PLACEHOLDER", nil)];
        
        // Initialization code
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    //[nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:0];

    NSString *decimalSeperator = nf.decimalSeparator;
    NSString *currencySymbol = nf.currencySymbol;
    NSString *currencyGroupingSeparator = nf.currencyGroupingSeparator;
    // Grab the contents of the text field
    NSString *text = [textField text];
    
    NSString *replacementText = [text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString *newReplacement = [[ NSMutableString alloc ] initWithString:replacementText];
    
    if(![currencySymbol isEqualToString:@"CHF"] && ![currencySymbol isEqualToString:@"$"] ){
        [textField setText:newReplacement];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [f numberFromString:newReplacement];
        [[BillManager sharedBillManager] setTotalAmount: number];
        return NO;
    }
    if ([string isEqualToString:decimalSeperator] && [text rangeOfString:decimalSeperator].length == 0) {
        [textField setText:newReplacement];
    }
    else if([string isEqualToString:currencySymbol]&& [text rangeOfString:currencySymbol].length == 0) {
        [textField setText:newReplacement];
        
   } else if([newReplacement isEqualToString:currencySymbol]) {
        [[BillManager sharedBillManager] setTotalAmount:0];
        [totalAmountTextField setText:@""];
        return NO;
    }else {
        
        [newReplacement replaceOccurrencesOfString:currencyGroupingSeparator withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        [newReplacement replaceOccurrencesOfString:currencySymbol withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        [newReplacement replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [newReplacement length])];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [f numberFromString:newReplacement];

        if([newReplacement isEqualToString:@" "] || [newReplacement isEqualToString:@""]) {
            number=0;
        }
        else{
            [nf setNumberStyle:NSNumberFormatterDecimalStyle];
            number = [nf numberFromString:newReplacement];
            if (number == nil) {
                return NO;
            }
        }
        
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        text = [nf stringFromNumber:number];
        [[BillManager sharedBillManager] setTotalAmount:number];
        [totalAmountTextField setText:text];
    }
    
    return NO; // we return NO because we have manually edited the textField contents.
}

-(BOOL)textFieldShouldClear:(UITextField*)textField
{
    [[BillManager sharedBillManager] setTotalAmount:0];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction) okPressed:(id)sender{
        [[BillManager sharedBillManager] checkOut];
        [totalAmountTextField resignFirstResponder];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"  action:@"button_press" label:@"ok_amount" value:nil] build]];
}


@end
