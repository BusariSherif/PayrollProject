/// <summary>
/// Page HLH Banks Setup List (ID 50024).
/// </summary>
page 50024 "HLH Banks Setup List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Banks List';
    SourceTable = "HLH Banks Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Long Bank Code"; Rec."Long Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Sort Code"; Rec."Sort Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sort Code field.';
                }
            }
        }
    }
}