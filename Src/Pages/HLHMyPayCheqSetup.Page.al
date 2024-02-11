/// <summary>
/// Page HLH MyPayCheq Setup (ID 50015).
/// </summary>
page 50015 "HLH MyPayCheq Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "HLH MyPayCheq Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'MyPayCheq Setup';

    layout
    {
        area(Content)
        {
            group("MyPayCheq Setup")
            {

                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver ID field.';
                }
                field("Approver Email"; Rec."Approver Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver Email field.';
                }
                field("Approver 2 ID"; Rec."Approver 2 ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver 2 ID field.';
                }
                field("Approver 2 Email"; Rec."Approver 2 Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver 2 Email field.';
                }
                field("Payroll Account Admin."; Rec."Payroll Account Admin.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Account Admininistrator field.';
                }
                field("Accounts Email"; Rec."Accounts Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accounts Administrator Email field.';
                }
                field("Show Annual Allowances"; Rec."Show Annual Allowances")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show Annual Allowances field.';
                }
                field("Salary Adj. Nos."; Rec."Salary Adj. Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Adj. Nos. field.';
                }
                field("Loan Repayment Nos."; Rec."Loan Repayment Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Repayment Nos. field.';
                }
                field("PayStack API Key"; Rec."PayStack API Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PayStack API Key field.';
                }
                field("13th Month Posted"; Rec."13th Month Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the 13th Month Posted field.';
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Leave Allowance Posted"; Rec."Leave Allowance Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the 13th Month Posted field.';
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
            }
        }
    }

    trigger OnInit()
    begin
        if Rec.IsEmpty() then
            Rec.Insert();
    end;

    trigger OnOpenPage()
    var
        accessControl: Record "Access Control";
        errLbl: Label 'You do not have the right permission to open this page';
    begin
        accessControl.SetRange("User Security ID", UserSecurityId());
        accessControl.SetFilter("Role ID", '%1|%2', 'HLH Accounts Perm.', 'HLH Approval Perm.');
        if (accessControl.IsEmpty) then
            Error(errLbl);
    end;

}