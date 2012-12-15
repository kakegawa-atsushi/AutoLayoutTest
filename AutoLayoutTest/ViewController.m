//
//  ViewController.m
//  AutoLayoutTest
//
//  Created by KAKEGAWA Atsushi on 2012/11/24.
//  Copyright (c) 2012年 KAKEGAWA Atsushi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) UIView *view1;
@property (nonatomic) UIView *view2;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor greenColor];
    [view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view1];
    self.view1 = view1;
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor blueColor];
    [view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view2];
    self.view2 = view2;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view1, view2);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view1]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view1]-20-[view2]-|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view1(==view2)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view2
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:2.0f
                                                           constant:0.0f]];

// exerciseAmbiguityInLayout
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view1(>=10)]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view2(>=10)]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];        
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL hasAmbiguousLayout = [self.view2 hasAmbiguousLayout];
    NSLog(@"viewDidAppear: view2 has ambiguous layout: %@", hasAmbiguousLayout ? @"YES" : @"NO");
    NSArray *hDebugs = [self.view2 constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
    NSLog(@"viewDidAppear: %@", hDebugs);
    NSArray *vDebugs = [self.view2 constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical];
    NSLog(@"viewDidAppear: %@", vDebugs);
    if ([self.view2 hasAmbiguousLayout]) {
        NSLog(@"viewDidAppear: %@", [self.view2 translatesAutoresizingMaskIntoConstraints] ? @"YES" : @"NO");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDidTouch:(id)sender
{
    BOOL hasAmbiguousLayout = [self.view2 hasAmbiguousLayout];
    if (hasAmbiguousLayout) {
        [self.view2 exerciseAmbiguityInLayout];
    }
}
@end
