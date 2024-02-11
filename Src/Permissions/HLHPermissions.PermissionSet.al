/// <summary>
/// HLH Permissions (ID 50000).
/// </summary>
permissionset 50000 "HLH Permissions"
{
    Assignable = true;
    Caption = 'MyPayCheq HR Permission', MaxLength = 30;
    Access = Public;
    Permissions = table "HLH Departments" = X,
        tabledata "HLH Departments" = RMID,
        table "HLH Emp. Salary Breakdown" = X,
        tabledata "HLH Emp. Salary Breakdown" = RMID,
        table "HLH Pension Administrators" = X,
        tabledata "HLH Pension Administrators" = RMID,
        table "HLH Salary Structure" = X,
        tabledata "HLH Salary Structure" = RMID,
        table "HLH Payroll Periods" = X,
        tabledata "HLH Payroll Periods" = RMID,
        table "HLH Monthly Payroll Header" = X,
        tabledata "HLH Monthly Payroll Header" = RMID,
        table "HLH Monthly Payroll Line" = X,
        tabledata "HLH Monthly Payroll Line" = RMID,
        table "HLH Banks Setup" = X,
        tabledata "HLH Banks Setup" = RIMD,
        tabledata "HLH MyPayCheq Setup" = R,
        table "HLH Department Units" = X,
        tabledata "HLH Department Units" = RIMD,
        table "HLH Loan Repayment Entries" = X,
        tabledata "HLH Loan Repayment Entries" = RIMD,
        table "HLH Salary Adjustments Entries" = X,
        tabledata "HLH Salary Adjustments Entries" = RIMD,
        codeunit "HLH Calc. Days In a Month" = X,
        codeunit "HLH Payroll" = X,
        page "HLH Department Card" = X,
        page "HLH Departments List" = X,
        page "HLH Emp. Salary Breakdown" = X,
        page "HLH HR Headline Part" = X,
        page "HLH Pension Admins. List" = X,
        page "HLH Salary Structure List" = X,
        page "HLH HR Role Center" = X,
        page "HLH Payroll Periods List" = X,
        page "HLH Generate Salary" = X,
        page "HLH Monthly Payroll Header" = X,
        page "HLH Salary Approval" = X,
        page "HLH Monthly Payroll Part" = X,
        page "HLH Salary Journals" = X,
        page "HLH Prorate Salary" = X,
        page "HLH Generate Payslip" = X,
        page "HLH Salary Adjustment Entries" = X,
        page "HLH Loan Repayment Entries" = X,
        // page "HLH Monthly Payroll Hdr API" = X,
        // page "HLH Monthly Payroll Line API" = X,
        page "HLH Payroll Period API" = X,
        page HLHHRRoleCenterCues = X,
        page "HLH Department Units List" = X,
        page "HLH Banks Setup List" = X,
        report "HLH Payslip" = X;
}

#pragma warning disable AA0215
permissionset 50001 "HLH Accounts Perm."
#pragma warning restore AA0215
{
    Assignable = true;
    Caption = 'MyPayCheq Accounts Permission', MaxLength = 30;
    Access = Public;
    Permissions = table "HLH Salary Posting Setup" = X,
        tabledata "HLH Salary Posting Setup" = RMID,
        table "HLH Posting Setup Line" = X,
        tabledata "HLH Posting Setup Line" = RMID,
        table "HLH MyPayCheq Setup" = X,
        tabledata "HLH MyPayCheq Setup" = RIMD,
        table "HLH Monthly Payroll Header" = X,
        tabledata "HLH Monthly Payroll Header" = R,
        table "HLH Payroll Periods" = x,
        tabledata "HLH Payroll Periods" = RIMD,
        table "HLH Monthly Payroll Line" = X,
        tabledata "HLH Monthly Payroll Line" = R,
        table "HLH Banks Setup" = X,
        tabledata "HLH Banks Setup" = RIMD,
        tabledata "HLH Emp. Salary Breakdown" = R,
        table "HLH Department Units" = X,
        tabledata "HLH Department Units" = RIMD,
        codeunit "HLH Payroll" = X,
        codeunit "HLH Salary Posting" = X,
        codeunit "HLH MyPayCheq Mgt." = X,
        codeunit "HLH Calc. Days In a Month" = x,
        page "HLH Monthly Payroll Header" = X,
        page "HLH Monthly Payroll Part" = X,
        page "HLH MyPayCheq Setup" = X,
        page "HLH Emp. Salary Breakdown" = X,
        page "HLH Salary Journals" = X,
        page "HLH Post Salary" = X,
        page "HLH Posting Setup" = X,
        page "HLH Posting Setup Header" = X,
        page "HLH Banks Setup List" = X,
        page "HLH Department Units List" = X;
    // page "HLH Monthly Payroll Hdr API" = X;
}

#pragma warning disable AA0215
permissionset 50002 "HLH Approval Perm."
#pragma warning restore AA0215
{
    Assignable = true;
    Caption = 'MyPayCheq Approval Permission', MaxLength = 30;
    Access = Public;
    Permissions = table "HLH Salary Structure" = X,
        tabledata "HLH Salary Structure" = RMID,
        table "HLH Monthly Payroll Header" = X,
        tabledata "HLH Monthly Payroll Header" = RMID,
        table "HLH MyPayCheq Setup" = X,
        tabledata "HLH MyPayCheq Setup" = RIMD,
        table "HLH Payroll Periods" = X,
        tabledata "HLH Payroll Periods" = RIMD,
        tabledata "HLH Emp. Salary Breakdown" = R,
        codeunit "HLH Payroll" = X,
        codeunit "HLH MyPayCheq Mgt." = x,
        codeunit "HLH Calc. Days In a Month" = x,
        page "HLH Salary Approval" = X,
        page "HLH Monthly Payroll Header" = x,
        page "HLH Monthly Payroll Part" = x,
        page "HLH Payroll Periods List" = x,
        page "HLH MyPayCheq Setup" = x,
        page "HLH Salary Journals" = X,
        // page "HLH Monthly Payroll Line API" = X,
        page "HLH Payroll Period API" = X;
    // page "HLH Monthly Payroll Hdr API" = X;
}