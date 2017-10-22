//
//  ViewController.h
//  ParallaxImage
//
//  Created by Philipp Homann on 23.10.15.
//  Copyright © 2015 Philipp Homann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *vwImageLT;
@property (weak, nonatomic) IBOutlet UIImageView *vwImageRT;
@property (weak, nonatomic) IBOutlet UIImageView *vwImageLB;
@property (weak, nonatomic) IBOutlet UIImageView *vwImageRB;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *topViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bottomViews;
@property (weak, nonatomic) IBOutlet UIView *vwParentBottom;
- (IBAction)switchOnChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *allViews;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmenter;


@end

