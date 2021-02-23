//
//  ViewController.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/22/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrency;

-(IBAction)unwindToNewTransactionViewController:(UIStoryboardSegue *)segue;


@end

