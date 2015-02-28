//
//  WOTCameraViewController.m
//  Wine'ot
//
//  Created by Werck Ayrton on 04/11/2014.
//  Copyright (c) 2014 wineot. All rights reserved.
//

#import "Animations.h"
#import "WOTCameraViewController.h"
#import "SWRevealViewController.h"
#import "WOTDisplayBottleTableTableViewController.h"
#import "WOTManagedObject.h"

@interface WOTCameraViewController ()

@property (strong, nonatomic) MBProgressHUD              *hud;
@property (strong, nonatomic) IBOutlet                UIView                     *viewCamera;
@property (strong, nonatomic) IBOutlet                UIButton                   *buttonTakePhoto;
@property (strong, nonatomic) IBOutlet                UIButton                   *buttonSendImage;
@property (strong, nonatomic) IBOutlet                UIButton *cancelPhoto;
@property (strong, nonatomic) NSString                  *idWine;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UIImageView                *capturedImageView;
@property (readwrite)         BOOL                       isTriggered;
@property (strong, nonatomic) AVCaptureSession          *session;

- (IBAction)buttonTakePhotoOnClick:(id)sender;
- (IBAction)buttonSendPhotoOnClick:(id)sender;
- (IBAction)menuButtonOnClick:(id)sender;
- (IBAction)cancelTakePhoto:(id)sender;

@end

@implementation WOTCameraViewController

@synthesize hud;
@synthesize client;
@synthesize viewCamera;
@synthesize buttonSendImage;
@synthesize buttonTakePhoto;
@synthesize idWine;
@synthesize previewLayer;
@synthesize capturedImageView;
@synthesize isTriggered;



#pragma Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewLayer                                    = nil;
    //Activity Indicator
    self.hud                                             = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden                                      = TRUE;
    self.buttonSendImage.hidden                          = TRUE;
    [self.view bringSubviewToFront:self.buttonTakePhoto];
    [self.view bringSubviewToFront:self.buttonSendImage];
    self.cancelPhoto.titleLabel.text = NSLocalizedString(@"Cancel", nil);
    [self.view bringSubviewToFront:self.cancelPhoto];
    isTriggered = NO;
    [self.view layoutSubviews];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initCameraView];
    self.parentViewController.tabBarController.tabBar.hidden =TRUE;
}

- (void) viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
    self.parentViewController.tabBarController.tabBar.hidden = NO;
    [self releaseCapturedImageView];
}

#pragma mark ->Init and realease camera
//Release photo and reset parameters such as buttonSendImage
- (void) releaseCapturedImageView
{
    self.buttonSendImage.hidden                          = TRUE;
    [self.capturedImageView removeFromSuperview];
    self.capturedImageView                               = nil;
    [self.buttonTakePhoto setImage:[UIImage imageNamed:@"takePhoto"] forState:UIControlStateNormal];
    isTriggered = NO;
    if (self.session)
    {
        [self.session stopRunning];
        self.session = nil;
    }
}

//Method that init the camera and set self.previewLayer correctly. Parameters of the session are defined here
- (void) initCameraView
{
   // NSLog(@"Width: %f, Height: %f", self.viewCamera.frame.size.width, self.viewCamera.frame.size.height);

    AVCaptureSession *session                            = [[AVCaptureSession alloc] init];
    AVCaptureStillImageOutput *output                    = [[AVCaptureStillImageOutput alloc] init];
    [session addOutput:output];
    //Setup camera input
    NSArray *possibleDevices                             = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //We could check for front or back camera here, but for simplicity just grab the first device
    if ([possibleDevices count] < 1)
        return;
    //0 camera arriere
    AVCaptureDevice *device                              = [possibleDevices objectAtIndex:0];
    NSError *error                                       = nil;
    // create an input and add it to the session
    AVCaptureDeviceInput* input                          = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];//Handle errors
    if (error)
    {
        NSLog(@"Error during camera initialization: %@", [error localizedDescription]);
        return;
    }
    //Or other preset supported by the input device, this one is good for high quality
    //set the session preset
    session.sessionPreset                                = AVCaptureSessionPresetPhoto;
    [session addInput:input];
    //Set the preview layer frame which will be added to the view
    if (self.previewLayer)
        self.previewLayer = nil;
    self.previewLayer                                    = [AVCaptureVideoPreviewLayer layerWithSession:session];
    //Set the Aspect  aspect fill i dont know yet, Aspect fill stretch the image
   // self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.previewLayer.videoGravity                       = AVLayerVideoGravityResizeAspectFill;// AVLayerVideoGravityResizeAspect;

    self.previewLayer.contentsGravity                    = kCAGravityResizeAspect;
    //Use bound for viewcamera because we draw it inside viewcamera so we need absolute coordinates contrary to frame
    self.previewLayer.frame                              = self.viewCamera.bounds;//CGRectMake(0, 0, self.viewCamera.frame.size.width, self.viewCamera.frame.size.height);
    //Now add this layer to a view of your view controller
    [self.viewCamera.layer addSublayer:self.previewLayer];
    [Animations addMaskExpandleRectAnimation:self.viewCamera duration:1.0f];
    [session startRunning];
    self.session = session;
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([[segue identifier] isEqualToString:@"DisplayWine"])
     {
    UINavigationController *nav                          = (UINavigationController*)[segue destinationViewController];
    WOTDisplayBottleTableTableViewController *dispWineVC = [[nav viewControllers] objectAtIndex:0];
         dispWineVC.idWine                               = self.idWine;
     }

 }


#pragma mark - Button Event

//button that trigger the shooting
- (IBAction)buttonTakePhotoOnClick:(id)sender
{
    
    if(self.isTriggered == YES)
    {
        [self.capturedImageView removeFromSuperview];
        self.capturedImageView = nil;
        [self.viewCamera.layer addSublayer:self.previewLayer];
        self.isTriggered = NO;
        self.buttonSendImage.hidden                          = TRUE;
        [self.buttonTakePhoto setImage:[UIImage imageNamed:@"takePhoto"] forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonTakePhoto setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        AVCaptureConnection *videoConnection                 = nil;
        AVCaptureStillImageOutput *stillImageOutput          = [self.previewLayer.session.outputs objectAtIndex:0];
        for (AVCaptureConnection *connection in stillImageOutput.connections)
        {
            for (AVCaptureInputPort *port in [connection inputPorts])
            {

                if ([[port mediaType] isEqual:AVMediaTypeVideo] )
                {
    videoConnection                                      = connection;
                    break;
                }
            }

            if (videoConnection)
            {
                break;
            }
        }
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
         {
             if (imageSampleBuffer != NULL)
             {
                 NSData *imageData                                    = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                 [self processImage:[UIImage imageWithData:imageData]];
             }
         }];
        isTriggered = YES;
    }
}

// button onclick send button: trigger sending of the photo to the server
- (IBAction)buttonSendPhotoOnClick:(id)sender
{
    if (self.capturedImageView && self.capturedImageView.image)
    {
    self.hud.labelText                                   = NSLocalizedString(@"Uploading photo", nil);
    self.hud.hidden                                      = FALSE;
     void (^successRecognition)(WOTBottle *bottle) = ^(WOTBottle *bottle)
        {
            self.idWine = bottle.idWine;
            [WOTManagedObject saveContext];
            if (self.hud.hidden == FALSE)
                self.hud.hidden                                      = TRUE;
            [self releaseCapturedImageView];
            [self performSegueWithIdentifier:@"DisplayWine" sender:self];
        };
        
        void (^failedRecognition)() = ^(NSDictionary *error)
        {
            if (self.hud.hidden == FALSE)
                self.hud.hidden                                      = TRUE;
            NSLog(@"Connection Fail, reason: %@, Status code: %@", [error valueForKey:@"errorRequest"], [error valueForKey:@"errorStatusCode"]);
            [self releaseCapturedImageView];
        };
        
        [WOTWineClient sendImageWithBlock:self.capturedImageView.image connectionSuccess:successRecognition connectionFailed:failedRecognition];
    }
}

- (void) cancelTakePhoto:(id)sender
{
    [self.parentViewController.tabBarController setSelectedIndex:0];
}


- (IBAction)menuButtonOnClick:(id)sender
{
    [self.revealViewController revealToggleAnimated:YES];
}

#pragma mark - Image Processing

//Process the image to make it fit the view where it supposed to appear in the UI
- (void) processImage:(UIImage *)image
{
    if (!image)
        return;
    //Defined the max size where to draw image (inside view) and the context
    UIGraphicsBeginImageContext(self.viewCamera.bounds.size);
    //AVMakeRect... allowed to respect ratio of the image and draw in rect, it draws it in the CGRECT returned by AVMakeRect
    //[image drawInRect:AVMakeRectWithAspectRatioInsideRect(image.size, self.viewCamera.bounds)];
    [image drawInRect:CGRectMake(0, 0, self.viewCamera.bounds.size.width, self.viewCamera.bounds.size.height)];
    UIImage *finalImage                                  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ///Do not set preview layer to nil we need to keep the flux
    [self.previewLayer removeFromSuperlayer];
    self.capturedImageView                               = [[UIImageView alloc]initWithImage:finalImage];
    self.capturedImageView.frame                         = self.viewCamera.bounds;
    self.capturedImageView.contentMode                   = UIViewContentModeScaleAspectFit;
    [self.viewCamera addSubview:self.capturedImageView];
    //Picture is taken ready to send
    self.buttonSendImage.hidden                          = FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
