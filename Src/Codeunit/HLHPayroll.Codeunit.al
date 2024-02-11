/// <summary>
/// Codeunit HLH Payroll (ID 50000).
/// </summary>
codeunit 50000 "HLH Payroll"
{
    /// <summary>
    /// calcPercentage.
    /// This function gets the total percentage of the earnings defined in Salary Structure
    /// </summary>
    /// <returns>Return variable totalPercentage of type Decimal.</returns>
    procedure calcPercentage() totalPercentage: Decimal
    var
        hlhSalaryStructure: Record "HLH Salary Structure";
    begin
        hlhSalaryStructure.SetRange(Percentage);
        repeat
            //summing up only the ones that are not deductions
            if (hlhSalaryStructure.Category = hlhSalaryStructure.Category::Basic) or (hlhSalaryStructure.Category = hlhSalaryStructure.Category::Allowances) or (hlhSalaryStructure.Category = hlhSalaryStructure.Category::Housing) or (hlhSalaryStructure.Category = hlhSalaryStructure.Category::Transport) then
                totalPercentage := totalPercentage + hlhSalaryStructure.Percentage;
        until (hlhSalaryStructure.Next() = 0);
        exit(totalPercentage);
    end;

    /// <summary>
    /// minimumTax. Calculate the minimum tax amount payable by an employee
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    /// <returns>Return variable minTax of type Decimal.</returns>
    procedure minimumTax(employee: Record Employee) minTax: Decimal
    begin
        exit((employee."Gross Income" * 1.0) / 100.0);
    end;

    /// <summary>
    /// computedAnnualTax.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    /// <returns>Return variable compAnnTax of type Decimal.</returns>
    procedure computedAnnualTax(employee: Record Employee) compAnnTax: Decimal
    begin
        if (employee."Taxable Income" <= 300000) then
            compAnnTax := (employee."Taxable Income" * 7.0) / 100.0 else
            if (employee."Taxable Income" > 300000) and (employee."Taxable Income" <= 600000) then
                compAnnTax := 21000 + (((employee."Taxable Income" - 300000) * 11) / 100.0) else
                if (employee."Taxable Income" > 600000) and (employee."Taxable Income" <= 1100000) then
                    compAnnTax := 54000 + (((employee."Taxable Income" - 600000) * 15) / 100.0) else
                    if (employee."Taxable Income" > 1100000) and (employee."Taxable Income" <= 1600000) then
                        compAnnTax := 129000 + (((employee."Taxable Income" - 1100000) * 19) / 100.0) else
                        if (employee."Taxable Income" > 1600000) and (employee."Taxable Income" <= 3200000) then
                            compAnnTax := 224000 + (((employee."Taxable Income" - 1600000) * 21) / 100.0)
                        else
                            compAnnTax := 560000 + (((employee."Taxable Income" - 3200000) * 24) / 100.0);
        exit(compAnnTax);
    end;

    /// <summary>
    /// calcAnnualTaxPayable.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    /// <returns>Return variable annTaxPayable of type Decimal.</returns>
    procedure calcAnnualTaxPayable(employee: Record Employee) annTaxPayable: Decimal
    begin
        if (employee."Computed Annual Tax" < employee."Minimum Tax") then
            annTaxPayable := employee."Minimum Tax"
        else
            annTaxPayable := employee."Computed Annual Tax";
        exit(annTaxPayable);
    end;

    /// <summary>
    /// calcConsolationAllowance.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    /// <returns>Return variable consolationAllowance of type Decimal.</returns>
    procedure calcConsolationAllowance(employee: Record Employee) consolationAllowance: Decimal
    begin
        if ((employee."Gross Income" * 1 / 100.0) > 200000) then
            consolationAllowance := employee."Gross Income" * 1 / 100.0 + employee."Gross Income" * 20 / 100.0
        else
            consolationAllowance := 200000 + employee."Gross Income" * 20 / 100.0;
    end;

    /// <summary>
    /// deleteSalary.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    procedure deleteSalary(employee: Record Employee)
    var
        hlhEmpSalaryBreakdown: Record "HLH Emp. Salary Breakdown";
    begin
        //Remove any salary breakdown for employee if it already exist so as to add a new breakdown
        hlhEmpSalaryBreakdown.SetRange("Employee No.", employee."No.");
        if (hlhEmpSalaryBreakdown.Find('-')) then
            repeat
                hlhEmpSalaryBreakdown.Delete(true);
            until (hlhEmpSalaryBreakdown.Next() = 0);
    end;

    /// <summary>
    /// InsertSalary.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    procedure InsertSalary(employee: Record Employee)
    var
        hlhSalaryStructure: Record "HLH Salary Structure";
        hlhEmpSalaryBreakdown: Record "HLH Emp. Salary Breakdown";
        counter: Integer;
        exists: Text;
        ErrLbl: Label 'You need to specify employment type for this employee';
        NoSalSTructureMsg: Label 'Could not fetch Salary Structure Table.\Make sure that the Salary Structure has been set properly.';
    begin
        hlhSalaryStructure.ID := -1;
        hlhSalaryStructure."Use For Payroll" := true;
        hlhEmpSalaryBreakdown.SetRange(ID, 1);
        hlhEmpSalaryBreakdown.SetRange("Employee No.", employee."No.");

        //Check if current employee has salary breakdown already
        if hlhEmpSalaryBreakdown.FindFirst() then
            exists := 'exists'
        else begin
            //Make sure that the salary structure only works for the permanent staff
            if (employee."Employment Type" <> employee."Employment Type"::Contract) and (employee."Employment Type" <> employee."Employment Type"::"Full Time") then
                Error(ErrLbl);
            hlhSalaryStructure.SetRange(ID);
#pragma warning disable AA0005
            if (employee."Employment Type" = employee."Employment Type"::"Full Time") then begin
                if (hlhSalaryStructure.FindSet()) then begin
                    counter := 1;
                    repeat
                        hlhEmpSalaryBreakdown.Init();
                        hlhEmpSalaryBreakdown.Validate(ID, counter);
                        hlhEmpSalaryBreakdown.Validate("Emp. Name", employee.FullName());
                        hlhEmpSalaryBreakdown.Validate("Employee No.", employee."No.");
                        hlhEmpSalaryBreakdown.Validate("Salary Name", hlhSalaryStructure.Name);
                        hlhEmpSalaryBreakdown.Validate(Category, hlhSalaryStructure.Category);
                        hlhEmpSalaryBreakdown.Validate("Salary Description", hlhSalaryStructure.Description);
                        hlhEmpSalaryBreakdown.Validate(Percentage, hlhSalaryStructure.Percentage);
                        hlhEmpSalaryBreakdown.Validate(Amount, ((employee."Monthly Gross" * 12.0) / 100.0) * hlhSalaryStructure.Percentage);
                        hlhEmpSalaryBreakdown.Insert(true);
                        Commit();
                        counter := counter + 1;
                    until (hlhSalaryStructure.Next() = 0);
                end
                Else begin
                    Message(NoSalSTructureMsg);
                end;
            end;
#pragma warning restore AA0005
        end;
    end;

    /// <summary>
    /// modifySalary.
    /// </summary>
    /// <param name="employee">Record Employee.</param>
    procedure modifySalary(employee: Record Employee)
    var
        hlhEmpSalaryBreakdown: Record "HLH Emp. Salary Breakdown";
    begin
        //Remove any salary breakdown for employee if it already exist so as to add a new breakdown
        hlhEmpSalaryBreakdown.SetRange("Employee No.", employee."No.");
        if (hlhEmpSalaryBreakdown.Find('-')) then //begin
            repeat
                hlhEmpSalaryBreakdown.Delete(true);
            until (hlhEmpSalaryBreakdown.Next() = 0);
        // end;
        InsertSalary(employee); //Adding new salary breakdown calculation
    end;

    /// <summary>
    /// reCalculateSalaryDetail.
    /// </summary>
    /// <param name="employee">VAR Record Employee.</param>
    procedure reCalculateSalaryDetail(var employee: Record Employee)
    var
        noOfMonths: Decimal;
        errLbl: Label 'You need to specify employment type for this employee';
    begin
        noOfMonths := 12.0;
        if ((employee."Employment Type" <> employee."Employment Type"::Contract) and (employee."Employment Type" <> employee."Employment Type"::"Full Time")) then
            Error(errLbl);
        if (employee."Employment Type" = employee."Employment Type"::"Full Time") then begin
            employee.SetRange("No.", employee."No.");
            if (employee.FindFirst()) then begin
                employee.Get(employee."No.");
                employee.Validate("Monthly Gross", employee."Annual Gross" / noOfMonths);
                employee.Validate("Annual Basic", (employee."Annual Gross" * 25.0) / 100.0);
                employee.Validate("Annual Housing", (employee."Annual Gross" * 13.0) / 100.0);
                employee.Validate("Annual Transport", (employee."Annual Gross" * 10.0) / 100.0);
                // Add Condition to check if Employee is upto a year or not to be eligible for Allowance -- 11 Dec. 2023
                if ((Today() - employee."Employment Date") > 365) then begin
                    employee.Validate("Leave Allowance", (employee."Annual Basic" * 10.0) / 100.0);
                    employee.Validate("13th Month Allowance", employee."Annual Basic" / 12.0);
                end
                else begin
                    employee.Validate("Leave Allowance", 0);
                    employee.Validate("13th Month Allowance", 0);
                end;
                employee.Validate("Gross Income", employee."Annual Gross" + employee."Leave Allowance" + employee."13th Month Allowance");
                employee.Validate(Pension, ((employee."Annual Basic" + employee."Annual Housing" + employee."Annual Transport") * 8) / 100.0);
                employee.Validate("Consolidated Relief Allowance", calcConsolationAllowance(employee));
                employee.Validate("Taxable Income", employee."Gross Income" - employee.Pension - employee."NH Fund" - employee.NHIS - employee.Gratuities - employee."Life Assurance" - employee."Consolidated Relief Allowance");
                employee.Validate("Computed Annual Tax", computedAnnualTax(employee));
                employee.Validate("Minimum Tax", minimumTax(employee));
                employee.Validate("Annual Tax Payable", calcAnnualTaxPayable(employee));
                employee.Validate("Actual Tax", (employee."Annual Tax Payable" / 12) * noOfMonths);
                employee.Validate(Payee, employee."Actual Tax");
                employee.Validate("Total Annual Deduction", employee.Payee + employee.Pension);
                employee.Validate("Total Allowance", employee."Leave Allowance" + employee."13th Month Allowance");
                employee.Validate("Annual Netpay", employee."Annual Gross" + employee."Total Allowance" - employee."Total Annual Deduction");
                modifySalary(employee);
                employee.Modify(true);
            end;
        end
        else begin
            deleteSalary(employee);
            employee.Validate("Monthly Gross", employee."Annual Gross" / noOfMonths);
            employee.Validate(Payee, (employee."Annual Gross" * 5) / 100.0);
            employee.Validate("Annual Netpay", employee."Annual Gross" - employee.Payee);
            employee."Annual Basic" := 0.0;
            employee."Annual Housing" := 0.0;
            employee."Annual Transport" := 0.0;
            employee."Leave Allowance" := 0.0;
            employee."13th Month Allowance" := 0.0;
            employee."Gross Income" := 0.0;
            employee.Pension := 0.0;
            employee."Consolidated Relief Allowance" := 0.0;
            employee."Taxable Income" := 0.0;
            employee."Computed Annual Tax" := 0.0;
            employee."Minimum Tax" := 0.0;
            employee."Annual Tax Payable" := 0.0;
            employee."Actual Tax" := 0.0;
            employee."Total Annual Deduction" := employee.Payee;
            employee."Total Allowance" := 0.0;
        end;
    end;

    /// <summary>
    /// getEmployeeEmail.
    /// </summary>
    /// <param name="empNo">Text.</param>
    /// <returns>Return variable empEmail of type Text.</returns>
    procedure getEmployeeEmail(empNo: Text) empEmail: Text
    var
        employee: Record Employee;
    begin
        employee.Get(empNo);
        empEmail := employee."Company E-Mail";
        exit(empEmail);
    end;

    /// <summary>
    /// setSalaryApprovalStatus.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="comment">Text.</param>
    /// <param name="approvalStatus">Text.</param>
    procedure setSalaryApprovalStatus(periodCode: Text; comment: Text; approvalStatus: Option)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll("Approval Status", approvalStatus);
            hlhPayrollPeriods.ModifyAll("Approval Comment", comment);
        end;
    end;

    /// <summary>
    /// setRequester.
    /// Sets the name of who requested salary approval
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="requesterID">Text.</param>
    procedure setRequester(periodCode: Text; requesterID: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll(Requester, requesterID);
        end;
    end;

    /// <summary>
    /// setPosted - sets the posted field to true in the payroll periods table
    /// </summary>
    /// <param name="periodCode">Text.</param>
    procedure setPosted(periodCode: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll(Posted, true);
        end;
    end;

    /// <summary>
    /// setPaymentDate - sets the payment date field to reflect when the payment was posted for a salary period
    /// </summary>
    /// <param name="periodCode">Text.</param>
    procedure setPaymentDate(periodCode: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll("Posting Date", Today());
        end;
    end;

    /// <summary>
    /// setApprover.
    /// Sets who approved a salary period
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="approverID">Text.</param>
    procedure setApprovedBy(periodCode: Text; approverID: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll(ApprovedBy, approverID);
        end;
    end;

    /// <summary>
    /// getApprovalStatus.
    /// Gets the approval status of a salary period based on the period code 
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return variable status of type Option.</returns>
    procedure getApprovalStatus(periodCode: Text) status: Option
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.Get(periodCode);
        status := hlhPayrollPeriods."Approval Status";
        exit(status);
    end;

    /// <summary>
    /// get13thMonthAllowancePostedStatus.
    /// Checks if 13th Month Allowance has been posted already
    /// </summary>
    /// <returns>Return variable status of type Boolean.</returns>
    procedure get13thMonthAllowancePostedStatus() status: Boolean
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        status := hlhMyPayCheqSetup."13th Month Posted";
        exit(status);
    end;

    /// <summary>
    /// getLeaveAllowancePostedStatus.
    /// Checks if Leave Allowance has been posted already
    /// </summary>
    /// <returns>Return variable status of type Boolean.</returns>
    procedure getLeaveAllowancePostedStatus() status: Boolean
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        status := hlhMyPayCheqSetup."Leave Allowance Posted";
        exit(status);
    end;

    /// <summary>
    /// getPostingYear.
    /// Gets the last year that 13th Month Allowance was posted
    /// </summary>
    /// <returns>Return variable status of type Boolean.</returns>
    procedure get13thMonthPostedYear() Year: Date
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        Year := hlhMyPayCheqSetup."13 Month Posted Year";
        if (Format(Year) = '') then
            exit(00000101D);
        exit(Year);
    end;

    /// <summary>
    /// getLeavePostiedYear.
    /// Gets the last year that Leave Allowance was posted
    /// </summary>
    /// <returns>Return variable Year of type Date.</returns>
    procedure getLeavePostedYear() Year: Date
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        Year := hlhMyPayCheqSetup."Leave Posted Year";
        if (Format(Year) = '') then
            exit(00000101D);
        exit(Year);
    end;

    /// <summary>
    /// setPostingYear.
    /// Sets the year that 13th Month Allowance was posted
    /// </summary>
    procedure set13thMonthPostingYear()
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        if (hlhMyPayCheqSetup.FindFirst()) then begin
            hlhMyPayCheqSetup.Init();
            hlhMyPayCheqSetup.ModifyAll("13 Month Posted Year", WorkDate());
        end;
    end;

    /// <summary>
    /// setLeavePostingYear.
    /// Sets the year that Leave Allowance was posted
    /// </summary>
    procedure setLeavePostingYear()
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        if (hlhMyPayCheqSetup.FindFirst()) then begin
            hlhMyPayCheqSetup.Init();
            hlhMyPayCheqSetup.ModifyAll("Leave Posted Year", WorkDate());
        end;
    end;

    /// <summary>
    /// set13thMonthAllowancePostedStatus.
    /// </summary>
    procedure set13thMonthAllowancePostedStatus()
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        if (hlhMyPayCheqSetup.FindFirst()) then begin
            hlhMyPayCheqSetup.Init();
            hlhMyPayCheqSetup.ModifyAll("13th Month Posted", true);
        end;
    end;

    /// <summary>
    /// setLeaveAllowancePostedStatus.
    /// </summary>
    procedure setLeaveAllowancePostedStatus()
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        hlhMyPayCheqSetup.Get();
        if (hlhMyPayCheqSetup.FindFirst()) then begin
            hlhMyPayCheqSetup.Init();
            hlhMyPayCheqSetup.ModifyAll("Leave Allowance Posted", true);
        end;
    end;

    /// <summary>
    /// getSalaryPostedStatus.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return variable status of type Boolean.</returns>
    procedure getSalaryPostedStatus(periodCode: Text) status: Boolean
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.Get(periodCode);
        status := hlhPayrollPeriods.Posted;
        exit(status);
    end;

    /// <summary>
    /// getRequestedBY.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return variable requester of type Text.</returns>
    procedure getRequestedBY(periodCode: Text) requester: Text
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.Get(periodCode);
        requester := hlhPayrollPeriods.Requester;
        exit(requester);
    end;

    /// <summary>
    /// closePayrollPeriod.
    /// </summary>
    /// <param name="period">Text.</param>
    procedure closePayrollPeriod(period: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", period);
        if (hlhPayrollPeriods.FindFirst()) then begin
            hlhPayrollPeriods.Init();
            hlhPayrollPeriods.ModifyAll(Closed, true);
        end;
    end;

    /// <summary>
    /// openPayrollPeriod.
    /// </summary>
    /// <param name="period">Text.</param>
    procedure openPayrollPeriod(period: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        isPosted: Boolean;
        errLbl: Label 'You can not open this Payroll Period because it has already been posted!';
    begin
        hlhPayrollPeriods.SetRange("Period Code", period);
        if (hlhPayrollPeriods.FindFirst()) then begin
            isPosted := hlhPayrollPeriods.Posted;
            hlhPayrollPeriods.Init();
            if (isPosted = true) then
                Message(errLbl)
            else
                hlhPayrollPeriods.ModifyAll(Closed, false);
        end;
    end;

    /// <summary>
    /// showAnnuallAllowanceStatus.
    /// </summary>
    /// <returns>Return variable showAnnualAllowances of type Boolean.</returns>
    procedure showAnnuallAllowanceStatus() showAnnualAllowances: Boolean
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        if (hlhMyPayCheqSetup.FindFirst()) then
            showAnnualAllowances := hlhMyPayCheqSetup."Show Annual Allowances";
    end;

    //////////////////BEGINNING OF SALARY CALCULATION
    /// <summary>
    /// calculatePayroll.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="empType">Text.</param>
    procedure calculatePayroll(periodCode: Text; empType: Text)
    var
        employee: Record Employee;
        hlhEmpSalaryBreakdown: Record "HLH Emp. Salary Breakdown";
        hlhMonthlyPayrollLine: Record "HLH Monthly Payroll Line";
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhPayroll: Codeunit "HLH Payroll";
        apprvlStatus: Option "Open","Pending","Approved","Rejected";
        errorMsg: Label 'Payroll Period can not be empty!';
        errLbl: Label 'You must toggle ON the Show Annual Allowance to Generate Salary for December Month!';
        errMsg: Label 'The Payroll period %1 you have chosen is not valid', Comment = '%1 = Payroll Period Code';
        Msg: Label 'Employee %1 has no salary template.\Payroll will exclude this employee from the current salary process!', Comment = '%1 = Employee No.';
        whTax, totalAllowance, Housing, Transport, "Other Allowances" : Decimal;
        currentMonth, month : Text;
    begin
        apprvlStatus := hlhpayroll.getApprovalStatus(periodCode);
        currentMonth := FORMAT(WorkDate(), 0, '<Month Text,9>').ToUpper().Trim();
        month := 'DECEMBER';
#pragma warning disable AA0005
        // if (Format(apprvlStatus) = 'Approved') then begin
        if ((currentMonth = month) and (hlhPayroll.showAnnuallAllowanceStatus() = false)) then begin
            Error(errLbl);
        end
        else
            if ((periodCode <> '') and (empType <> '')) then begin
#pragma warning disable AA0005

                if (empType = 'Full Time') then begin
                    if (employee.FindFirst()) then begin
                        repeat
                            if ((employee.Status = employee.Status::Active) and (employee."Employment Type" = employee."Employment Type"::"Full Time")) then begin

                                hlhEmpSalaryBreakdown.SetRange("Employee No.", employee."No.");
                                if hlhEmpSalaryBreakdown.FindSet() then begin
                                    repeat
                                        hlhMonthlyPayrollLine.SetRange("Payroll Period", periodCode);
                                        hlhMonthlyPayrollLine.SetRange("Employee No.", employee."No.");
                                        hlhMonthlyPayrollLine.SetRange("Salary Type", hlhEmpSalaryBreakdown."Salary Name");
                                        if not (hlhMonthlyPayrollLine.FindFirst()) then begin
                                            hlhMonthlyPayrollLine.Init();
                                            hlhMonthlyPayrollLine.Validate("Employee No.", employee."No.");
                                            hlhMonthlyPayrollLine.Validate("Employee Name", employee.FullName());
                                            if (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Allowances) or (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Housing) or (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Transport) then
                                                totalAllowance := totalAllowance + ((employee."Monthly Gross" * hlhEmpSalaryBreakdown.Percentage) / 100.0);
                                            if (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Housing) then
                                                Housing := (employee."Monthly Gross" * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                            if (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Transport) then
                                                Transport := (employee."Monthly Gross" * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                            if (hlhEmpSalaryBreakdown.Category = hlhEmpSalaryBreakdown.Category::Allowances) then
                                                "Other Allowances" := ("Other Allowances" + (employee."Monthly Gross" * hlhEmpSalaryBreakdown.Percentage) / 100.0);
                                            hlhMonthlyPayrollLine.Validate("Payroll Period", periodCode);
                                            hlhMonthlyPayrollLine.Validate("Salary Type", hlhEmpSalaryBreakdown."Salary Name");
                                            hlhMonthlyPayrollLine.Validate("Salary Category", format(hlhEmpSalaryBreakdown.Category));
                                            hlhMonthlyPayrollLine.Validate("Salary Desc.", hlhEmpSalaryBreakdown."Salary Description");
                                            hlhMonthlyPayrollLine.Validate(Amount, round(((employee."Monthly Gross" * hlhEmpSalaryBreakdown.Percentage) / 100.0), 0.01));
                                            hlhMonthlyPayrollLine.Insert(true);
                                        end
                                        else
                                            Error(errMsg, periodCode);
                                    until hlhEmpSalaryBreakdown.Next() = 0;

                                    hlhMonthlyPayrollHeader.Init();
                                    hlhMonthlyPayrollHeader.Validate("Period Code", periodCode);
                                    hlhMonthlyPayrollHeader.Validate("Employee No.", employee."No.");
                                    hlhMonthlyPayrollHeader.Validate("Employee Name", employee.FullName());
                                    //BEGIN >> New Requests Additions in November 2023
                                    hlhMonthlyPayrollHeader.Validate("First Name", employee."First Name");
                                    hlhMonthlyPayrollHeader.Validate("Middle Name", employee."Middle Name");
                                    hlhMonthlyPayrollHeader.Validate("Last Name", employee."Last Name");
                                    hlhMonthlyPayrollHeader.Validate("Pension Fund Admin.", employee."Pension Fund Admin.");
                                    hlhMonthlyPayrollHeader.Validate("RSA Pin", employee."RSA Pin");
                                    hlhMonthlyPayrollHeader.Validate("Private Phone No.", employee."Mobile Phone No.");
                                    hlhMonthlyPayrollHeader.Validate("Private Email", employee."E-Mail");
                                    //END >> New Requests Additions in November 2023
                                    hlhMonthlyPayrollHeader.Validate(Basic, round((employee."Annual Basic" / 12.0), 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Gross, round(employee."Monthly Gross", 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Housing, round(Housing, 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Transport, round(Transport, 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Other Allowances", round("Other Allowances", 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Emp. Type", Format(employee."Employment Type"));
                                    hlhMonthlyPayrollHeader.Validate(Payee, round((employee.Payee / 12), 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Pension, round((employee.Pension / 12), 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Total Allowances", round(totalAllowance, 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Total Deductions", round(((employee.Payee / 12) + (employee.Pension / 12)), 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Address, employee.Address + ' ' + employee."Address 2" + ' ' + employee.City + ' ' + employee."Country/Region Code");
                                    hlhMonthlyPayrollHeader.Validate(Department, employee.Department);
                                    hlhMonthlyPayrollHeader.Validate(Designation, employee."Job Title");
                                    hlhMonthlyPayrollHeader.Validate("Payer ID", employee."Tax Identification No.");
                                    hlhMonthlyPayrollHeader.Validate("13th Month Allowance", round((hlhMonthlyPayrollHeader.Basic / 12.0), 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Leave Allowance", round(((hlhMonthlyPayrollHeader.Basic * 10) / 100), 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Netpay, round((employee."Monthly Gross" - ((employee.Payee / 12) + (employee.Pension / 12))), 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Days Present", getWorkingDays(periodCode));
                                    //Begin Add Bank Detail
                                    hlhMonthlyPayrollHeader.Validate("Account Number", employee."Bank Account No.");
                                    hlhMonthlyPayrollHeader.Validate("Account Name", employee."Account Name");
                                    hlhMonthlyPayrollHeader.Validate("Bank Name", employee."Bank Name");
                                    hlhMonthlyPayrollHeader.Validate("Bank Code", getBankCode(employee.FullName(), employee."Bank Name"));
                                    hlhMonthlyPayrollHeader.Validate("Bank Sort Code", getBankSortCode(employee.FullName(), employee."Bank Name"));
                                    //End Add Bank Detail
                                    hlhMonthlyPayrollHeader.Insert(true);
                                    totalAllowance := 0;
                                    "Other Allowances" := 0;
                                end
                                else begin
                                    Message(Msg, employee."No.");
                                end;
                            end
                        until employee.Next() = 0;
                    end;
                end;
#pragma warning restore AA0005if
#pragma warning disable AA0005
                //END Salary Calculation for Contract Staff
                if (empType = 'Contract') then begin
                    if (employee.FindFirst()) then begin
                        repeat
                            if ((employee.Status = employee.Status::Active) and (employee."Employment Type" = employee."Employment Type"::Contract)) then begin
                                whTax := (employee."Monthly Gross" * 5) / 100.0;
                                hlhMonthlyPayrollHeader.SetRange("Period Code", periodCode);
                                hlhMonthlyPayrollHeader.SetRange("Employee No.", employee."No.");
                                if (not hlhMonthlyPayrollHeader.FindFirst()) then begin
                                    hlhMonthlyPayrollHeader.Init();
                                    hlhMonthlyPayrollHeader.Validate("Period Code", periodCode);
                                    hlhMonthlyPayrollHeader.Validate("Employee No.", employee."No.");
                                    hlhMonthlyPayrollHeader.Validate("Employee Name", employee.FullName());
                                    hlhMonthlyPayrollHeader.Validate(Gross, round(employee."Monthly Gross", 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Emp. Type", Format(employee."Employment Type"));
                                    hlhMonthlyPayrollHeader.Validate(Payee, round(whTax, 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Total Deductions", round((employee."Total Annual Deduction" / 12), 0.01));
                                    hlhMonthlyPayrollHeader.Validate(Netpay, round((employee."Monthly Gross" - whTax), 0.01));
                                    hlhMonthlyPayrollHeader.Validate("Days Present", getWorkingDays(periodCode));
                                    //Begin Add Bank Detail
                                    hlhMonthlyPayrollHeader.Validate("Account Number", employee."Bank Account No.");
                                    hlhMonthlyPayrollHeader.Validate("Account Name", employee."Account Name");
                                    hlhMonthlyPayrollHeader.Validate("Bank Name", employee."Bank Name");
                                    hlhMonthlyPayrollHeader.Validate("Bank Code", getBankCode(employee.FullName(), employee."Bank Name"));
                                    hlhMonthlyPayrollHeader.Validate("Bank Sort Code", getBankSortCode(employee.FullName(), employee."Bank Name"));
                                    //End Add Bank Detail
                                    hlhMonthlyPayrollHeader.Insert(true);
                                end;
                                //END Insert contract staff salary to same table as full time
                            end;
                        until employee.Next() = 0;
                    end;
                end;
                //END Salary Calculation for Contract Staff
#pragma warning restore AA0005
            end
            else
                Message(errorMsg);
#pragma warning restore AA0005
    end;
    //////////////////ENDING OF SALARY CALCULATION


    //////////////////BEGINNING OF SALARY PRORATION
    /// <summary>
    /// prorateSalary.
    /// </summary>
    /// <param name="Period">Code[100].</param>
    /// <param name="empNo">Text[150].</param>
    /// <param name="noOfDaysWorked">Integer.</param>
    /// <param name="empType">Boolean.</param>
    procedure prorateSalary(Period: Code[100]; empNo: Text[150]; noOfDaysWorked: Integer; empType: Boolean)
    var
        hlhmonthlyPayrollLine: Record "HLH Monthly Payroll Line";
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhEmpSalaryBreakdown: Record "HLH Emp. Salary Breakdown";
        employee: Record Employee;
        noOfDaysInMonth: Integer;
        "Other Allowances", Housing, Transport : Decimal;
        ErrLbl: Label 'Employee %1 has no salary record for the payroll period %2', Comment = '%1 = Employee No.; %2 = Payroll Period Code';
        err1Lbl: Label 'The Employee %1 salary record can not be found!\Please uncheck "Permanent Staff" toggle if employee is Contract Staff or confirm that employee has salary template defined.', Comment = '%1 = Employee No.';
        err2Lbl: Label 'The Employee %1 salary record can not be found!\Please check "Permanent Staff" toggle if employee is Full Staff or confirm that employee has salary template defined.', Comment = '%1 = Employee No.';
        newGross, dailyPay, tempPension, pension, payee, basic, totalAllowance, totalDeduction, whTax, netPay : Decimal;
    begin
        noOfDaysInMonth := getWorkingDays(Period);
        If (empType = true) then begin
            employee.SetRange("No.", empNo);
            employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
            If (employee.FindFirst()) then begin
                dailyPay := employee."Monthly Gross" / noOfDaysInMonth;
                newGross := dailyPay * noOfDaysWorked;

                hlhEmpSalaryBreakdown.SetRange("Employee No.", empNo);
                if (hlhEmpSalaryBreakdown.FindSet()) then begin
                    repeat
                        hlhmonthlyPayrollLine.SetRange("Payroll Period", Period);
                        hlhmonthlyPayrollLine.SetRange("Employee No.", empNo);
                        hlhmonthlyPayrollLine.SetRange("Salary Type", hlhEmpSalaryBreakdown."Salary Name");
#pragma warning disable AA0005
                        if (hlhmonthlyPayrollLine.FindFirst()) then begin
                            repeat
                                hlhmonthlyPayrollLine.Validate(hlhmonthlyPayrollLine.Amount, round(((newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0), 0.01));
                                hlhmonthlyPayrollLine.Modify(true);

                                //calculate new pension amount
                                if ((hlhmonthlyPayrollLine."Salary Category" = 'Basic') or (hlhmonthlyPayrollLine."Salary Category" = 'Housing') or (hlhmonthlyPayrollLine."Salary Category" = 'Transport')) then begin
                                    tempPension := tempPension + (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                end;
                                if (hlhmonthlyPayrollLine."Salary Category" = 'Housing') then
                                    Housing := (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                if (hlhmonthlyPayrollLine."Salary Category" = 'Transport') then
                                    Transport := (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                if (hlhmonthlyPayrollLine."Salary Category" = 'Other Allowances') then begin
                                    "Other Allowances" := ("Other Allowances" + (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0);
                                end;

                                //Get new basic amount
                                if (hlhmonthlyPayrollLine."Salary Category" = 'Basic') then
                                    basic := (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                if (hlhmonthlyPayrollLine."Salary Category" = 'Other Allowances') or (hlhmonthlyPayrollLine."Salary Category" = 'Housing') or (hlhmonthlyPayrollLine."Salary Category" = 'Transport') then begin
                                    totalAllowance := totalAllowance + (newGross * hlhEmpSalaryBreakdown.Percentage) / 100.0;
                                end;
                            until hlhmonthlyPayrollLine.Next() = 0;
                        end
#pragma warning restore AA0005
                        else
                            Error(ErrLbl, empNo, Period);
                    until hlhEmpSalaryBreakdown.Next() = 0;

                    pension := (tempPension * 8) / 100;
                    payee := employee."Annual Tax Payable" / 12 / noOfDaysInMonth * noOfDaysWorked;
                    totalDeduction := pension + payee + hlhMonthlyPayrollHeader."Other Deductions" + hlhMonthlyPayrollHeader."Loan Repayment";
                    netPay := newGross - totalDeduction;

                    hlhMonthlyPayrollHeader.SetRange("Period Code", Period);
                    hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
                    if (hlhMonthlyPayrollHeader.FindFirst()) then begin
                        hlhMonthlyPayrollHeader.Validate(Basic, round(basic, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Gross, round(newGross, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Pension, round(pension, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Payee, round(payee, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Housing, round(Housing, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Transport, round(Transport, 0.1));
                        hlhMonthlyPayrollHeader.Validate("Other Allowances", round("Other Allowances", 0.01));
                        hlhMonthlyPayrollHeader.Validate("Total Allowances", round(totalAllowance, 0.01));
                        hlhMonthlyPayrollHeader.Validate("Total Deductions", round(totalDeduction, 0.01));
                        hlhMonthlyPayrollHeader.Validate(Netpay, round(netPay, 0.01));
                        hlhMonthlyPayrollHeader.Validate("Days Present", noOfDaysWorked);
                        hlhMonthlyPayrollHeader.Modify(true);
                    end;
                end
            end
            else
                Error(err1Lbl, employee.FullName());
        end
        else begin
            noOfDaysInMonth := getWorkingDays(Period);
            employee.SetRange("No.", empNo);
            employee.SetRange(employee."Employment Type", employee."Employment Type"::Contract);
            if (employee.FindFirst()) then begin
                dailyPay := employee."Monthly Gross" / noOfDaysInMonth;
                newGross := dailyPay * noOfDaysWorked;

                //BEGIN prorate contract staff salary to same table as full time
                hlhMonthlyPayrollHeader.SetRange("Period Code", Period);
                hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
                if hlhMonthlyPayrollHeader.FindFirst() then begin
                    whTax := (newGross * 5) / 100.0;
                    hlhMonthlyPayrollHeader.Validate(Gross, round(newGross, 0.01));
                    hlhMonthlyPayrollHeader.Validate(Payee, round(whTax, 0.01));
                    hlhMonthlyPayrollHeader.Validate("Total Deductions", round(whTax + hlhMonthlyPayrollHeader."Other Deductions" + hlhMonthlyPayrollHeader."Loan Repayment", 0.01));
                    hlhMonthlyPayrollHeader.Validate(Netpay, round((newGross - whTax + hlhMonthlyPayrollHeader.Adjustment - hlhMonthlyPayrollHeader."Other Deductions" - hlhMonthlyPayrollHeader."Loan Repayment"), 0.01));
                    hlhMonthlyPayrollHeader.Validate("Days Present", noOfDaysWorked);
                    hlhMonthlyPayrollHeader.Modify(true);
                end;
                //END prorate contract staff salary to same table as full time
            end
            else
                Error(err2Lbl, employee.FullName());
        end;
    end;
    //////////////////ENDING OF SALARY PRORATION



    /// <summary>
    /// getWorkingDays.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure getWorkingDays(periodCode: Text): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        errNoOfDaysLbl: Label 'No. of days for current month has not been set.';
    begin
        hlhPayrollPeriods.SetRange("Period Code", periodCode);
        If (hlhPayrollPeriods.FindFirst()) then
            exit(hlhPayrollPeriods."No Of Days")
        else
            Error(errNoOfDaysLbl);
    end;

    /// <summary>
    /// sendPayslip.
    /// </summary>
    /// <param name="PayPeriod">Code[20].</param>
    /// <param name="empNo">Text.</param>
    /// <param name="empName">text.</param>
    /// <param name="recipient">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure sendPayslip(PayPeriod: Code[20]; empNo: Text; empName: text; recipient: Text): Boolean
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        tempBlob: Codeunit "Temp Blob";
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        base64Convert: Codeunit "Base64 Convert";
        myRecordRef: RecordRef;
        dataInStream: InStream;
        dataOutStream: OutStream;
        txtB64: Text;
        format: ReportFormat;
        MailHdr: Text;
        month, year, monthYear : Text;
    begin
        year := Format(Date2DMY(getEndDate(PayPeriod), 3));
        month := FORMAT(getEndDate(PayPeriod), 0, '<Month Text,9>').ToUpper();
        monthYear := month + '' + year;
        MailHdr := 'Dear ' + empName + ',<br><br> ' +
        'Kindly find attached your Payslip for the month of ' + monthYear + ' for your reference.<br><br>'
        + 'Thank you.';
        hlhMonthlyPayrollHeader.Get(PayPeriod, empNo);
        hlhMonthlyPayrollHeader.SetRange("Period Code", PayPeriod);
        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
        myRecordRef.GetTable(hlhMonthlyPayrollHeader);
        tempBlob.CreateOutStream(dataOutStream);
        if Report.SaveAs(Report::"HLH Payslip", '', format::Pdf, dataOutStream, myRecordRef) then begin
            tempBlob.CreateInStream(dataInStream);
            txtB64 := base64Convert.ToBase64(dataInStream, true);
            emailMessage.Create(recipient, 'Monthly Payslip', MailHdr);
            emailMessage.SetBodyHTMLFormatted(true);
            emailMessage.AddAttachment('Payslip.pdf', 'application/pdf', txtB64);
            if (email.Send(emailMessage, "Email Scenario"::MyPayCheq)) then
                exit(true);
        end;
    end;

    /// <summary>
    /// sendMail.
    /// </summary>
    /// <param name="Recipient">Text.</param>
    /// <param name="Message">Text.</param>
    /// <param name="Subject">Text.</param>
    /// <returns>Return variable mailSent of type Boolean.</returns>
    procedure sendMail(Recipient: Text; Message: Text; Subject: Text) mailSent: Boolean
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        EmailMessage.Create(Recipient, Subject, Message, true);
        if Email.Send(EmailMessage, "Email Scenario"::MyPayCheq) then begin
            mailSent := true;
            exit(mailSent);
        end
        else begin
            mailSent := false;
            exit(mailSent);
        end;

    end;

    /// <summary>
    /// getApproverID.
    /// </summary>
    /// <returns>Return variable approverID of type Text.</returns>
    procedure getApproverID() approverID: Text
    var
        hlhMyPayCheqsetup: Record "HLH MyPayCheq Setup";
        ErrLbl: Label 'Approver ID not found in Setup Management. Please make sure it has been set up.';
    begin
        if hlhMyPayCheqsetup.FindFirst() then begin
            approverID := hlhMyPayCheqsetup."Approver ID";
            exit(approverID);
        end
        else
            Error(ErrLbl);
    end;

    /// <summary>
    /// getApprover2ID.
    /// </summary>
    /// <returns>Return variable approverID of type Text.</returns>
    procedure getApprover2ID() approver2ID: Text
    var
        hlhMyPayCheqsetup: Record "HLH MyPayCheq Setup";
    begin
        if hlhMyPayCheqsetup.FindFirst() then begin
            approver2ID := hlhMyPayCheqsetup."Approver 2 ID";
            exit(approver2ID);
        end;
    end;

    /// <summary>
    /// getApproverEmail.
    /// </summary>
    /// <returns>Return variable approverID of type Text.</returns>
    procedure getApproverEmail() approverMail: Text
    var
        hlhMyPayCheqsetup: Record "HLH MyPayCheq Setup";
    begin
        if hlhMyPayCheqsetup.FindFirst() then begin
            approverMail := hlhMyPayCheqsetup."Approver Email";
            exit(approverMail);
        end;
    end;

    /// <summary>
    /// getApprover2Email.
    /// </summary>
    /// <returns>Return variable approverMail of type Text.</returns>
    procedure getApprover2Email() approver2Mail: Text
    var
        hlhMyPayCheqsetup: Record "HLH MyPayCheq Setup";
    begin
        if hlhMyPayCheqsetup.FindFirst() then begin
            approver2Mail := hlhMyPayCheqsetup."Approver 2 Email";
            exit(approver2Mail);
        end;
    end;

    /// <summary>
    /// getRequestererEmail.
    /// </summary>
    /// <param name="user">Text.</param>
    /// <returns>Return variable approverMail of type Text.</returns>
    procedure getRequesterEmail(user: Text) requesterMail: Text
    var
        userSetup: Record "User Setup";
    begin
        userSetup.SetRange("User ID", user);
        if userSetup.FindFirst() then begin
            requesterMail := userSetup."E-Mail";
            exit(requesterMail);
        end;
    end;


    /// <summary>
    /// getEndDate.
    /// </summary>
    /// <param name="perCode">Text.</param>
    /// <returns>Return variable endDate of type Date.</returns>
    procedure getEndDate(perCode: Text) endDate: Date
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", perCode);
        If (hlhPayrollPeriods.FindFirst()) then
            endDate := hlhPayrollPeriods.End_Date;
    end;

    /// <summary>
    /// getAccountsEmail.
    /// </summary>
    /// <returns>Return variable accountsMail of type Text.</returns>
    procedure getAccountsEmail() accountsMail: Text
    var
        hlhMyPayCheqsetup: Record "HLH MyPayCheq Setup";
    begin
        if hlhMyPayCheqsetup.FindFirst() then begin
            accountsMail := hlhMyPayCheqsetup."Accounts Email";
            exit(accountsMail);
        end;
    end;

    /// <summary>
    /// getPayeeYTD.
    /// </summary>
    /// <param name="empNo">code[200].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure getAnnualLeaveAllowanceYTD(empNo: code[20]): Decimal
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        employee: Record Employee;
        workDate: Text;
        tempLeaveAllowance, leaveAllowanceYTD : Decimal;
    begin
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        employee.Reset();
        employee.SetRange("No.", empNo);
        employee.SetRange(Status, employee.Status::Active);
        employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
        if (employee.FindFirst()) then begin
            hlhPayrollPeriods.SetRange(Posted, true);
            hlhPayrollPeriods.SetRange(Closed, true);
            if (hlhPayrollPeriods.FindSet()) then begin
                repeat
                    if (Format(hlhPayrollPeriods."Start_Date").EndsWith(workDate)) then begin
                        hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
                        if (hlhMonthlyPayrollHeader.FindSet()) then
                            repeat
                                tempLeaveAllowance := tempLeaveAllowance + hlhMonthlyPayrollHeader."Leave Allowance";
                            until hlhMonthlyPayrollHeader.Next() = 0;
                    end;
                until hlhPayrollPeriods.Next() = 0;
                leaveAllowanceYTD := tempLeaveAllowance;
                tempLeaveAllowance := 0;
            end;
            exit(leaveAllowanceYTD);
        end;
    end;

    /// <summary>
    /// getAnnual13MonthAllowanceYTD.
    /// </summary>
    /// <param name="empNo">code[20].</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure getAnnual13MonthAllowanceYTD(empNo: code[20]): Decimal
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        employee: Record Employee;
        workDate: Text;
        temp13thMonth, thirtMnthAllowanceYTD : Decimal;
    begin
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        employee.Reset();
        employee.SetRange("No.", empNo);
        employee.SetRange(Status, employee.Status::Active);
        employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
        if (employee.FindFirst()) then begin
            hlhPayrollPeriods.SetRange(Posted, true);
            hlhPayrollPeriods.SetRange(Closed, true);
            if (hlhPayrollPeriods.FindSet()) then begin
                repeat
                    if (Format(hlhPayrollPeriods."Start_Date").EndsWith(workDate)) then begin
                        hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
                        if (hlhMonthlyPayrollHeader.FindSet()) then
                            repeat
                                temp13thMonth := temp13thMonth + hlhMonthlyPayrollHeader."13th Month Allowance";
                            until hlhMonthlyPayrollHeader.Next() = 0;
                    end;
                until hlhPayrollPeriods.Next() = 0;
                thirtMnthAllowanceYTD := temp13thMonth;
                temp13thMonth := 0;
            end;
            exit(thirtMnthAllowanceYTD);
        end;
    end;

    /// <summary>
    /// isSalaryGenerated.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure isSalaryNotGenerated(periodCode: Text): Boolean
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
    begin
        hlhMonthlyPayrollHeader.SetRange("Period Code", periodCode);
        if (not (hlhMonthlyPayrollHeader.IsEmpty())) then
            exit(true)
        else
            exit(false);
    end;

    /// <summary>
    /// isEmployeeSalaryGenerated.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="empNo">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure isEmployeeSalaryGenerated(periodCode: Text; empNo: Text): Boolean
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
    begin
        hlhMonthlyPayrollHeader.SetRange("Period Code", periodCode);
        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
        if ((hlhMonthlyPayrollHeader.IsEmpty())) then
            exit(false)
        else
            exit(true);
    end;

    /// <summary>
    /// getBankSortCode.
    /// </summary>
    /// <param name="EmpName">Text.</param>
    /// <param name="BankName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure getBankSortCode(EmpName: Text; BankName: Text): Text
    var
        hlhBanksSetup: Record "HLH Banks Setup";
    begin
        hlhBanksSetup.SetRange("Bank Name", BankName);
        if (hlhBanksSetup.FindFirst()) then
            exit(hlhBanksSetup."Sort Code");
    end;

    /// <summary>
    /// getBankCode.
    /// </summary>
    /// <param name="EmpName">Text.</param>
    /// <param name="BankName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure getBankCode(EmpName: Text; BankName: Text): Text
    var
        hlhBanksSetup: Record "HLH Banks Setup";
    begin
        hlhBanksSetup.SetRange("Bank Name", BankName);
        if (hlhBanksSetup.FindFirst()) then
            exit(hlhBanksSetup."Bank Code");
    end;

}

#pragma warning disable AA0215
enumextension 50100 "HLH MyPayCheq Scenarios" extends "Email Scenario"
#pragma warning restore AA0215
{
    value(50100; "MyPayCheq")
    {
        Caption = 'MyPayCheq Email Scenario';
    }
}