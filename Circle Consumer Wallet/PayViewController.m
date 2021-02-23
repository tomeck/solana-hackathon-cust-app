//
//  PayViewController.m
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//

#import "PayViewController.h"
#import "AppDelegate.h"
#import "UIUtils.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup the contents of the payment button
    [self setupPayButton];
}

- (void) setupPayButton {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *scannedText = appDelegate.scanText;
    
    // Split the scanned text by the pipe delimiter
    NSArray *splits = [scannedText componentsSeparatedByString:@"|"];
//    NSString *chainAddress = splits[0];
    NSString *merchantName = splits[1];
    NSString *amount = splits[2];
    
    NSString *btnText = [NSString stringWithFormat:@"Pay %@ $%@ now", merchantName, amount];
    [self.btnPay setTitle:btnText forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCancelClicked:(id)sender {
    
    // Close this window
    // We need to dispatch this to the main/UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)btnPayClicked:(id)sender {

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *scannedText = appDelegate.scanText;
    
//    NSString *scannedText = @"FUoAafzWRYp8dsshzKqadN7QXGZQAJ6M5dc95jN1d9GJ|Sal's Pizza|23.45";
    
    NSDictionary *reqDict = [self getTransferDictForText:scannedText];
    
    // Create NSURLSession object.
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a NSURL object.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/transfers", appDelegate.CIRCLE_API_BASE_URL]];

    NSLog(@"About to invoke %@", [url absoluteString]);
    NSLog(@"Request body is %@", reqDict);
    
    // Convert NSDictionary that contains kv's into JSON and then encoded within NSData
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:reqDict options:kNilOptions error:nil];
 
    // Create post request object with the url.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Set request method to POST
    request.HTTPMethod = @"POST";
    // Set request body
    request.HTTPBody = jsonBodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];

    // Set auth header
    [request setValue:[NSString stringWithFormat:@"Bearer %@", appDelegate.CIRCLE_API_KEY] forHTTPHeaderField:@"Authorization"];
    
    // Create the NSURLSessionDataTask post task object
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // We need to dispatch this to the main/UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( error ) {
                NSLog( @"Failed to transfer funds to merchant, error = %@", error );

                // In any case, we need to pop back to the main View Controller
                [self performSegueWithIdentifier:@"unwindToMainVCSegue" sender:self];
            }
            else {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
                long httpStatus = httpResp.statusCode;
                
                if( httpStatus != 201) {
                    

                    NSLog( @"Failed to transfer funds to merchant, httpStatus = %ld", httpStatus );
                }
                else {
                    
                    // Deserialize the Http response into NSDictionary
                    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    // And dump the dictionary
                    NSLog(@"%@", dictResponse);
                    
                    NSString *transactionID = dictResponse[@"data"][@"id"];
                    NSString *lblMessage = [NSString stringWithFormat:@"Payment successful; transaction ID is %@", transactionID];
                    
                    self.lblComplete.text = lblMessage;
                    
                    [self.btnPay setHidden:YES];
                    [self.btnCancel setTitle:@"Done" forState:UIControlStateNormal];

                    
                        // We need to pop back to the main View Controller
//                        [self performSegueWithIdentifier:@"unwindToMainVCSegue" sender:self];


                 }
            }
            
        });


    }];
    
    // Execute the task
    [task resume];
}

- (NSDictionary *)getTransferDictForText:(NSString *)text {

    // Split the scanned text by the pipe delimiter
    NSArray *splits = [text componentsSeparatedByString:@"|"];
    NSString *chainAddress = splits[0];
    NSString *merchantName = splits[1];
    NSString *amount = splits[2];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Load up a Dictionary with the request body
    //{"idempotencyKey": "dbbc9d81-72f1-4bf8-97c8-99f1f28995f2",
    //  "source": {"type": "wallet", "id": "1000072203"},
    //  "destination": {"type": "blockchain", "address": "FUoAafzWRYp8dsshzKqadN7QXGZQAJ6M5dc95jN1d9GJ", "chain": "SOL"},
    //  "amount": {"amount": "0.20", "currency": "USD"}}    NSDictionary *sourceDict = @{ @"type" : @"wallet", @"id" : CONSUMER_WALLET_ID };
    NSDictionary *sourceDict = @{ @"type" : @"wallet", @"id" : appDelegate.CONSUMER_WALLET_ID };
    NSDictionary *destDict = @{ @"type" : @"blockchain", @"address" : chainAddress, @"chain" : @"SOL"};
    NSDictionary *amountDict = @{ @"amount": amount, @"currency": @"USD" };
    NSDictionary *reqDict = @{ @"idempotencyKey" :[[NSUUID UUID] UUIDString], @"source" : sourceDict, @"destination" : destDict, @"amount" : amountDict };
    
    return reqDict;
}

@end
