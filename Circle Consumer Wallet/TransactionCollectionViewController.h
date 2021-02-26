//
//  TransactionCollectionViewController.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionCollectionViewController : UICollectionViewController
@property (strong, nonatomic) NSDictionary *fetchedTransactions;

@end

NS_ASSUME_NONNULL_END
