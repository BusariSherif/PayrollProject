/// <summary>
/// Page HLH Departmet List (ID 50000).
/// </summary>
page 50000 "HLH Departments List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "HLH Department Card";
    Caption = 'Department List';
    SourceTable = "HLH Departments";
    Editable = false;
    SourceTableView = sorting("Department Code") order(ascending);

    layout
    {
        area(Content)
        {
            repeater("Departments List")
            {
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    AboutText = 'Specifies the code of the department.';
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    AboutText = 'Specifies the code of the department.';
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    AboutText = 'Describe further details about the department to be created.';
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

}