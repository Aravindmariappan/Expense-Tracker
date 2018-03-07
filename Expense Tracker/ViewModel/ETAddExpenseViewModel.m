//
//  ETAddExpenseViewModel.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETAddExpenseViewModel.h"

@interface ETAddExpenseViewModel()

@property Expense *expense;
@property BOOL saveTapped;
@end

@implementation ETAddExpenseViewModel

#pragma mark - Initialization

- (instancetype)initWithNewExpense {
    self = [super init];
    if (self) {
        self.expense = [[ETDatabaseHandler sharedInstance] insertNewExpense];
        self.saveTapped = NO;
    }
    
    return self;
}

- (instancetype)initWithExpense:(Expense *)expense {
    self = [super init];
    if (self) {
        self.expense = expense;
    }
    
    return self;
}

#pragma mark -

- (NSString *)populateFieldsBasedOnType:(ExpenseFieldType)fieldType {
    switch (fieldType) {
        case ExpenseFieldTypeName:
            return self.expense.expenseName;
        case ExpenseFieldTypeAmount: {
            NSString *amountString = [NSString stringWithFormat:@"%.2f", self.expense.amount];
            return amountString;
        }
        case ExpenseFieldTypeDate:
            return [self stringFromDate:self.expense.date];
        default:
            return @"";
    }
}

#pragma mark - Update Fields

- (void)updatedElement:(ExpenseFieldType)expenseType withValue:(id)updatedValue {
    switch (expenseType) {
        case ExpenseFieldTypeName:
            [self.expense setExpenseName:updatedValue];
            break;
        case ExpenseFieldTypeAmount:
            [self updateAmount:updatedValue];
            break;
        case ExpenseFieldTypeDate:
            [self updateDate:updatedValue];
        default:
            break;
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (void)updateAmount:(NSString *)amount {
    if  ([self validateAmount:amount]){
        self.expense.amount = amount.integerValue;
    }
}

- (BOOL)validateAmount:(NSString *)amount {
    NSInteger amountInt = amount.integerValue;
    if (amountInt > 0) {
        return YES;
    }
    
    return NO;
}

- (void)updateDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [self.expense setDate:date];
}

#pragma mark - Save

- (void)saveDetails {
    self.saveTapped = YES;
    [[ETDatabaseHandler sharedInstance] saveContext];
}

- (void)discardDetails {
    if (self.saveTapped == NO) {
        [[ETDatabaseHandler sharedInstance] deleteExpense:self.expense];
    }
}

- (void)updateCategory:(ExpenseCategory *)category {
    [self.expense setExpenseCategory:category];
}

@end
