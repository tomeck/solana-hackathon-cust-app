//
//  UIUtils.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIUtils : NSObject

+ (void) displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message onView:(UIViewController *)view withCompletion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
