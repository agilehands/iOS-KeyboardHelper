//
//  ViewController.h
//  KeyboardHelperDemo
//
//  Created by Shaikh Sonny Aman on 7/23/12.
//  Copyright (c) 2012 XappLab!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardHelper.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) KeyboardHelper* kbHelper;
@property (nonatomic, strong) IBOutlet UITextField* txtHideable;
@property (nonatomic, strong) IBOutlet UITextField* txtVisible;
- (IBAction)onHideShow:(id)sender;
- (IBAction)onAlpha:(id)sender;
@end
