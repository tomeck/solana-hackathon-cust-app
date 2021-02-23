//
//  UIUtils.h
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/23/21.
//
#import <UIKit/UIKit.h>
#import "UIUtils.h"

@implementation UIUtils 

+ (void) displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message onView:(UIViewController *)view withCompletion:(void (^ __nullable)(void))completion {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [view presentViewController:alert animated:YES completion:completion];
}
@end
