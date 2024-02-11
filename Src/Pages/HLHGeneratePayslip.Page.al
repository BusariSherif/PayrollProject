/// <summary>
/// Page Generate Payslip (ID 50012).
/// </summary>
page 50012 "HLH Generate Payslip"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group("Generate Payslip")
            {
                field("Period Code"; "Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    TableRelation = "HLH Payroll Periods" where(Posted = const(true));
                    ToolTip = 'Specifies the value of the Period Code field.';
                    trigger OnValidate()
                    var
                        getAnnAllowanceStatus: Codeunit "HLH Payroll";
                        Err: Label 'Payroll Period field must not be empty!';
                    begin
                        if (("Period Code" <> '')) then begin
                            CurrPage.Payroll.Page.loadMonthlySalaryByPeriodFullStaff("Period Code");
                            showAnnuallAllowances := getAnnAllowanceStatus.showAnnuallAllowanceStatus();
                        end
                        else
                            Error(Err);
                    end;
                }
                field(Employee; Employee)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No';
                    TableRelation = Employee."No." where("Employment Type" = const("Full Time"));
                    ToolTip = 'Specifies the value of the Employee field.';
                    trigger OnValidate()
                    var
                        Err: Label 'Payroll Period field must not be empty!';
                    begin
                        if (("Period Code" <> '')) then
                            CurrPage.Payroll.Page.loadMonthlyFullTimeSalary("Period Code", Employee)
                        else
                            Error(Err);
                    end;
                }
                field("Show Annual Allowances"; showAnnuallAllowances)
                {
                    ApplicationArea = All;
                    Caption = 'Show Annual Allowances';
                    ToolTip = 'Specifies the value of the showAnnuallAllowances field.';
                    Editable = false;
                    trigger OnValidate()
                    var
                        setup: Record "HLH MyPayCheq Setup";
                    begin
                        if (setup.FindFirst()) then begin
                            setup.Init();
                            setup.ModifyAll("Show Annual Allowances", showAnnuallAllowances);
                        end;
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
            action(GeneratePayslip)
            {
                ApplicationArea = All;
                Caption = 'Generate Payslip';
                Image = Report;
                ToolTip = 'Executes the Generate Payslip action.';
                trigger OnAction()
                var
                    hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
                    hlhPayrollPeriod: Record "HLH Payroll Periods";
                    salReport: Report "HLH Payslip";
                    errLbl: Label 'Payslip can not be generated for this Payroll Period because it has not been posted!';
                begin
                    hlhPayrollPeriod.SetRange("Period Code", "Period Code");
                    if (hlhPayrollPeriod.FindFirst()) then
                        if (hlhPayrollPeriod.Posted = true) then begin
                            hlhMonthlyPayrollHeader.SetCurrentKey("Period Code", "Employee No.");
                            hlhMonthlyPayrollHeader.SetRange("Period Code", "Period Code");
                            hlhMonthlyPayrollHeader.setRange("Employee No.", Employee);
                            salReport.SetTableView(hlhMonthlyPayrollHeader);
                            salReport.Run();
                        end
                        else
                            Message(errLbl);
                end;
            }
            action(SendPayslip)
            {
                ApplicationArea = All;
                Caption = 'Send Payslips';
                Image = SendEmailPDF;
                ToolTip = 'Executes the Send Payslips action.';
                trigger OnAction()
                var
                    payRecords: Record "HLH Monthly Payroll Header";
                    hlhPayrollPeriod: Record "HLH Payroll Periods";
                    payrollCU: Codeunit "HLH Payroll";
                    ErrLbl: Label '%1 has no email account/address.', Comment = '%1 = Employee No.';
                    Err1Lbl: Label 'No salary record found for this period';
                    Err2Lbl: Label '%1 has no email account/address.', Comment = '%1 = Employee No.';
                    Err3Lbl: Label 'No salary record found for this period';
                    err4Lbl: Label 'Payslip can not be generated for this Payroll Period because it has not been posted!';
                    sendSuccessLbl: Label 'Payslip has been sent successfully!';
                    EmpEmail: Text;
                begin
                    //BEGIN Send Payslip to all employees
                    if (("Period Code" <> '') and (Employee = '')) then begin
                        hlhPayrollPeriod.SetRange("Period Code", "Period Code");
                        if (hlhPayrollPeriod.FindFirst()) then
                            if (hlhPayrollPeriod.Posted = true) then begin
                                payRecords.SetRange("Period Code", "Period Code");
                                payRecords.SetRange("Emp. Type", 'Full Time');
#pragma warning disable AA0005
                                if payRecords.FindSet() then begin
                                    repeat
                                        if (payrollCU.getEmployeeEmail(payRecords."Employee No.") = '') then
                                            Message(ErrLbl, payRecords."Employee No.")
                                        else begin
                                            EmpEmail := payrollCU.getEmployeeEmail(payRecords."Employee No.");
                                            payrollCU.sendPayslip("Period Code", payRecords."Employee No.", payRecords."Employee Name", EmpEmail);
                                        end;
                                        EmpEmail := '';
                                    until payRecords.Next() = 0;
                                end
#pragma warning restore AA0005
                                else
                                    Error(Err1Lbl);
                            end
                            else
                                Message(err4Lbl);
                    end;
                    //END Send Payslip to all employees

                    //BEGIN Send Payslip to selected employee only
                    if (("Period Code" <> '') and (Employee <> '')) then begin
                        hlhPayrollPeriod.SetRange("Period Code", "Period Code");
                        if (hlhPayrollPeriod.FindFirst()) then
                            if (hlhPayrollPeriod.Posted = true) then begin
                                payRecords.SetRange("Period Code", "Period Code");
                                payRecords.SetRange("Employee No.", Employee);
#pragma warning disable AA0005
                                if payRecords.FindSet() then begin
                                    repeat
                                        if (payrollCU.getEmployeeEmail(payRecords."Employee No.") = '') then
                                            Message(Err2Lbl, payRecords."Employee No.")
                                        else begin
                                            EmpEmail := payrollCU.getEmployeeEmail(Employee);
                                            if (payrollCU.sendPayslip("Period Code", payRecords."Employee No.", payRecords."Employee Name", EmpEmail)) then
                                                Message(sendSuccessLbl);
                                        end;
                                    until payRecords.Next() = 0;
                                end
#pragma warning restore AA0005
                                else
                                    Error(Err3Lbl);
                            end
                            else
                                Message(err4Lbl);
                    end;
                end;
                //END Send Payslip to selected employee only
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
            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod('NOTHING');
    end;

    /// <summary>
    /// getYTD.
    /// </summary>
    /// <param name="perCode">code[200].</param>
    /// <param name="empNo">Code[200].</param>
    /// <param name="salaryItem">Text.</param>
    //     procedure getYTD(perCode: code[200]; empNo: Code[200]; salaryItem: Text)
    //     var
    //         hlhMonthlyPayrollLine: Record "HLH Monthly Payroll Line";
    //         hlhPayrollperiods: Record "HLH Payroll Periods";
    //         workDate: Text;
    //     begin
    //         workDate := Format(System.WorkDate()).Split('/').Get(3);
    //         hlhPayrollperiods.SetRange(Closed, true);
    // #pragma warning disable AA0005
    //         if (hlhPayrollperiods.FindSet()) then begin
    //             repeat
    //                 if (Format(hlhPayrollperiods."Start_Date").EndsWith('22')) then begin
    //                     hlhMonthlyPayrollLine.SetRange("Payroll Period", hlhPayrollperiods."Period Code");
    //                     hlhMonthlyPayrollLine.SetRange("Employee No.", empNo);
    //                     hlhMonthlyPayrollLine.SetRange("Salary Type", salaryItem);
    //                     if (hlhMonthlyPayrollLine.FindSet()) then begin
    //                         repeat
    //                             toPrint := toPrint + hlhMonthlyPayrollLine.Amount;
    //                         until hlhMonthlyPayrollLine.Next() = 0;
    //                     end;
    //                 end;
    //             until hlhPayrollperiods.Next() = 0;
    //         end;
    // #pragma warning restore AA0005
    //     end;

    var
        "Period Code": Code[20];
        Employee: Text[200];
        // toPrint: Decimal;
        showAnnuallAllowances: Boolean;
}