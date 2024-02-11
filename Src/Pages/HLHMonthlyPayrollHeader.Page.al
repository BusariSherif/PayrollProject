/// <summary>
/// Page HLH Monthly Payroll Header (ID 50008).
/// </summary>
page 50008 "HLH Monthly Payroll Header"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "HLH Monthly Payroll Header";
    Caption = 'Monthly Payroll Header';
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Monthly Payroll Header")
            {
                field("Period Code"; Rec."Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Code field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Employee Type"; Rec."Emp. Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emp. Type field.';
                }
                field(Gross; Rec.Gross)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gross field.';
                }
                field("Present Days"; Rec."Days Present")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Days Present field.';
                }
                field(Basic; Rec.Basic)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Basic field.';
                }
                field(Housing; Rec.Housing)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Housing field.';
                }
                field(Transport; Rec.Transport)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport field.';
                }
                field("Other Allowances"; Rec."Other Allowances")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Allowances field.';
                }
                field("Total Allowances"; Rec."Total Allowances")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Total Allowances field.';
                }
                field("Total Deductions"; Rec."Total Deductions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Deductions field.';
                }
                field(Netpay; Rec.Netpay)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Netpay field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                    Editable = false;
                    Visible = false;
                }
                field("Account Number"; Rec."Account Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Number field.';
                    Editable = false;
                    Visible = false;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    Editable = false;
                    Visible = false;
                }
                field("Bank Sort Code"; Rec."Bank Sort Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Sort Code field.';
                    Editable = false;
                    Visible = false;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                    Editable = false;
                    Visible = false;
                }
                //BEGIN >> Add New fields - - November 2023
                field("Tax ID No"; Rec."Payer ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Identification No. field.';
                    Editable = false;
                    Visible = false;
                }
                field("PAYE"; Rec.Payee)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PAYE Amount field.';
                    Editable = false;
                    Visible = false;
                }
                field("Pension"; Rec.Pension)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PAYE Amount field.';
                    Editable = false;
                    Visible = false;
                }
                field("Job Title"; Rec.Designation)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Title field.';
                    Editable = false;
                    Visible = false;
                }
                field("Department"; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department field.';
                    Editable = false;
                    Visible = false;
                }
                field("Pension Fund Admin."; Rec."Pension Fund Admin.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pension Fund Administrator field.';
                    Editable = false;
                    Visible = false;
                }
                field("RSA Pin"; Rec."RSA Pin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RSA Pin field.';
                    Editable = false;
                    Visible = false;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the First Name field.';
                    Editable = false;
                    Visible = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                    Editable = false;
                    Visible = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Name field.';
                    Editable = false;
                    Visible = false;
                }
                field("Private Phone No."; Rec."Private Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Private Phone Number field.';
                    Editable = false;
                    Visible = false;
                }
                field("Private Email"; Rec."Private Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Private Email field.';
                    Editable = false;
                    Visible = false;
                }
                field("Loan Repayment"; Rec."Loan Repayment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Repayment field.';
                    Editable = false;
                    Visible = false;
                }
                field(Adjustment; Rec.Adjustment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Adjustment field.';
                    Editable = false;
                    Visible = false;
                }
                field("Other Deductions"; Rec."Other Deductions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Deductions field.';
                    Editable = false;
                    Visible = false;
                }
                //END >> Add New fields - November 2023
            }
        }
    }

    /// <summary>
    /// myMethod.
    /// </summary>
    /// <param name="Pay Period">code[50].</param>
    procedure loadMonthlySalaryByPeriod("Pay Period": Text)
    begin
        Rec.SetRange("Period Code", "Pay Period");
        Rec.SetFilter("Period Code", "Pay Period");
        CurrPage.Update();
    end;

    /// <summary>
    /// loadMonthlySalaryByPeriodFullStaff.
    /// </summary>
    /// <param name="Pay Period">Text.</param>
    procedure loadMonthlySalaryByPeriodFullStaff("Pay Period": Text)
    begin
        Rec.SetRange("Period Code", "Pay Period");
        Rec.SetFilter("Period Code", "Pay Period");
        Rec.SetFilter("Emp. Type", 'Full Time');
        CurrPage.Update();
    end;

    /// <summary>
    /// loadMonthlySalaryHeader.
    /// </summary>
    /// <param name="Pay Period">code[50].</param>
    /// <param name="empType">Text.</param>
    procedure loadMonthlySalaryHeader("Pay Period": code[50]; empType: Text)
    begin
        Rec.SetRange("Period Code", "Pay Period");
        Rec.SetRange("Emp. Type", empType);
        Rec.SetFilter(Rec."Period Code", "Pay Period");
        Rec.SetFilter("Emp. Type", empType);
        CurrPage.Update();
    end;

    /// <summary>
    /// loadMonthlySalaryProration.
    /// </summary>
    /// <param name="Pay Period">code[100],"Emp No.".</param>
    /// <param name="Emp No.">Text[200].</param>
    procedure loadMonthlySalaryProration("Pay Period": code[100]; "Emp No.": Text[200])
    begin
        Rec.SetRange("Period Code", "Pay Period");
        Rec.SetRange("Employee No.", "Emp No.");
        Rec.SetFilter(Rec."Period Code", "Pay Period");
        Rec.SetFilter("Employee No.", "Emp No.");
        CurrPage.Update();
    end;

    /// <summary>
    /// loadMonthlyFullTimeSalary.
    /// </summary>
    /// <param name="Pay Period">code[100].</param>
    /// <param name="Emp No.">Text[200].</param>
    procedure loadMonthlyFullTimeSalary("Pay Period": code[100]; "Emp No.": Text[200])
    begin
        Rec.SetRange("Period Code", "Pay Period");
        Rec.SetRange("Employee No.", "Emp No.");
        Rec.SetFilter(Rec."Period Code", "Pay Period");
        Rec.SetFilter("Employee No.", "Emp No.");
        CurrPage.Update();
    end;
}