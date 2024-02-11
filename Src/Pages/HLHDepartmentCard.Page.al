/// <summary>
/// Page HLH Department Card (ID 50001).
/// </summary>
page 50001 "HLH Department Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "HLH Departments";
    Caption = 'Department Card';

    layout
    {
        area(Content)
        {
            group("Department Card")
            {
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
            part(Units; "HLH Department Units List")
            {
                ApplicationArea = All;
                SubPageLink = "Department Code" = field("Department Code");
                UpdatePropagation = Both;
                Editable = Rec."Department Code" <> '';
            }
        }
    }
}