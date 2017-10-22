//
//  ViewController.m
//  ParallaxImage
//
//  Created by Philipp Homann on 23.10.15.
//  Copyright © 2015 Philipp Homann. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (assign) CGFloat maxAngle;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;


@implementation ViewController


- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)]];
    [_vwImageLT addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
    
    if (_switchBtn.on)
    {
        for (UIImageView* view in _allViews)
        {
            view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
            view.layer.masksToBounds = NO;
            view.layer.shadowOffset = CGSizeMake(15, 20);
            view.layer.shadowRadius = 5;
            view.layer.shadowOpacity = 0.5;
        }
    }
    
    
    self.motionManager = [[CMMotionManager alloc] init];
//    self.motionManager.accelerometerUpdateInterval = .2;
//    self.motionManager.gyroUpdateInterval = .2;
    
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 CGPoint angle = CGPointMake(accelerometerData.acceleration.y * _maxAngle, accelerometerData.acceleration.x * _maxAngle);
                                                 
                                                 [self rotateByAccelerometer:angle];
                                                 
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];


}



- (void) setupDefaults
{
    _maxAngle = 45;
}

- (bool) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


- (void) rotateByAccelerometer:(CGPoint) angle
{
    if (_segmenter.selectedSegmentIndex == 1)
    {
        [self rotateByAngel:angle];
    }
}

- (void) rotateByPan:(CGPoint) angle
{
    if (_segmenter.selectedSegmentIndex == 0)
    {
        [self rotateByAngel:angle];
    }
    
}

- (void) rotateByAngel:(CGPoint) angle
{

    CATransform3D t1 = CATransform3DIdentity;
    //Add perspective!!!
    t1.m34 = 1.0/ -10000;
    
    if(angle.x > 0)
    {
        if (angle.x > _maxAngle)
            angle.x = _maxAngle;
        //NSLog(@"gesture went right");
    }
    else
    {
        if (angle.x < _maxAngle*-1)
            angle.x = _maxAngle*-1;
        
        //NSLog(@"gesture went left");
    }
    t1 = CATransform3DRotate(t1, DEGREES_TO_RADIANS(angle.x), 0, 1, 0);
    //  _vwImage.layer.transform = t1;
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0/ -10000;
    if(angle.y > 0)
    {
        if (angle.y > _maxAngle)
            angle.y = _maxAngle;
        //NSLog(@"gesture went top");
    }
    else
    {
        if (angle.y < _maxAngle*-1)
            angle.y = _maxAngle*-1;
        
        //NSLog(@"gesture went bottom");
    }
    t2 = CATransform3DRotate(t2, DEGREES_TO_RADIANS(angle.y*-1), 1, 0, 0);
    // _vwImage.layer.transform = t2;
    
    for (UIImageView* view in _topViews)
    {
        view.layer.transform = CATransform3DConcat(t1, t2);
    }
    
    _vwParentBottom.layer.transform = CATransform3DConcat(t1, t2);
    
    
    if (_switchBtn.on == YES)
    {
        for (UIImageView* view in _allViews)
        {
            view.layer.shadowOffset = CGSizeMake(15-angle.x, 20-angle.y);
        }
    }

}


- (void) onPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint angle = translation;
        [self  rotateByPan:angle ];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (_segmenter.selectedSegmentIndex == 0)
        {
    //        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath: @"transform"];
            
            CATransform3D t = CATransform3DIdentity;
            t.m34 = 0;
            t = CATransform3DRotate(t, 0, 1, 1, 0);
            for (UIImageView* view in _topViews)
            {
                view.layer.transform = t;
            }
            
            _vwParentBottom.layer.transform = t;


            if (_switchBtn.on == YES)
            {
                for (UIImageView* view in _allViews)
                {
                    view.layer.shadowOffset = CGSizeMake(15, 20);
                }
            }

            
    //        transformAnimation.toValue = [NSValue valueWithCATransform3D:t];
    //        transformAnimation.duration = 3.3;
    //        [_vwImage.layer addAnimation:transformAnimation forKey:@"transform"];
        }

    }
}




- (void) onTap:(UIGestureRecognizer *)gestureRecognizer
{
    CATransform3D t = CATransform3DIdentity;
    //Add perspective!!!
    t.m34 = 1.0/ -200;
    t = CATransform3DRotate(t, 45, 1, 0, 0); // top
//    t = CATransform3DRotate(t, -45, 1, 0, 0); // bottom
    _vwImageLT.layer.transform = t;
    

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchOnChange:(id)sender
{
    if (_switchBtn.on == NO)
    {
        for (UIImageView* view in _allViews)
        {
            view.layer.shadowOpacity = 0;
        }
    }
    else
    {
        for (UIImageView* view in _allViews)
        {
            view.layer.shadowOpacity = 0.5;
        }
    }

}
@end
