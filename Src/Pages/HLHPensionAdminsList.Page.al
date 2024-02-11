/// <summary>
/// Page HLH Pension Admins. List (ID 50004).
/// </summary>
page 50004 "HLH Pension Admins. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HLH Pension Administrators";
    SourceTableView = sorting("PFA Code") order(ascending);
    Caption = 'Pension Fund Administrators';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("PFA Code"; Rec."PFA Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PFA Code field.';
                }
                field("PFA Name"; Rec."PFA Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PFA Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

}