//
//  TransactionCollectionViewController.m
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/26/21.
//

#import "TransactionCollectionViewController.h"
#import "TransactionCollectionViewCell.h"
#import "AppDelegate.h"

@interface TransactionCollectionViewController ()

@end

@implementation TransactionCollectionViewController

static NSString * const reuseIdentifier = @"TransactionCell";
bool isRefreshing = NO;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup a UI Refresh Control (pull down to refresh)
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(getRecentTransactions) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[TransactionCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    [self getRecentTransactions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRecentTransactions]; // to reload selected cell
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSDictionary *data = self.fetchedTransactions[@"data"];
    return data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    long index = indexPath.item;
    cell.lblAmount.text = [NSString stringWithFormat:@"%@  %@", self.fetchedTransactions[@"data"][index][@"amount"][@"amount"], self.fetchedTransactions[@"data"][index][@"amount"][@"currency"]];
    cell.lblStatus.text = self.fetchedTransactions[@"data"][index][@"status"];
    cell.lblDate.text = self.fetchedTransactions[@"data"][index][@"createDate"];
    cell.lblTxnID.text = self.fetchedTransactions[@"data"][index][@"id"];
    cell.lblSignature.text = self.fetchedTransactions[@"data"][index][@"transactionHash"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)getRecentTransactions {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if( isRefreshing ) {
        return;
    }
    isRefreshing = YES;
    
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
                    self.fetchedTransactions = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    // And dump the dictionary
                    NSLog(@"%@", self.fetchedTransactions);
                    
                    [self.collectionView reloadData];
               }
            }
            
            isRefreshing = NO;
            [self.refreshControl endRefreshing];
        });
    }];
    
    // Execute the task
    [task resume];
}

@end
