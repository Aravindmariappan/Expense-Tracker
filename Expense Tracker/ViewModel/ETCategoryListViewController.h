//
//  ETCategoryListViewController.h
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseCategory+CoreDataClass.h"

@protocol CategorySelectionDelegate <NSObject>

- (void)didSelectCategory:(ExpenseCategory *)category;

@end

@interface ETCategoryListViewController : UIViewController

@property id<CategorySelectionDelegate>delegate;

@end
