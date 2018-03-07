//
//  ETAllExpensesViewController.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETAllExpensesViewController.h"
#import "ETAddExpenseViewController.h"
#import "ETAddExpenseViewModel.h"
#import "ETTodayExpenseViewModel.h"
#import "ExpenseTableViewCell.h"

@interface ETAllExpensesViewController()<UITableViewDelegate, UITableViewDataSource>

@property ETTodayExpenseViewModel *todayExpenseViewModel;
@property (weak, nonatomic) IBOutlet UITableView *expensesTableView;

@end

@implementation ETAllExpensesViewController

#pragma mark - View-controller Life-cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewModel];
    [self configureTableView:self.expensesTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.todayExpenseViewModel refresh];
    [self.expensesTableView reloadData];
}

#pragma mark -

- (void)configureTableView:(UITableView *)tableView {
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerNib:[UINib nibWithNibName:@"ExpenseTableViewCell" bundle:nil] forCellReuseIdentifier:[ExpenseTableViewCell cellIdentifier]];
}

- (void)configureViewModel {
    self.todayExpenseViewModel = [[ETTodayExpenseViewModel alloc] initWithAllExpenses];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[ETAddExpenseViewController class]]) {
        ETAddExpenseViewController *addExpenseVC = (ETAddExpenseViewController *)destinationViewController;
        [addExpenseVC configureWithViewModel:[self addExpenseViewModel]];
    }
}

- (ETAddExpenseViewModel *)addExpenseViewModel {
    ETAddExpenseViewModel *newVM = [[ETAddExpenseViewModel alloc] initWithNewExpense];
    
    return newVM;
}

#pragma mark - Tableview

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todayExpenseViewModel getDisplayedItemsCount];
}

#pragma mark - Tableview Datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ETExpenseCellViewModel *cellVM = [self.todayExpenseViewModel viewModelForCellATIndex:indexPath.row];
    ExpenseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExpenseTableViewCell cellIdentifier]];
    [cell configureWithVM:cellVM];
    
    return cell;
}

@end

