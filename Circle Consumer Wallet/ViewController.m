//
//  ViewController.m
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/22/21.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self getBalance];
    [self getRecentTransactions];
}


// This is here so we can support an unwind segue
// landing here
-(IBAction)unwindToNewTransactionViewController:(UIStoryboardSegue *)segue {
    [self getBalance];
    [self getRecentTransactions];
}


// Get the Consumer Wallet balance from Circle
- (void)getBalance {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Create NSURLSession object.
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a NSURL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/wallets/%@", appDelegate.CIRCLE_API_BASE_URL, appDelegate.CONSUMER_WALLET_ID]];
    //NSLog(@"%@", [NSString stringWithFormat:@"About to invoke %@", [url absoluteString]]);
    NSLog(@"About to invoke %@", [url absoluteString]);


    // Create post request object with the url.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Set request method to POST
    request.HTTPMethod = @"GET";
    // Set request body
    //request.HTTPBody = jsonBodyData;
    
    // Set auth header
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appDelegate.CIRCLE_API_KEY] forHTTPHeaderField:@"Authorization"];
    
    // Create the NSURLSessionDataTask post task object
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // We need to dispatch this to the main/UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( error ) {
                NSLog( @"Failed to obtain balance for Wallet ID for %@, error = %@", appDelegate.CONSUMER_WALLET_ID, error );
            }
            else {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
                long httpStatus = httpResp.statusCode;
                
                if( httpStatus != 200) {
                    NSLog( @"Failed to obtain balance for Wallet ID for %@, httpStatus = %ld", appDelegate.CONSUMER_WALLET_ID, httpStatus );
                }
                else {
                    
                    // Deserialize the Http response into NSDictionary
                    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    // And dump the dictionary
                    NSLog(@"%@", dictResponse);
                    self.lblBalance.text = dictResponse[@"data"][@"balances"][0][@"amount"];
                    self.lblCurrency.text = dictResponse[@"data"][@"balances"][0][@"currency"];
                }
            }
        });
    }];
    
    // Execute the task
    [task resume];
}

- (void)getRecentTransactions {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Create NSURLSession object.
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a NSURL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/transfers?sourceWallet=%@", appDelegate.CIRCLE_API_BASE_URL, appDelegate.CONSUMER_WALLET_ID]];
    //NSLog(@"%@", [NSString stringWithFormat:@"About to invoke %@", [url absoluteString]]);
    NSLog(@"About to invoke %@", [url absoluteString]);


    // Create post request object with the url.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Set request method to POST
    request.HTTPMethod = @"GET";
    // Set request body
    //request.HTTPBody = jsonBodyData;
    
    // Set auth header
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appDelegate.CIRCLE_API_KEY] forHTTPHeaderField:@"Authorization"];
    
    // Create the NSURLSessionDataTask post task object
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // We need to dispatch this to the main/UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( error ) {
                NSLog( @"Failed to obtain balance for Wallet ID for %@, error = %@", appDelegate.CONSUMER_WALLET_ID, error );
            }
            else {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
                long httpStatus = httpResp.statusCode;
                
                if( httpStatus != 200) {
                    NSLog( @"Failed to obtain balance for Wallet ID for %@, httpStatus = %ld", appDelegate.CONSUMER_WALLET_ID, httpStatus );
                }
                else {
                    
                    // Deserialize the Http response into NSDictionary
                    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    // And dump the dictionary
                    NSLog(@"%@", dictResponse);
                    
                    //
                    // Load up the recent history
                    // Most recent txn
                    self.lblAmt1.text = [NSString stringWithFormat:@"%@  %@", dictResponse[@"data"][0][@"amount"][@"amount"], dictResponse[@"data"][0][@"amount"][@"currency"]];
                    self.lblDate1.text = dictResponse[@"data"][0][@"createDate"];
                    self.lblStatus1.text = dictResponse[@"data"][0][@"status"];
                    self.lblID1.text = dictResponse[@"data"][0][@"id"];

                    // Prior txn
                    self.lblAmt2.text = [NSString stringWithFormat:@"%@  %@", dictResponse[@"data"][1][@"amount"][@"amount"], dictResponse[@"data"][1][@"amount"][@"currency"]];
                    self.lblDate2.text = dictResponse[@"data"][1][@"createDate"];
                    self.lblStatus2.text = dictResponse[@"data"][1][@"status"];
                    self.lblID2.text = dictResponse[@"data"][1][@"id"];
                }
            }
        });
    }];
    
    // Execute the task
    [task resume];
}

@end
