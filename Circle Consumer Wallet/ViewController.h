//
//  ViewController.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/22/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblAmt1;
@property (weak, nonatomic) IBOutlet UILabel *lblDate1;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus1;
@property (weak, nonatomic) IBOutlet UILabel *lblID1;
@property (weak, nonatomic) IBOutlet UILabel *lblAmt2;
@property (weak, nonatomic) IBOutlet UILabel *lblDate2;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus2;
@property (weak, nonatomic) IBOutlet UILabel *lblID2;

-(IBAction)unwindToNewTransactionViewController:(UIStoryboardSegue *)segue;


@end

