/// <summary>
/// Page HLH Monthly Payroll Part (ID 50009).
/// </summary>
page 50009 "HLH Monthly Payroll Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "HLH Monthly Payroll Line";
    Caption = 'Monthly Payroll Line';
    ShowFilter = true;


    layout
    {
        area(Content)
        {
            repeater("Monthly Payroll")
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Salary Type"; Rec."Salary Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Type field.';
                }
            }
        }
    }

    /// <summary>
    /// loadMonthlySalaryLine.
    /// </summary>
    /// <param name="Pay Period">code[50].</param>
    procedure loadMonthlySalaryLine("Pay Period": code[50])
    begin
        Rec.SetRange("Payroll Period", "Pay Period");
        Rec.SetFilter(Rec."Payroll Period", "Pay Period");
        CurrPage.Update();
    end;
}