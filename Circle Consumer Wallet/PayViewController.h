//
//  PayViewController.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
- (IBAction)btnPayClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
