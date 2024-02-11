/// <summary>
/// PageExtension HLH Accountant Profile Ext (ID 50002) extends Record Accounting Manager Role Center.
/// </summary>
pageextension 50002 "HLH Accountant Profile Ext" extends "Accounting Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Journals)
        {
            group("MyPayCheq")
            {
                Caption = 'MyPayCheq Posting';
                action("Salary Posting Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salary Posting Setup';
                    Gesture = None;
                    RunObject = Page "HLH Posting Setup Header";
                    ToolTip = 'Executes the Salary Posting Setup action.';
                }
                action("Post Salary")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Salary';
                    Gesture = None;
                    RunObject = Page "HLH Post Salary";
                    ToolTip = 'Executes the Post Salary action.';
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
                action("Banks List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Banks List';
                    Gesture = None;
                    ToolTip = 'Banks List';
                    RunObject = Page "HLH Banks Setup List";
                }
            }
        }
    }
}