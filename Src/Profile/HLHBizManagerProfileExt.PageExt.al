/// <summary>
/// PageExtension HLH Accountant Profile Ext (ID 50002) extends Record Accounting Manager Role Center.
/// </summary>
pageextension 50003 "HLH Biz Manager Profile Ext" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Chart of Accounts")
        {
#pragma warning disable AL0551
            group("MyPayCheq")
#pragma warning restore AL0551
            {
                Caption = 'MyPayCheq Approver';
                action("Salary Approval")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Approval';
                    Gesture = None;
                    RunObject = Page "HLH Salary Approval";
                    ToolTip = 'Executes the Salary Approval.';
                }
                action("MyPayCheq Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'MyPayCheq Setup';
                    Gesture = None;
                    RunObject = Page "HLH MyPayCheq Setup";
                    ToolTip = 'Executes the MyPayCheq Setup action.';
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
    }
}