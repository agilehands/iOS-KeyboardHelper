//
//  KeyboardHelper.m
//  KeyboardHelperDemo
//
//  Created by Shaikh Sonny Aman on 7/23/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import "KeyboardHelper.h"

@implementation KeyboardHelper
@synthesize textFieldsAndViews, barHelper, barButtonSetAtFirst, barButtonSetAtLast, barButtonSetNormal;
@synthesize textViewDelegate, textFieldDelegate, selectedTextFieldOrView;
@synthesize onDoneBlock, onDoneSelector, viewController;
@synthesize initialFrame, kbRect, distanceFromKeyBoardTop, shouldSelectNextOnEnter;

- (id) initWithViewController:(UIViewController*)vc onDoneSelector:(SEL)done{
	self = [self initWithViewController:vc];
	if (self) {
		self.onDoneSelector = done;
	}
	return self;
}
- (id) initWithViewController:(UIViewController*)vc onDoneAction:(t_KeyboardHelperOnDone)onDone{
	self = [self initWithViewController:vc];
	if (self) {		
		self.onDoneBlock = onDone;
	}
	return self;
}

- (id) initWithViewController:(UIViewController*)vc{
	if ( !vc.isViewLoaded ) {
		[NSException raise:@"KeyboardHelperException" format:@"KeyboardHelper Error: View not loaded.\n Initialize keyboard helper in viewDidLoad method."];
		return nil;
	}
	
	self = [super init];
	if (self) {
		self.viewController = vc;
		self.distanceFromKeyBoardTop = 5;
		self.shouldSelectNextOnEnter = YES;
		
//		NSLog(@"Initial frame: %@", NSStringFromCGRect(vc.view.frame));
		self.initialFrame = vc.view.frame;
		statusBarHeight = 0;
		if (![UIApplication sharedApplication].isStatusBarHidden) {
			CGRect rect =   [[UIApplication sharedApplication] statusBarFrame];
			initialFrame.origin.y += rect.size.height;	
			statusBarHeight = rect.size.height;
		}		
		
		self.barHelper = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		barHelper.barStyle = UIBarStyleBlack;
		
		UIBarButtonItem* btnPrev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" 
																	style:UIBarButtonItemStyleBordered
																   target:self 
																   action:@selector(onPrev:)];
		
		UIBarButtonItem* btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
																	style:UIBarButtonItemStyleBordered
																   target:self 
																   action:@selector(onNext:)];
		
		UIBarButtonItem* btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	style:UIBarButtonItemStyleDone
																   target:self 
																   action:@selector(onDone:)];
		UIBarButtonItem* seperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				   target:nil
																				   action:NULL];
		self.barButtonSetNormal = [NSArray arrayWithObjects:btnPrev, seperator, btnNext, btnDone, nil];
		self.barButtonSetAtFirst = [NSArray arrayWithObjects:seperator, btnNext, btnDone, nil];
		self.barButtonSetAtLast = [NSArray arrayWithObjects:btnPrev, seperator, btnDone, nil];
				
		
		self.textFieldsAndViews = [NSMutableArray new];
		for (UIView* aview in viewController.view.subviews) {
			if ([aview isKindOfClass:[UITextField class]] || [aview isKindOfClass:[UITextView class]]) {
				if([aview respondsToSelector:@selector(setInputAccessoryView:)]){
					[aview performSelector:@selector(setInputAccessoryView:) withObject:self.barHelper];
				}
				
				[aview performSelector:@selector(setDelegate:) withObject:self];
				[textFieldsAndViews addObject:aview];
			}
		}
		
		// order
		[textFieldsAndViews sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
			CGPoint origin1 = [(UIView*)obj1 frame].origin;
			CGPoint origin2 = [(UIView*)obj2 frame].origin;			
			
			if (origin1.y < origin2.y || origin1.x < origin2.x){
				return  NSOrderedAscending;
			}			
			return NSOrderedDescending;
		}];
		
		enabled = NO;
		[self enable];
						
	}
	return self;
}
- (void) enable{
	if (!enabled) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification
												   object:nil];
		enabled = YES;
	}
		
}
- (void) disable{
	if (enabled) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		enabled = NO;
	}		
}
- (void) updateViewPosition{
	float kbTopY = kbRect.origin.y;
	float visibleYWithPadding = kbTopY - distanceFromKeyBoardTop - statusBarHeight;
	CGRect txtFrame =  [selectedTextFieldOrView frame];
	float visibleY = visibleYWithPadding - txtFrame.size.height;	
	
	CGRect currentFrame =   viewController.view.frame;	
	
	CGRect newFrame = initialFrame;
	
	if (selectedTextFieldOrView.frame.origin.y > visibleY ) {
		UIInterfaceOrientation orientation = viewController.interfaceOrientation;
		
		if (UIInterfaceOrientationIsPortrait(orientation)) {
			float offset = initialFrame.origin.y - currentFrame.origin.y;
			float diff = txtFrame.origin.y - visibleY - offset;	
			if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
				newFrame = CGRectMake(currentFrame.origin.x
									  , currentFrame.origin.y + diff /* update y */
									  , currentFrame.size.width, 
									  currentFrame.size.height);
			} else {
				newFrame = CGRectMake(currentFrame.origin.x
									  , currentFrame.origin.y - diff /* update y */
									  , currentFrame.size.width, 
									  currentFrame.size.height);
			}
			
			
		} else {
			
			
			if (orientation == UIInterfaceOrientationLandscapeRight) {
				NSLog(@"KeyboardHelper: TBD: LandScape Mode");
			} else {
				float offset = initialFrame.origin.x - currentFrame.origin.x;
				float diff = txtFrame.origin.y - visibleY - offset;	
				newFrame = CGRectMake(currentFrame.origin.x - diff + kbRect.origin.x
									  , currentFrame.origin.y/* update y */
									  , currentFrame.size.width, 
									  currentFrame.size.height);
			}
			
		}
		
	}		
	if (!CGRectEqualToRect(newFrame, currentFrame)) {
		[UIView animateWithDuration:0.3
						 animations:^(void){
							 viewController.view.frame = newFrame;
						 }];
	}
}
- (void) updateBarHelper{	
	if (!CGRectIsEmpty(self.kbRect)) {
		[self updateViewPosition];
	}	
	
	id obj = [textFieldsAndViews objectAtIndex:0];
	if ([obj isFirstResponder]) {
		[barHelper setItems:self.barButtonSetAtFirst animated:YES];
	} else if ( [[textFieldsAndViews lastObject] isFirstResponder] ) {
		[barHelper setItems:self.barButtonSetAtLast animated:YES];
	} else {
		[barHelper setItems:self.barButtonSetNormal animated:YES];
	}
}

- (void) onNext:(id)sender{
	if ( selectedTextFieldOrView != [textFieldsAndViews lastObject]) {
		int index = [textFieldsAndViews indexOfObject:selectedTextFieldOrView];
		id nextObj = [textFieldsAndViews objectAtIndex:index + 1];
		[nextObj becomeFirstResponder];
	}
	
}
- (void) onPrev:(id)sender{
	if ( selectedTextFieldOrView != [textFieldsAndViews objectAtIndex:0]) {
		int index = [textFieldsAndViews indexOfObject:selectedTextFieldOrView];
		id nextObj = [textFieldsAndViews objectAtIndex:index - 1];
		[nextObj becomeFirstResponder];
	}
}
- (void) onDone:(id)sender{
	[selectedTextFieldOrView resignFirstResponder];
	if (self.onDoneSelector) {
		if ([viewController respondsToSelector:onDoneSelector]) {
			#pragma clang diagnostic push
			#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
						[viewController performSelector:onDoneSelector];
			#pragma clang diagnostic pop
			
		}
	} else if ( self.onDoneBlock) {
		onDoneBlock();
	}
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	self.selectedTextFieldOrView = textField;
	[self updateBarHelper];
	
	if (self.textFieldDelegate) {
		[textFieldDelegate textFieldShouldBeginEditing:textField];
	}
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
	self.selectedTextFieldOrView = textView;
	[self updateBarHelper];
	if (self.textViewDelegate) {
		[textViewDelegate textViewShouldBeginEditing:textView];
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (shouldSelectNextOnEnter) {
		[self onNext:nil];
	}
	return YES;
}
#pragma mark - KeyBoard notifications
- (void) keyboardWillShow:(NSNotification*)notify{	
	 self.kbRect = [(NSValue*)[notify.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
	[self updateViewPosition];	
}
- (void) keyboardWillHide:(NSNotification*)notify{
	[UIView animateWithDuration:0.25 
					 animations:^(void){						 
						 self.viewController.view.frame = initialFrame;
					 }];	
}
@end
