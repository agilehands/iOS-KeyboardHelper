//
//  KeyboardHelper.h
//  KeyboardHelperDemo
//
//  Created by Shaikh Sonny Aman on 7/23/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^t_KeyboardHelperOnDone)(void);

@interface KeyboardHelper : NSObject<UITextFieldDelegate, UITextViewDelegate>{
	float statusBarHeight;
	BOOL enabled;
}

@property (nonatomic, strong) NSMutableArray* textFieldsAndViews;

@property (nonatomic, strong) UIToolbar* barHelper;
@property (nonatomic, strong) NSArray* barButtonSetNormal;
@property (nonatomic, strong) NSArray* barButtonSetAtFirst;
@property (nonatomic, strong) NSArray* barButtonSetAtLast;

@property (nonatomic, assign) id<UITextViewDelegate> textViewDelegate;
@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, assign) UIView* selectedTextFieldOrView;

@property (nonatomic, strong) t_KeyboardHelperOnDone onDoneBlock;
@property (nonatomic, assign) SEL onDoneSelector;
@property (nonatomic, assign) UIViewController* viewController;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) CGRect kbRect;
@property (nonatomic, assign) float distanceFromKeyBoardTop;
@property (nonatomic, assign) BOOL shouldSelectNextOnEnter;


- (id) initWithViewController:(UIViewController*)viewController;
- (id) initWithViewController:(UIViewController*)viewController onDoneSelector:(SEL)done;
- (id) initWithViewController:(UIViewController*)viewController onDoneAction:(t_KeyboardHelperOnDone)onDone;
- (void) enable;
- (void) disable;

@end
