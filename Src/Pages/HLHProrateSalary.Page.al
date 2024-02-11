/// <summary>
/// Page HLH Prorate Salary (ID 50011).
/// </summary>
page 50011 "HLH Prorate Salary"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    RefreshOnActivate = true;
    Caption = 'Prorate Salary';

    layout
    {
        area(Content)
        {
            group("Salary Proration")
            {
                field("Period Code"; "Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    TableRelation = "HLH Payroll Periods" where(Closed = const(false), "Approval Status" = const(Open));
                    ToolTip = 'Specifies the value of the Period Code field.';
                    trigger OnValidate()
                    var
                        getNoOfDays: Codeunit "HLH Payroll";
                    begin
                        noOfDaysInMonth := getNoOfDays.getWorkingDays("Period Code");
                        CurrPage.Payroll.Page.loadMonthlySalaryProration("Period Code", Employee);
                    end;
                }
                field(Employee; Employee)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the Employee field.';
                    trigger OnValidate()
                    var
                        Err: Label 'Payroll Period field must not be empty!';
                    begin
                        if (("Period Code" <> '')) then
                            CurrPage.Payroll.Page.loadMonthlySalaryProration("Period Code", Employee)
                        else
                            Error(Err);
                    end;
                }
                field("No of Work Days in Month"; noOfDaysInMonth)
                {
                    ApplicationArea = All;
                    Caption = 'No of Work Days in Month';
                    Editable = false;
                    ToolTip = 'Specifies the value of the noOfDaysInMonth field.';
                }
                field("No of Days Worked"; noOfWorkedDays)
                {
                    ApplicationArea = All;
                    Caption = 'No of Days Worked';
                    ToolTip = 'Specifies the value of the noOfWorkedDays field.';
                }
                field("Permanent Staff"; empType)
                {
                    ApplicationArea = All;
                    Caption = 'Permanent Staff';
                    ToolTip = 'Specifies the value of the empType field.';
                }
            }
            part("Payroll"; "HLH Monthly Payroll Header")
            {
                Editable = false;
                Caption = 'Monthly Salary Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Prorate)
            {
                ApplicationArea = All;
                Caption = 'Prorate';
                Image = PriceAdjustment;
                ToolTip = 'Executes the Prorate action.';
                trigger OnAction()
                var
                    payrolCU: Codeunit "HLH Payroll";
                    ErrLbl: Label 'Invalid Number of day!\ No. of days present can not be greater than defined days for work in a month.';
                    Err1Lbl: Label 'You can not prorate this payroll because it is either Pending, Rejected or has been Approved';
                    Err2Lbl: Label 'You can not prorate a negative number of days!';
                    MsgLbl: Label 'Salary record has been prorated successfully for %1', Comment = '%1 = Employee Number';
                begin
                    approvalStatus := payrolCU.getApprovalStatus("Period Code");
                    if (payrolCU.getWorkingDays("Period Code") < noOfWorkedDays) then
                        Error(ErrLbl);
                    if (noOfWorkedDays < 0) then
                        Error(Err2Lbl);
                    if ((Format(approvalStatus) = 'Pending') or (Format(approvalStatus) = 'Approved') or (Format(approvalStatus) = 'Rejected')) then
                        Error(Err1Lbl)
                    else begin
                        payrolCU.prorateSalary("Period Code", Employee, noOfWorkedDays, empType);
                        Message(MsgLbl, Employee);
                    end;
                end;
            }

            action(Reset)
            {
                ApplicationArea = All;
                Caption = 'Reset';
                Image = ResetStatus;
                ToolTip = 'Executes the Reset action.';
                trigger OnAction()
                begin
                    ClearAll();
                    CurrPage.Payroll.Page.loadMonthlySalaryProration('NOTHING', 'NOTHING');
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
        else begin
            CurrPage.Payroll.Page.loadMonthlySalaryProration('NOTHING', 'NOTHING');
            empType := true;
        end;
    end;

    var
        "Period Code": Code[100];
        Employee: Text[150];
        noOfWorkedDays: Integer;
        noOfDaysInMonth: Integer;
        empType: Boolean;
        approvalStatus: Option Open,Pending,Approved,Rejected;
}