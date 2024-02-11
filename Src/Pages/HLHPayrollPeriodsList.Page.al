/// <summary>
/// Page hLH Payroll Periods List (ID 50007).
/// </summary>
page 50007 "HLH Payroll Periods List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HLH Payroll Periods";
    Caption = 'Payroll Periods';
    SourceTableView = sorting("Period Code") order(descending);
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(PayrollPeriods)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Code field.';
                }
                field("Start Date"; Rec."Start_Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start_Date field.';
                    trigger OnValidate()
                    var
                        calcDate: Codeunit "HLH Calc. Days In a Month";
                        ErrLbl: Label 'Start Date can not be greater than End Date';
                    begin
                        if (Rec.End_Date <> 0D) then
                            if Rec."End_Date" < Rec."Start_Date" then
                                Error(ErrLbl)
                            else begin
                                calcDate.CalculateWorkingDays(Rec."Start_Date", Rec."End_Date", WorkingDays, NonWorkingDays, TotalDays);
                                Rec."No Of Days" := WorkingDays;
                            end;
                    end;
                }
                field("End_Date"; Rec."End_Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End_Date field.';
                    trigger OnValidate()
                    var
                        calcDate: Codeunit "HLH Calc. Days In a Month";
                        ErrLbl: Label 'Start Date can not be greater than End Date';
                    begin
                        if Rec."End_Date" < Rec."Start_Date" then
                            Error(ErrLbl)
                        else begin
                            calcDate.CalculateWorkingDays(Rec."Start_Date", Rec."End_Date", WorkingDays, NonWorkingDays, TotalDays);
                            Rec."No Of Days" := WorkingDays;
                        end;
                    end;
                }
                field(Status; Rec.Closed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("No Of Days"; Rec."No Of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No Of Days field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(ApprovedBy; Rec.ApprovedBy)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approved By field.';
                    Editable = false;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requester field.';
                }
                field("Approval Comment"; Rec."Approval Comment")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Comment field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ClosePeriod)
            {
                ApplicationArea = All;
                Image = ClosePeriod;
                Caption = 'Close Payroll Period';
                ToolTip = 'Executes the Close Payroll Period action.';
                trigger OnAction();
                var
                    closePeriod: codeunit "HLH Payroll";
                    confirmResponse: Boolean;
                    ErrLbl: Label 'Are you sure you want to close this payroll Period?';
                begin
                    confirmResponse := Dialog.Confirm(ErrLbl, false);
                    if (confirmResponse = true) then
                        closePeriod.closePayrollPeriod(Rec."Period Code");
                end;
            }
            action(OpenPeriod)
            {
                ApplicationArea = All;
                Image = ReOpen;
                Caption = 'Open Payroll Period';
                ToolTip = 'Executes the Open Payroll Period action.';
                trigger OnAction();
                var
                    openPeriod: codeunit "HLH Payroll";
                    ErrLbl: Label 'Invalid Action! Number of WorkDays have not yet been defined for this period.';
                begin
                    if (Rec."No Of Days" <= 0) or (Rec.End_Date = 0D) then
                        Error(ErrLbl);
                    openPeriod.openPayrollPeriod(Rec."Period Code");
                end;
            }
        }
    }
    var
        WorkingDays: Integer;
        NonWorkingDays: Integer;
        TotalDays: Integer;
}