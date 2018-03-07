//
//  ETAddExpenseViewModel.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense+CoreDataClass.h"

typedef enum : NSUInteger {
    ExpenseFieldTypeName,
    ExpenseFieldTypeAmount,
    ExpenseFieldTypeDate,
} ExpenseFieldType;

@interface ETAddExpenseViewModel : NSObject

- (instancetype)initWithNewExpense;
- (instancetype)initWithExpense:(Expense *)expense;

- (NSString *)populateFieldsBasedOnType:(ExpenseFieldType)fieldType;
- (void)updatedElement:(ExpenseFieldType)expenseType withValue:(id)updatedValue;
- (void)saveDetails;
- (void)discardDetails;
- (void)updateCategory:(ExpenseCategory *)category;

@end
