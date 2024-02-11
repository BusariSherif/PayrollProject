/// <summary>
/// Page HLH Generate Salary (ID 50010).
/// </summary>
page 50010 "HLH Generate Salary"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Generate Salary';

    layout
    {
        area(Content)
        {
            group("Payroll Periods")
            {
                field("Payroll Period"; "Payroll Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    TableRelation = "HLH Payroll Periods" where(Closed = const(false));//, "Approval Status" = const(Approved));
                    ToolTip = 'Specifies the value of the Payroll Period Code field.';
                    trigger OnValidate()
                    begin
                        if (Format("Emp Type") = '') then
                            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod("Payroll Period Code")
                        else
                            CurrPage.Payroll.Page.loadMonthlySalaryHeader("Payroll Period Code", Format("Emp Type"))
                    end;
                }
                field("Emp Type"; "Emp Type")
                {
                    ApplicationArea = All;
                    Caption = 'Employment Type';
                    OptionCaption = ',Full Time,Contract';
                    ToolTip = 'Specifies the value of the Emp Type field.';
                    trigger OnValidate()
                    var
                        ErrLbl: Label 'You must select a Payroll Period first';
                    begin
                        if ("Payroll Period Code" <> '') then
                            CurrPage.Payroll.Page.loadMonthlySalaryHeader("Payroll Period Code", Format("Emp Type"))
                        else
                            Error(ErrLbl);
                    end;
                }
            }
            part("Payroll"; "HLH Monthly Payroll Header")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Monthly Salary Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunPayroll)
            {
                ApplicationArea = All;
                Caption = 'Run Payroll';
                Image = Payroll;
                ToolTip = 'Executes the Run Payroll action.';
                trigger OnAction()
                var
                    calPayroll: Codeunit "HLH Payroll";
                    ErrLbl: Label 'Payroll Period or Employee Type can not be empty!';
                begin
                    if (("Payroll Period Code" = '') or (Format("Emp Type") = '')) then
                        Error(ErrLbl)
                    else
                        calPayroll.calculatePayroll("Payroll Period Code", Format("Emp Type"));
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        accessControl: Record "Access Control";
        errLbl: Label 'You do not have the right permission to open this page';
    begin
        accessControl.SetRange("User Security ID", UserSecurityId());
        accessControl.SetFilter("Role ID", 'HLH Permissions');
        if (accessControl.IsEmpty) then
            Error(errLbl)
        else
            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod(filterByLbl); //load empty table for salary
    end;

    var
        "Payroll Period Code": Code[50];
        "Emp Type": Option "","Full Time","Contract";
        filterByLbl: Label 'Period Code';
}