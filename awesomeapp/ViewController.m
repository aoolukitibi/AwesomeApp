//
//  ViewController.m
//  AwesomeApp
//
//  Created by Vivian Aranha on 10/15/13.
//  Copyright (c) 2013 Vivian Aranha. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


- (void) initializeCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = theView.bounds;
	[theView.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = theView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *theCamera;
    
    if(front){
        NSLog(@"front");
    } else {
        NSLog(@"back");
    }
    if(front){
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionFront) {
                theCamera = device;
            }
        }
    } else {
        for (AVCaptureDevice *device in devices) {
            if ([device position] == AVCaptureDevicePositionBack) {
                theCamera = device;
            }
        }
    }
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:theCamera error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
   
    

    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
}

- (IBAction) pickFrontCamera { //method to capture image from AVCaptureSession video feed
    
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"tmp-0.gif"],
                             [UIImage imageNamed:@"tmp-1.gif"],
                             [UIImage imageNamed:@"tmp-2.gif"],
                             [UIImage imageNamed:@"tmp-3.gif"],
                             [UIImage imageNamed:@"tmp-4.gif"],
                             [UIImage imageNamed:@"tmp-5.gif"],
                             [UIImage imageNamed:@"tmp-6.gif"],
                             [UIImage imageNamed:@"tmp-7.gif"],
                             [UIImage imageNamed:@"tmp-8.gif"],
                             [UIImage imageNamed:@"tmp-9.gif"],
                             [UIImage imageNamed:@"tmp-10.gif"],
                             [UIImage imageNamed:@"tmp-11.gif"],
                             nil];
    animationView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 173,280, 283)];
    animationView.backgroundColor=[UIColor purpleColor];
    animationView.animationImages=animationArray;
    animationView.animationDuration=1.0;
    animationView.animationRepeatCount=0;
    [animationView startAnimating];
    [self.view addSubview:animationView];

    

    
    awesomeButton.enabled = NO;
    notSoAwesomeButton.enabled = NO;
    front = YES;
    [self initializeCamera];
    
    [self performSelector:@selector(takePic) withObject:nil afterDelay:2];
}

- (IBAction) pickBackCamera { //method to capture image from AVCaptureSession video feed
    
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"tmp-0.gif"],
                             [UIImage imageNamed:@"tmp-1.gif"],
                             [UIImage imageNamed:@"tmp-2.gif"],
                             [UIImage imageNamed:@"tmp-3.gif"],
                             [UIImage imageNamed:@"tmp-4.gif"],
                             [UIImage imageNamed:@"tmp-5.gif"],
                             [UIImage imageNamed:@"tmp-6.gif"],
                             [UIImage imageNamed:@"tmp-7.gif"],
                             [UIImage imageNamed:@"tmp-8.gif"],
                             [UIImage imageNamed:@"tmp-9.gif"],
                             [UIImage imageNamed:@"tmp-10.gif"],
                             [UIImage imageNamed:@"tmp-11.gif"],
                             nil];
    animationView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 173,280, 283)];
    animationView.backgroundColor=[UIColor purpleColor];
    animationView.animationImages=animationArray;
    animationView.animationDuration=1.0;
    animationView.animationRepeatCount=0;
    [animationView startAnimating];
    [self.view addSubview:animationView];
    
    front = NO;
    [self initializeCamera];

    
 
    
    [self performSelector:@selector(takePic) withObject:nil afterDelay:2];
}


-(void) takePic{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) { //Device is ipad
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(768, 1022));
        [image drawInRect: CGRectMake(0, 0, 768, 1022)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 130, 768, 768);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        //or use the UIImage wherever you like
        
        [theAwesome setImage:[UIImage imageWithCGImage:imageRef]];
        awesomeButton.enabled = YES;
        notSoAwesomeButton.enabled = YES;

        CGImageRelease(imageRef);
        [animationView removeFromSuperview];
        
    }else{ //Device is iphone
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(320, 426));
        [image drawInRect: CGRectMake(0, 0, 320, 426)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 55, 320, 320);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [theAwesome setImage:[UIImage imageWithCGImage:imageRef]];
        awesomeButton.enabled = YES;
        notSoAwesomeButton.enabled = YES;

        CGImageRelease(imageRef);
        [animationView removeFromSuperview];
    }
    
    //adjust image orientation based on device orientation
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"landscape left image");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        NSLog(@"landscape right");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"upside down");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
        
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        NSLog(@"upside upright");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];
    }    
}
@end
