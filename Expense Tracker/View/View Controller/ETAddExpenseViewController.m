//
//  ETAddExpenseViewController.m
//  Expense Tracker
//
//  Created by Aravind on 01/12/17.
//  Copyright © 2017 Aravind. All rights reserved.
//

#import "ETAddExpenseViewController.h"
#import "ETCategoryListViewController.h"

@interface ETAddExpenseViewController () <CategorySelectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *expenseNameField;
@property (weak, nonatomic) IBOutlet UITextField *amountSpentField;
@property (weak, nonatomic) IBOutlet UILabel *selectedCategory;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *taggedFields;

@property ETAddExpenseViewModel *addExpenseVM;

@end

@implementation ETAddExpenseViewController

#pragma mark - ViewController Life-cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureFields];
    [self configureData];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.addExpenseVM discardDetails];
    }
    [super viewWillDisappear:animated];
}

#pragma mark -

- (void)configureWithViewModel:(ETAddExpenseViewModel *)viewModel {
    self.addExpenseVM = viewModel;
}

#pragma mark - View Config

- (void)configureFields {
    [self.expenseNameField setTag:ExpenseFieldTypeName];
    [self.amountSpentField setTag:ExpenseFieldTypeAmount];
    [self.dateTextField setTag:ExpenseFieldTypeDate];
    [self.dateTextField setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeWithNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Data Population

- (void)configureData {
    for (UITextField *textField in self.taggedFields) {
        textField.text = [self.addExpenseVM populateFieldsBasedOnType:textField.tag];
    }
}

#pragma mark - Field

- (void)textFieldDidChangeWithNotification:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    [self.addExpenseVM updatedElement:textField.tag withValue:textField.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == ExpenseFieldTypeDate) {
        [self presentDatePickerOverField:textField];
    }
    
    return YES;
}

#pragma mark - Present DatePicker

- (void)presentDatePickerOverField:(UITextField *)textField {
    UIDatePicker *dpDatePicker = [[UIDatePicker alloc] init];
    dpDatePicker.datePickerMode = UIDatePickerModeDate;
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePicker.timeZone = [NSTimeZone defaultTimeZone];
    
    [textField setInputView:dpDatePicker];
}

- (void)datePickerValueChanged:(id)sender {
    UIDatePicker *dpDatePicker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.dateTextField.text = [dateFormatter stringFromDate:dpDatePicker.date];
    [self.addExpenseVM updatedElement:self.dateTextField.tag withValue:self.dateTextField.text];
}

#pragma mark -

- (IBAction)saveButtonTapped:(id)sender {
    [self.addExpenseVM saveDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[ETCategoryListViewController class]]) {
        ETCategoryListViewController *categoryListVC = (ETCategoryListViewController *)destinationViewController;
        [categoryListVC setDelegate:self];
    }
}

- (void)didSelectCategory:(ExpenseCategory *)category {
    [self.addExpenseVM updateCategory:category];
    [self.selectedCategory setText:category.expenseCategoryName];
}

@end
