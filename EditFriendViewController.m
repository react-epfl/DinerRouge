//
//  ImagePickerViewController.m
//  PayPerPay
//
//  Created by Adrian Holzer on 17.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import "EditFriendViewController.h"
#import "BillManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import <QuartzCore/QuartzCore.h>

#define SIDE_PADDING 15
@interface EditFriendViewController (){
    BOOL firstTimeLoading;
    
}

@end



@implementation EditFriendViewController

@synthesize imageView,toolbar, incomeTextField, friend, saveButton, deleteButton,  imageButton, numberOfFriendslabel, yourPhotoLabel, swipeView, indexOfAvatarCurrentlyDisplayed,imageScrollView,isEditingExistingFriend ;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.view.backgroundColor=[[BillManager sharedBillManager] maincolor];
    self.swipeView.backgroundColor=[[BillManager sharedBillManager] buttoncolor];
    firstTimeLoading=YES;
    
    if([[[BillManager sharedBillManager] avatarImagesLeft] count]==0){
        [[BillManager sharedBillManager] setAvatarImagesLeft:[[[BillManager sharedBillManager] avatarImages] mutableCopy]];
    }
    
    imageScrollView.contentSize = CGSizeMake([[[BillManager sharedBillManager] avatarImagesLeft] count]*imageScrollView.frame.size.width ,imageScrollView.frame.size.height);
    int index = 0;
    
    for (UIImage* image in [[BillManager sharedBillManager] avatarImagesLeft]){
        UIImageView* avatarImageView =[[UIImageView alloc] initWithImage:image];
        [avatarImageView setFrame: CGRectMake(index*imageScrollView.frame.size.width,0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
        //[imageScrollView addSubview:avatarImageView];
        [imageScrollView insertSubview:avatarImageView atIndex:index];
        index++;
    }
    [imageScrollView scrollRectToVisible:CGRectMake(imageScrollView.frame.size.width,0, imageScrollView.frame.size.width, imageScrollView.frame.size.height) animated:YES];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"background_nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    //setup nav bar title
    UINavigationItem *navigationItem = [super navigationItem];
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.0f, 44.0f)];
    customLabel.backgroundColor= [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    [customLabel setFont:[UIFont fontWithName:[[BillManager sharedBillManager] fontNameBold] size:[[BillManager sharedBillManager] largeFont]]];
    customLabel.text = NSLocalizedString(@"PICKER_TITLE", nil);
    customLabel.textColor =  [[BillManager sharedBillManager] secondarycolor];
    navigationItem.titleView = customLabel;
    
    
    [incomeTextField setPlaceholder:NSLocalizedString(@"INCOME_FIELD_PLACEHOLDER", nil)];

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setMaximumFractionDigits:2];
    [nf setMinimumFractionDigits:0];
    
    
    if([nf.currencySymbol isEqualToString:@"CHF"] || [nf.currencySymbol isEqualToString:@"$"] ){
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    }else{
        [nf setNumberStyle:NSNumberFormatterNoStyle];
    }
    [incomeTextField setText:[nf stringFromNumber:friend.income]];
    saveButton.titleLabel.numberOfLines = 1;
    saveButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    saveButton.titleLabel.textColor=[[BillManager sharedBillManager] buttonTextColor];
    [saveButton setTitleColor:[[BillManager sharedBillManager] buttonTextColor] forState:UIControlStateNormal];
    saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [saveButton setTitle:NSLocalizedString(@"SAVE_BUTTON", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.numberOfLines = 1;
    deleteButton.backgroundColor=[[BillManager sharedBillManager] buttoncolor] ;
    [deleteButton setTitle:NSLocalizedString(@"DELETE_BUTTON", nil) forState:UIControlStateNormal];
    
    CGRect frm=incomeTextField.frame;
    frm.size.width=  self.view.frame.size.width-(frm.origin.x+SIDE_PADDING);
    incomeTextField.frame=frm;

     frm=saveButton.frame;
    frm.size.width=  self.view.frame.size.width-(frm.origin.x+SIDE_PADDING);
    saveButton.frame=frm;
    
    frm=deleteButton.frame;
    frm.size.width=  self.view.frame.size.width-(frm.origin.x+SIDE_PADDING);
    deleteButton.frame=frm;
    
    // Back Button
    // BACK BUTTON START
    UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBackButton setImage:[UIImage imageNamed: @"a_bouton_back.png"] forState:UIControlStateNormal];
    [newBackButton addTarget:self action:@selector(customBack:) forControlEvents:UIControlEventTouchUpInside];
    newBackButton.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newBackButton];
    
  
    //add image to list and focus on it
    if(friend){
        friendIncome=friend.income;
        UIImageView* avatarImageView =[[UIImageView alloc] initWithImage:friend.image];
        [avatarImageView setFrame: CGRectMake(imageScrollView.contentSize.width,0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
        imageScrollView.contentSize=CGSizeMake(imageScrollView.contentSize.width+imageScrollView.frame.size.width,imageScrollView.frame.size.height);
        //[imageScrollView addSubview:avatarImageView];
         [imageScrollView insertSubview:avatarImageView atIndex:[[[BillManager sharedBillManager] avatarImagesLeft] count]];
        [imageScrollView scrollRectToVisible:avatarImageView.frame animated:NO];
    }else{
        [self clearIncomeAndAddNextPic];
        [saveButton setTitle:NSLocalizedString(@"ADD_BUTTON", nil) forState:UIControlStateNormal];
        deleteButton.hidden=YES;
    }
    [incomeTextField becomeFirstResponder];
    [super viewDidLoad];
}

-(IBAction)customBack:(id)sender{
    [[BillManager sharedBillManager] checkOut];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)clearIncomeAndAddNextPic{
    [incomeTextField setText:@""];
}

-(void)viewWillAppear:(BOOL)animated{
    [incomeTextField becomeFirstResponder];
    [super viewWillAppear:animated];
}



-(IBAction) saveButtonTouched:(id)sender
{
    
    if(friendIncome>0){
        int avatarIndex = imageScrollView.contentOffset.x/imageScrollView.frame.size.width;
        UIImageView* avatarImageView = (UIImageView*)[[imageScrollView subviews] objectAtIndex:avatarIndex];
        [[[BillManager sharedBillManager] avatarImagesLeft] removeObject:avatarImageView.image];
        
        //NSLog(@"INDEX %d with image %@",avatarIndex, avatarImageView.image.description);
        
        if(friend){
            long index = [[[BillManager sharedBillManager] friends] indexOfObject:friend];
            [[BillManager sharedBillManager] replaceFriendwithImage:avatarImageView.image income:friendIncome atIndex: (int)index];
        }else{
            [[BillManager sharedBillManager] addFriendwithImage: avatarImageView.image income:friendIncome];
        }
        [[BillManager sharedBillManager] checkOut];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction) deleteButtonTouched:(id)sender{
    [[BillManager sharedBillManager] removeFriend:friend];
    [[BillManager sharedBillManager] checkOut];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initializeFilterContext{
    context = [CIContext contextWithOptions:nil];
}

-(IBAction) takePicture:(id) sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *fullSizeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize sz = CGSizeMake(imageScrollView.frame.size.height, imageScrollView.frame.size.width);
    UIImage *resizedImage = [EditFriendViewController imageWithImage:fullSizeImage scaledToSize:sz];
    
    UIImageView* avatarImageView =[[UIImageView alloc] initWithImage:resizedImage];
    [avatarImageView setFrame: CGRectMake(imageScrollView.contentSize.width,0, imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
    imageScrollView.contentSize=CGSizeMake(imageScrollView.contentSize.width+imageScrollView.frame.size.width,imageScrollView.frame.size.height);
    //[imageScrollView addSubview:avatarImageView];
    [imageScrollView insertSubview:avatarImageView atIndex:[[[BillManager sharedBillManager] avatarImagesLeft] count]];
    [imageScrollView scrollRectToVisible:avatarImageView.frame animated:NO];
    
    // write picture to album
    UIImageWriteToSavedPhotosAlbum(fullSizeImage, self, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(firstTimeLoading&& !friend){
        [imageScrollView scrollRectToVisible:CGRectMake(0,0, imageScrollView.frame.size.width, imageScrollView.frame.size.height) animated:YES];
    }
    firstTimeLoading=NO;
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:@"Edit Screen"];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    CGContextRef bitmap;
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
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
        friendIncome=number;
        return NO;
    }
    // the appropriate decimalSeperator and currencySymbol for the current locale
    // can be found with help of the
    // NSNumberFormatter and NSLocale classes.
    
    
    // whenever a decimalSeperator or currencySymobol is entered, we'll just update the textField.
    // whenever other chars are entered, we'll calculate the new number and update the textField accordingly.
    // If the number can't be computed, we ignore the new input.
    if ([string isEqualToString:decimalSeperator] && [text rangeOfString:decimalSeperator].length == 0) {
        [textField setText:newReplacement];
    }
    else if([string isEqualToString:currencySymbol]&& [text rangeOfString:currencySymbol].length == 0) {
        [textField setText:newReplacement];
        
    } else if([newReplacement isEqualToString:currencySymbol]) {
        friendIncome=0;
        [incomeTextField setText:@""];
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
        friendIncome=number;
        [incomeTextField setText:text];
    }
    
    return NO; // we return NO because we have manually edited the textField contents.
}

-(BOOL)textFieldShouldClear:(UITextField*)textField
{
    friendIncome=0;
    return YES;
}


@end