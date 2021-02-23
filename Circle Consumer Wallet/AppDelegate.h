//
//  AppDelegate.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/22/21.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSString *scanText; // the entire content of the QR code scanned 
@property (strong, nonatomic) NSString *CIRCLE_API_KEY; // the entire content of the QR code scanned
@property (strong, nonatomic) NSString *CIRCLE_API_BASE_URL; // the entire content of the QR code scanned
@property (strong, nonatomic) NSString *CONSUMER_WALLET_ID; // the entire content of the QR code scanned

@end


