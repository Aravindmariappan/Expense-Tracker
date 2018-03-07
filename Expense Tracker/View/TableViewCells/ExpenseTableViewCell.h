//
//  ExpenseTableViewCell.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETExpenseCellViewModel.h"

@interface ExpenseTableViewCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)configureWithVM:(ETExpenseCellViewModel *)cellVM;

@end
