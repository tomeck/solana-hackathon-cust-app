//
//  ScanViewController.m
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//

#import "ScanViewController.h"
#import "UIUtils.h"
#import "AppDelegate.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureSession = nil;
    
    _isReading = NO;
    
    [self loadBeepSound];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startReading];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopReading];
}

-(BOOL)startReading {
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    
    if (captureDevice.position == AVCaptureDevicePositionBack) {
        
        NSLog(@"back camera");
        
        
        
    }else if (captureDevice.position == AVCaptureDevicePositionFront){
        
        NSLog(@"Front Camera");
        
        
        
    }else{
        
        NSLog(@"Unspecified");
        
    }
    
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
        
    {
        
        NSLog(@"%@", [error localizedDescription]);
        
        return NO;
        
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    [_captureSession addInput:input];
    
    
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    [_captureSession addOutput:captureMetadataOutput];
    
    
    
    dispatch_queue_t dispatchQueue;
    
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_videoPreviewLayer setFrame:_viewforCamera.layer.bounds];
    
    [_viewforCamera.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    _isReading = YES;
    
    return YES;
}

-(void)stopReading{
    
    [_captureSession stopRunning];
    
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

//- (IBAction)startButtonClicked:(UIButton *)sender {
//    if (!_isReading)
//        
//    {
//        
//        if ([self startReading])
//            
//        {
//            
//            //            [_lblStatus setText:@"Scanning for QR Code..."];
//            
//        }
//        
//    }
//    
//    else
//        
//    {
//        
//        [self stopReading];
//        
//    }
//    
//    
//    
//    _isReading = !_isReading;
//}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        // Did we read a QR code?
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            // Grab the encoded string
            NSString* text = [metadataObj stringValue];
            
            // Store it in AppDelegate so the rest of app can access it (JTE TODO this is a HACK!)
            // We need to dispatch this to the main/UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.scanText = text;
            });
            
//            [_textView performSelectorOnMainThread:@selector(setText:) withObject:text waitUntilDone:NO];
            
            /*
            if ([text containsString:@"http"]) {
                
                
                NSURL *url  = [[NSURL alloc] initWithString:text];
                
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"This code have a http link.Do you want to open it.?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                           
                {
                    
                    [[UIApplication sharedApplication] openURL:url];
                    
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         
                {
                    
                    //                   _lblStatus.text = @"Your Text Will Shown Below.";
                    
                }];
                
                [alert addAction:cancel];
                
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
            }
            
            else
                
            {
                
            }
            */
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            // [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
            
            
            
            if (_audioPlayer)
                
            {
                
                [_audioPlayer play];
                
            }

            // JTE TODO - drive to the Payment View
            // We need to dispatch this to the main/UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"SegueToPayView" sender:self];
            });
        }
        
    }
    
}

-(void)loadBeepSound {
    
//    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//
//    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Setup to play beep sound
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep1" ofType:@"mp3"]] error:&error];

    
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    
    if (error)
        
    {
        
        NSLog(@"Could not play beep file.");
        
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    else
        
    {
        
        [_audioPlayer prepareToPlay];
        
    }
    
}

- (IBAction)btnCancelClicked:(id)sender {
    
    // Close this window
    // We need to dispatch this to the main/UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}



-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    NSLog(@"test");
    if(item.tag==2)
    {

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *TimeLine = [mainStoryboard instantiateViewControllerWithIdentifier:@"Post_Photo_One"];
        [self presentViewController:TimeLine animated:YES completion:nil];
    }
    else
    {
        //your code
    }
}
@end
