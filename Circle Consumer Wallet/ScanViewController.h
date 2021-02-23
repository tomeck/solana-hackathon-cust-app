//
//  ScanViewController.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewforCamera;


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

// Internal properties
@property (nonatomic) BOOL isReading;

//- (IBAction)startButtonClicked:(UIButton *)sender;
- (IBAction)btnCancelClicked:(id)sender;

-(void)loadBeepSound;
-(BOOL)startReading;
-(void)stopReading;

@end


NS_ASSUME_NONNULL_END
