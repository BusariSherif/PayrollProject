/// <summary>
/// Page HLH Posting Setup (ID 50018).
/// </summary>
page 50018 "HLH Posting Setup"
{
    PageType = ListPart;
    Caption = 'Salary Posting Setup';
    SourceTable = "HLH Posting Setup Line";

    layout
    {
        area(Content)
        {
            repeater("Balancing Account Setup")
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
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
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
        }
    }
}