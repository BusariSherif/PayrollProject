/// <summary>
/// Page HLH Department Units List (ID 50025).
/// </summary>
page 50025 "HLH Department Units List"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HLH Department Units";
    Caption = 'Department Units List';
    DelayedInsert = true;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater("Units List")
            {
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Department Unit Name';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Department Code';
                    Caption = 'Department Code';
                    Editable = false;
                }
            }
        }
    }
}