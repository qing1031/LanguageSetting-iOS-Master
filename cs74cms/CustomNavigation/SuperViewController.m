//
//  SuperViewController.m
//  myFirstPro
//
//  Created by zwh on 14-3-27.
//  Copyright (c) 2014年 zwh. All rights reserved.
//

#import "SuperViewController.h"
#import "InitData.h"
#import "T_Interface.h"

@implementation SuperViewController

@synthesize myNavigationController=_myNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewCanBeSee{
    
}

- (void)viewCannotBeSee{
    
}

- (void) nextViewController{
}

@end
