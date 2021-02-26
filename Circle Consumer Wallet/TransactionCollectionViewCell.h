//
//  TransactionCollectionViewCell.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTxnID;
@property (weak, nonatomic) IBOutlet UILabel *lblSignature;

@end

NS_ASSUME_NONNULL_END
