//
//  ViewController.m
//  KeyboardHelperDemo
//
//  Created by Shaikh Sonny Aman on 7/23/12.
//  Copyright (c) 2012 Bonn-Rhien-Sieg University of Applied Science. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize kbHelper, txtHideable, txtVisible;

- (void)viewDidLoad{
    [super viewDidLoad];
	
	self.kbHelper = [[KeyboardHelper alloc] initWithViewController:self onDoneSelector:@selector(onDone)];
	
	// using block
//	self.kbHelper = [[KeyboardHelper alloc] initWithViewController:self onDoneAction:^(void){
//		NSLog(@"On Done!!");
//	}];
}

- (void) onDone{
	NSLog(@"On Done!!");
}

- (void) viewWillAppear:(BOOL)animated{
	[self.kbHelper enable];
}
- (void) viewWillDisappear:(BOOL)animated{
	[self.kbHelper disable];
}

- (void)viewDidUnload{
    [super viewDidUnload];
	self.txtHideable = nil;
	self.txtVisible = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	//[self.view layoutSubviews];
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onHideShow:(id)sender{
	UIButton* btn = (UIButton*)sender;
	if (btn.selected) {
		btn.selected = NO;
		txtHideable.hidden = NO;
		[kbHelper reload];
		
	} else {
		txtHideable.hidden = YES;
		btn.selected = YES;
		[kbHelper reload];
	}
}

- (IBAction)onAlpha:(id)sender{
	UIButton* btn = (UIButton*)sender;
	if (btn.selected) {
		btn.selected = NO;
		txtVisible.alpha = 1;
		[kbHelper reload];
		
	} else {
		txtVisible.alpha = 0;
		btn.selected = YES;
		[kbHelper reload];
	}
}
@end
