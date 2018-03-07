//
//  ETAddExpenseViewController.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETAddExpenseViewModel.h"

@interface ETAddExpenseViewController : UIViewController

- (void)configureWithViewModel:(ETAddExpenseViewModel *)viewModel;

@end
