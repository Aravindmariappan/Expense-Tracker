//
//  ETExpenseCellViewModel.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETExpenseCellViewModel : NSObject

@property (readonly) NSString *expenseName;
@property (readonly) NSString *expenseCategory;
@property (readonly) NSString *expenseAmount;

- (instancetype)initWithExpense:(Expense *)expense;

@end
