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
@synthesize kbHelper;

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
- (void) viewDidDisappear:(BOOL)animated{
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	//[self.view layoutSubviews];
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
