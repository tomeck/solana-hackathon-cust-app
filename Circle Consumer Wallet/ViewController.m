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
}


// This is here so we can support an unwind segue
// landing here
-(IBAction)unwindToNewTransactionViewController:(UIStoryboardSegue *)segue {
    [self getBalance];
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

// JTE TESTING ONLY
/*
- (IBAction)testPayClicked:(id)sender {
    NSString *scannedText = @"FUoAafzWRYp8dsshzKqadN7QXGZQAJ6M5dc95jN1d9GJ|Sal's Pizza|23.45";
    
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
    [request setValue:[NSString stringWithFormat:@"Bearer %@", API_KEY] forHTTPHeaderField:@"Authorization"];
    
    // Create the NSURLSessionDataTask post task object
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // We need to dispatch this to the main/UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( error ) {
                NSLog( @"Failed to transfer funds to merchant, error = %@", error );
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
                    //self.lblBalance.text = dictResponse[@"data"][@"balances"][0][@"amount"];
                    //self.lblCurrency.text = dictResponse[@"data"][@"balances"][0][@"currency"];
                    
                    // Refresh screen to see updated balance
                    [self getBalance];
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

    // Load up a Dictionary with the request body
    //{"idempotencyKey": "dbbc9d81-72f1-4bf8-97c8-99f1f28995f2",
    //  "source": {"type": "wallet", "id": "1000072203"},
    //  "destination": {"type": "blockchain", "address": "FUoAafzWRYp8dsshzKqadN7QXGZQAJ6M5dc95jN1d9GJ", "chain": "SOL"},
    //  "amount": {"amount": "0.20", "currency": "USD"}}    NSDictionary *sourceDict = @{ @"type" : @"wallet", @"id" : CONSUMER_WALLET_ID };
    NSDictionary *sourceDict = @{ @"type" : @"wallet", @"id" : CONSUMER_WALLET_ID };
    NSDictionary *destDict = @{ @"type" : @"blockchain", @"address" : chainAddress, @"chain" : @"SOL"};
    NSDictionary *amountDict = @{ @"amount": amount, @"currency": @"USD" };
    NSDictionary *reqDict = @{ @"idempotencyKey" :[[NSUUID UUID] UUIDString], @"source" : sourceDict, @"destination" : destDict, @"amount" : amountDict };
    
    return reqDict;
}
*/

/*
- (IBAction)btnPayNow:(id)sender {
    

    // Load up a Dictionary with the request body
    //{"idempotencyKey": "dbbc9d81-72f1-4bf8-97c8-99f1f28995f2",
    //  "source": {"type": "wallet", "id": "1000072203"},
    //  "destination": {"type": "blockchain", "address": "FUoAafzWRYp8dsshzKqadN7QXGZQAJ6M5dc95jN1d9GJ", "chain": "SOL"},
    //  "amount": {"amount": "0.20", "currency": "USD"}}
    NSDictionary *sourceDict = @{ @"type" : @"wallet", @"id" : CONSUMER_WALLET_ID };
    NSDictionary *destDict = @{ @"type" : @"blockchain", @"address" : MERCHANT_SOLANA_ADDRESS, @"chain" : @"SOL"};
    NSDictionary *amountDict = @{ @"amount": @"0.10", @"currency": @"USD" };
    NSDictionary *reqDict = @{ @"idempotencyKey" :[[NSUUID UUID] UUIDString], @"source" : sourceDict, @"destination" : destDict, @"amount" : amountDict };
    
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
    [request setValue:[NSString stringWithFormat:@"Bearer %@", API_KEY] forHTTPHeaderField:@"Authorization"];
    
    // Create the NSURLSessionDataTask post task object
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // We need to dispatch this to the main/UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( error ) {
                NSLog( @"Failed to transfer funds to merchant, error = %@", error );
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
                    //self.lblBalance.text = dictResponse[@"data"][@"balances"][0][@"amount"];
                    //self.lblCurrency.text = dictResponse[@"data"][@"balances"][0][@"currency"];
                    
                    // Refresh screen to see updated balance
                    [self getBalance];
                }
            }
        });

       
    }];
    
    // Execute the task
    [task resume];
}
*/
@end
