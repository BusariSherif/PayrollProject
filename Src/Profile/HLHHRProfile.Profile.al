/// <summary>
/// Unknown HR Profile.
/// </summary>
profile "HLH HR Profile"
{
    Description = 'Human Resource Manager';
    RoleCenter = "HLH HR Role Center";
    Caption = 'Human Resource Manager';
    ProfileDescription = 'Human Resource Role Center';
    Enabled = true;
    Promoted = true;
}

#pragma warning disable AA0215
page 50002 "HLH HR Role Center"
#pragma warning restore AA0215
{
    PageType = RoleCenter;
    Caption = 'HR Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headlines; "HLH HR Headline Part")
            {
                ApplicationArea = All;
            }
            part(HRCues; HLHHRRoleCenterCues)
            {
                ApplicationArea = All;
                Editable = false;

            }
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                AccessByPermission = TableData "Power BI User Configuration" = I;
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Create Payroll Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Payroll Period';
                Gesture = None;
                ToolTip = 'Create new payroll period for salary';
                RunObject = Page "HLH Payroll Periods List";
            }
        }
        area(Sections)
        {
            group("Employee Management")
            {
                action("Employees")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employees';
                    Gesture = None;
                    RunObject = Page "Employee List";
                    ToolTip = 'List of all employees';
                }
                action("Departments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Departments List';
                    Gesture = None;
                    RunObject = Page "HLH Departments List";
                    ToolTip = 'Departments List';
                }
                action("PFA Admin")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pension Fund Administrator';
                    Gesture = None;
                    RunObject = Page "HLH Pension Admins. List";
                    ToolTip = 'Pension Fund Administrator';
                }
                action("Banks List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Banks List';
                    Gesture = None;
                    ToolTip = 'Banks List';
                    RunObject = Page "HLH Banks Setup List";
                }
            }
            group("Payroll Management")
            {
                action("SalaryStructure")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Structure';
                    Gesture = None;
                    RunObject = Page "HLH Salary Structure List";
                    ToolTip = 'Shows the Salary structure of how the salary is broken down.';
                }
                action("Payroll Periods")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payroll Periods';
                    Gesture = None;
                    RunObject = Page "hLH Payroll Periods List";
                    ToolTip = 'Shows the list of all payroll periods.';
                }
                action("Generate Salary")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Generate Salary';
                    Gesture = None;
                    RunObject = Page "HLH Generate Salary";
                    ToolTip = 'Generate Salary Page.';
                }
                action("Prorate Salary")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prorate Salary';
                    Gesture = None;
                    ToolTip = 'Prorate salary for affected members of staff.';
                    RunObject = Page "HLH Prorate Salary";
                }
                action("Salary Adjustment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Adjustment';
                    Gesture = None;
                    ToolTip = 'Adjust salary for affected members of staff.';
                    RunObject = Page "HLH Salary Adjustment";
                }
                action("Loan Repayment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Loan Repayment';
                    Gesture = None;
                    ToolTip = 'Loan Repayment for affected members of staff.';
                    RunObject = Page "HLH Loan Repayment";
                }
                action("Salary Approval")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Approval';
                    Gesture = None;
                    ToolTip = 'Salary Approval.';
                    RunObject = Page "HLH Salary Approval";
                }
                action("Payslip")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Generate Payslip';
                    Gesture = None;
                    ToolTip = 'Generate payslip for each staff for a particular payroll period.';
                    RunObject = Page "HLH Generate Payslip";
                }
                action("Loan Repayment Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Loan Repayment Entries';
                    Gesture = None;
                    ToolTip = 'Loan Repayment Entries';
                    RunObject = Page "HLH Loan Repayment Entries";
                }
                action("Salary Adjustment Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Adjustment Entries';
                    Gesture = None;
                    ToolTip = 'Salary Adjustment Entries';
                    RunObject = Page "HLH Salary Adjustment Entries";
                }
                action("Salary Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Journals';
                    Gesture = None;
                    ToolTip = 'Salary Journals';
                    RunObject = Page "HLH Salary Journals";
                }
            }
        }
        area(Embedding)
        {
            action("Salary_Structure")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Salary Structure';
                Gesture = None;
                RunObject = Page "HLH Salary Structure List";
                ToolTip = 'Shows the Salary structure of how the salary is broken down and their percentage';
            }
            action("All Employees")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employees';
                Gesture = None;
                RunObject = Page "Employee List";
                ToolTip = 'List of all employees';
            }
        }
    }
}