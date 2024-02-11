/// <summary>
/// Page HLH Posting Setup Header (ID 50020).
/// </summary>
page 50020 "HLH Posting Setup Header"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "HLH Salary Posting Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'Salary Posting Setup';

    layout
    {
        area(Content)
        {
            group("Debit Account")
            {

                field("Salary Type"; Rec."Salary Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Type field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Type field.';
                }
            }
            part("Balancing Accounts"; "HLH Posting Setup")
            {
                ApplicationArea = All;
                Caption = 'Balancing Accounts Setup';
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
        accessControl.SetFilter("Role ID", 'HLH Accounts Perm.');
        if (accessControl.IsEmpty) then
            Error(errLbl);
    end;
}