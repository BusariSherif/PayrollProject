/// <summary>
/// Page HLH Salary Journals (ID 50021).
/// </summary>
page 50021 "HLH Salary Journals"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Salary Journals';
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Period Code"; "Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    TableRelation = "HLH Payroll Periods";
                    ToolTip = 'Specifies the value of the Period Code field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Payroll.Page.loadMonthlySalaryProration("Period Code", Employee);
                    end;
                }
                field(Employee; Employee)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    TableRelation = Employee;
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
            }
            part("Payroll"; "HLH Monthly Payroll Header")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Monthly Salary Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reset)
            {
                ApplicationArea = All;
                Caption = 'Reset';
                Image = ResetStatus;
                ToolTip = 'Executes the Reset action.';
                trigger OnAction()
                begin
                    CurrPage.Payroll.Page.loadMonthlySalaryProration('NOTHING', 'NOTHING');
                    ClearAll();
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
        accessControl.SetFilter("Role ID", '%1|%2|%3', 'HLH Approval Perm.', 'HLH Permissions', 'HLH Accounts Perm.');
        if (accessControl.IsEmpty) then
            Error(errLbl)
        else
            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod('NOTHING');
    end;

    var
        "Period Code": Code[20];
        Employee: Text[200];
}