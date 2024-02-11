/// <summary>
/// Page HLH Emp. Salary Breakdown (ID 50005).
/// </summary>
page 50005 "HLH Emp. Salary Breakdown"
{
    PageType = ListPart;
    SourceTable = "HLH Emp. Salary Breakdown";
    Caption = 'Annual Salary Template';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(AnnualSalaryTemplate)
            {
                Caption = 'Annual Salary Template';
                field("Salary Name"; Rec."Salary Name")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of alary Name';
                }
                field("Salary Description"; Rec."Salary Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

}