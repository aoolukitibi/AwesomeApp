//
//  ViewController.h
//  AwesomeApp
//
//  Created by Vivian Aranha on 10/15/13.
//  Copyright (c) 2013 Vivian Aranha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureInput.h>

@interface ViewController : UIViewController  {
    
    IBOutlet UIImageView *theAwesome;
    UIImageView *animationView;
    AVCaptureStillImageOutput *stillImageOutput;
    
    IBOutlet UIButton *awesomeButton;
    IBOutlet UIButton *notSoAwesomeButton;
    
    IBOutlet UIView *theView;
    BOOL front;
}

-(IBAction) pickFrontCamera;
-(IBAction) pickBackCamera;

@end
