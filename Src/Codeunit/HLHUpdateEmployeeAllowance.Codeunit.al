/// <summary>
/// Codeunit HLH Update Employee Allowance (ID 50004).
/// This codeunit will run through a job queue to update any full time employee 
/// whose employment is active and has clocked a year to update their leave and 13th month allowances
/// Else if the employee is not upto a year, it removes their leave and 13th month allowances.
/// </summary>
codeunit 50004 "HLH Update Employee Allowance"
{
    trigger OnRun()
    var
        employee: Record Employee;
        hlhPayroll: Codeunit "HLH Payroll";
    begin
        employee.SetRange("No.");
        employee.SetRange(Status, employee.Status::Active);
        employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
        if employee.FindSet() then
            repeat
                //If Employee is above a year 
                if ((Today - employee."Employment Date" > 365) and (employee."Leave Allowance" = 0) and (employee."13th Month Allowance" = 0)) then begin
                    employee.Validate("Leave Allowance", (employee."Annual Basic" * 10.0) / 100.0);
                    employee.Validate("13th Month Allowance", employee."Annual Basic" / 12.0);
                    employee.Modify(true);
                    hlhPayroll.reCalculateSalaryDetail(employee);
                end
                else
                    //If Employee is less than a year
                    if ((Today - employee."Employment Date" <= 365) and (employee."Leave Allowance" > 0) and (employee."13th Month Allowance" > 0)) then begin
                        employee.Validate("Leave Allowance", 0);
                        employee.Validate("13th Month Allowance", 0);
                        employee.Modify(true);
                        hlhPayroll.reCalculateSalaryDetail(employee);
                    end;
                employee.Reset();
            until employee.Next() = 0;
    end;
}