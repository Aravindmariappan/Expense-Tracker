//
//  ExpenseTableViewCell.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ExpenseTableViewCell.h"

#define kCellIdentifier @"expenseTableViewCellIdentifier"
@interface ExpenseTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *expenseName;
@property (weak, nonatomic) IBOutlet UILabel *expenseCategory;
@property (weak, nonatomic) IBOutlet UILabel *expenseAmount;

@end

@implementation ExpenseTableViewCell

+ (NSString *)cellIdentifier {
    return kCellIdentifier;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureWithVM:(ETExpenseCellViewModel *)cellVM {
    [self.expenseName setText:cellVM.expenseName];
    [self.expenseCategory setText:cellVM.expenseCategory];
    [self.expenseAmount setText:cellVM.expenseAmount];
}

@end
