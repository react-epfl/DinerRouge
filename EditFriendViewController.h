//
//  EditFriendViewController.h
//  DinerRouge
//
//  Created by Adrian Holzer on 26.10.12.
//  Copyright (c) 2012 Adrian Holzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface EditFriendViewController : UIViewController<UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    CIContext *context;
    NSMutableArray *filters;
    CIImage *beginImage;
    UIScrollView *filtersScrollView;
    UIView *selectedFilterView;
    NSNumber* friendIncome;
    
    // UIImage *finalImage;
    
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;

-(IBAction) saveButtonTouched:(id) sender;
-(IBAction) deleteButtonTouched:(id) sender;
-(IBAction) takePicture:(id) sender;

//@property(strong, nonatomic)  NSArray * avatarNames;
@property(strong, nonatomic)  Friend * friend;

@property(nonatomic)  BOOL  isEditingExistingFriend;
@property(nonatomic)  NSInteger  indexOfAvatarCurrentlyDisplayed;
@property(strong, nonatomic) IBOutlet UIScrollView * imageScrollView;
@property(strong, nonatomic) IBOutlet UIButton * imageButton;
@property(strong, nonatomic) IBOutlet UIButton * saveButton;
@property(strong, nonatomic) IBOutlet UIButton * deleteButton;
@property(strong, nonatomic) IBOutlet UITextField * incomeTextField;
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *numberOfFriendslabel;
@property (strong, nonatomic) IBOutlet UILabel *yourPhotoLabel;
@property(strong, nonatomic) IBOutlet UIButton * cameraButton;

@property (nonatomic,weak) IBOutlet UIView *swipeView;

@end
