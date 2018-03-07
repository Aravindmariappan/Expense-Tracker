//
//  ETExpenseCellViewModel.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETExpenseCellViewModel.h"

@interface ETExpenseCellViewModel()

@property Expense *expense;
@property (readwrite) NSString *expenseName;
@property (readwrite) NSString *expenseCategory;
@property (readwrite) NSString *expenseAmount;

@end

@implementation ETExpenseCellViewModel

#pragma mark - Initialization

- (instancetype)initWithExpense:(Expense *)expense {
    self = [super init];
    if (self) {
        self.expense = expense;
        self.expenseName = self.expense.expenseName;
        self.expenseCategory = expense.expenseCategory.expenseCategoryName;
        self.expenseAmount = [self expenseAmountStringFromAmount:self.expense.amount];
    }
    
    return self;
}

- (NSString *)expenseAmountStringFromAmount:(float)amount {
    NSString *amountString = @"₹.0.0";
    if (amount > 0) {
        amountString = [NSString stringWithFormat:@"₹ %.2f", amount];
    }
    
    return amountString;
}

@end
