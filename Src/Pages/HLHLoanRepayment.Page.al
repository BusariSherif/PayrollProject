/// <summary>
/// Page HLH Loan Repayment (ID 50017).
/// </summary>
page 50017 "HLH Loan Repayment"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Loan Repayment Page';
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ShowMandatory = true;
                }
                field("Period Code"; "Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    ShowMandatory = true;
                    TableRelation = "HLH Payroll Periods" where(Closed = const(false), "Approval Status" = const(Open));
                    ToolTip = 'Specifies the value of the Period Code field.';
                    trigger OnValidate()
                    var
                        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        CurrPage.Payroll.Page.loadMonthlySalaryProration("Period Code", Employee);
                        if ("Document No" = '') then begin
                            hlhMyPayCheqSetup.Get();
                            "Document No" := NoSeriesMgt.GetNextNo(hlhMyPayCheqSetup."Loan Repayment Nos.", WorkDate(), true);
                        end;
                    end;
                }
                field(Employee; Employee)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    TableRelation = Employee;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Employee field.';
                    trigger OnValidate()
                    var
                        Err: Label 'Payroll Period field must not be empty!';
                    begin
                        if (("Period Code" <> '')) then
                            CurrPage.Payroll.Page.loadMonthlySalaryProration("Period Code", Employee)
                        else
                            Error(Err);
                    end;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
            part("Payroll"; "HLH Monthly Payroll Header")
            {
                Editable = false;
                Caption = 'Monthly Salary Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Deduct Loan")
            {
                ApplicationArea = All;
                Image = Post;
                Caption = 'Deduct Loan';
                ToolTip = 'Loan Deduction Action';

                trigger OnAction()
                var
                    emp: Record Employee;
                    hlhSalaryPosting: Codeunit "HLH Salary Posting";
                    hlhPayroll: Codeunit "HLH Payroll";
                    emptyFieldsLbl: Label 'You must fill all required fields before you proceed!';
                    invalidAmtLbl: Label 'Amount can not be zero or negative!';
                    errRepaymntLbl: Label 'Error while trying to deduct loan, please try again or contact the Developer.';
                    successRepaymntLbl: Label 'Successfully Deducted Loan Repayment.';
                    unableToLogLbl: Label 'Something went wrong! \Unable to log Loan Entry at this time.';
                    noEmpSalaryLbl: Label 'There is no Salary Detail for the selected Employee!';
                    empName: Text;
                begin
                    if (("Period Code" = '') or (Employee = '') or ("Document No" = '')) then // or ("Account No" = '') or ("Bal. Account No" = '')) then
                        Error(emptyFieldsLbl)
                    else
                        if (Amount <= 0) then
                            Error(invalidAmtLbl)
                        else
                            if (hlhPayroll.isEmployeeSalaryGenerated("Period Code", Employee) = true) then begin
                                if (emp.Get(Employee)) then
                                    empName := emp.FullName();
                                if (hlhSalaryPosting.deductLoan("Period Code", Employee, Amount)) then begin
                                    if (hlhSalaryPosting.logLoanEntry("Period Code", empName, "Document No", Amount, Description)) then
                                        Message(successRepaymntLbl)
                                    else
                                        Message(unableToLogLbl);
                                    Employee := '';
                                    Description := '';
                                    Amount := 0;
                                end
                                else
                                    Error(errRepaymntLbl);
                            end
                            else
                                Error(noEmpSalaryLbl);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        accessControl: Record "Access Control";
        errLbl: Label 'You do not have the right permission to open this page';
    begin
        accessControl.SetRange("User Security ID", UserSecurityId());
        accessControl.SetFilter("Role ID", 'HLH Permissions');
        if (accessControl.IsEmpty) then
            Error(errLbl)
        else
            CurrPage.Payroll.Page.loadMonthlySalaryProration('NOTHING', 'NOTHING');
    end;

    var
        "Period Code": Code[50];
        "Document No": Code[20];
        Employee: Text[150];
        Description: Text[350];
        Amount: Decimal;
}