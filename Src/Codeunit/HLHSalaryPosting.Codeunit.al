/// <summary>
/// Codeunit HLH Salary Posting (ID 50003).
/// </summary>
codeunit 50003 "HLH Salary Posting"
{
    /// <summary>
    /// PostSalary.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure PostSalary(periodCode: Text): Boolean
    var
        LineGenJournalLine: Record "Gen. Journal Line";
        employee: Record Employee;
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
        hlhmonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        GLPostGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        hlhpayroll: Codeunit "HLH Payroll";
        apprvlStatus: Option "Open","Pending","Approved","Rejected";
        successMsg: Label 'Salary details has been posted successfully', Comment = 'Success Message after posting';
        errLbl: Label 'The Payroll Period you have selected has not been approved or has previosly been posted!';
        err1Lbl: Label 'Unable to Process Posting.\The Pension Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err2Lbl: Label 'Unable to Process Posting.\The Payee Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err3Lbl: Label 'Unable to Process Posting.\The Net Account No has not been setup in the MyPayCheq Salary Posting Setup!';
        err3bLbl: Label 'Unable to Process Posting.\The Net Account Type has not been setup in the MyPayCheq Salary Posting Setup!';
        err4Lbl: Label 'Unable to Process Posting.\The Debit Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err5Lbl: Label 'Unable to Process Posting.\The W/H Tax Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err6Lbl: Label 'Unable to Process Posting for %1.\No loan account was found in the employee page.', Comment = '%1 is the employee No';
        err7Lbl: Label 'Unable to Process Posting.\No Salary Adjustment account was found in the MyPayCheq Salary Posting Setup page.';
    begin

        apprvlStatus := hlhpayroll.getApprovalStatus(periodCode);
        if ((Format(apprvlStatus) = 'Approved') and (hlhpayroll.getSalaryPostedStatus(periodCode) = false)) then begin
            employee.Reset();
            employee.SetRange(Status, employee.Status::Active);
            if (employee.FindSet()) then
                repeat
                    hlhmonthlyPayrollHeader.Reset();
                    hlhmonthlyPayrollHeader.SetRange("Period Code", periodCode);
                    hlhmonthlyPayrollHeader.SetRange("Employee No.", employee."No.");
                    if (hlhmonthlyPayrollHeader.FindSet()) then
                        repeat
                            if (hlhmonthlyPayrollHeader."Emp. Type" = 'Full Time') then begin
                                ////////Full Time Staff Salary Posting Starts Here
                                if (getPensionAccount() = '') then
                                    Error(err1Lbl);
                                if (getPayeeAccount() = '') then
                                    Error(err2Lbl);
                                if ((getNetAccount() = '') and (Format(getNetAccountType()) = 'G/L Account')) then
                                    Error(err3Lbl);
                                if (Format(getNetAccountType()) = '') then
                                    Error(err3bLbl);
                                if (Format(getDebitAccountType()) = '') then
                                    Error(err4Lbl);
                                if ((getEmpLoanAccount(employee."No.") = '') and (hlhmonthlyPayrollHeader."Loan Repayment" > 0)) then
                                    Error(err6Lbl, employee."No.");
                                if ((getSalaryAdjAccount() = '') and (hlhmonthlyPayrollHeader.Adjustment > 0)) then
                                    Error(err7Lbl);
                                if ((getSalaryAdjAccount() = '') and (hlhmonthlyPayrollHeader."Other Deductions" > 0)) then
                                    Error(err7Lbl)
                                else begin
                                    //////////HEADER POSTING BEGIN -- 
                                    LineGenJournalLine.Reset();
                                    if (Format(getDebitAccountType()) = 'Employee') then begin
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::Employee);
                                        LineGenJournalLine.Validate("Account No.", employee."No.");
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        //Adding new stuff here - November
                                        LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Payee + hlhmonthlyPayrollHeader.Pension + hlhmonthlyPayrollHeader.Netpay + hlhmonthlyPayrollHeader."Loan Repayment" + hlhmonthlyPayrollHeader."Other Deductions" - hlhmonthlyPayrollHeader.Adjustment);
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                    end
                                    else
                                        if (Format(getDebitAccountType()) = 'G/L Account') then begin
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::"G/L Account");
                                            LineGenJournalLine.Validate("Account No.", getDebitAccountNo());
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            //Adding new stuff here  - November
                                            LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Payee + hlhmonthlyPayrollHeader.Pension + hlhmonthlyPayrollHeader.Netpay + hlhmonthlyPayrollHeader."Loan Repayment" + hlhmonthlyPayrollHeader."Other Deductions" - hlhmonthlyPayrollHeader.Adjustment);
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end;
                                    //////////HEADER POSTING END

                                    //////////LINE POSTING BEGIN
                                    LineGenJournalLine.Init();
                                    LineGenJournalLine.Validate("Posting Date", WorkDate());
                                    LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                    LineGenJournalLine.Validate("Document No.", periodCode);
                                    LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                    LineGenJournalLine.Validate("Account No.", getPayeeAccount());
                                    LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                    LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Payee);
                                    GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);

                                    LineGenJournalLine.Init();
                                    LineGenJournalLine.Validate("Posting Date", WorkDate());
                                    LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                    LineGenJournalLine.Validate("Document No.", periodCode);
                                    LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                    LineGenJournalLine.Validate("Account No.", getPensionAccount());
                                    LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                    LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Pension);
                                    GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);

                                    //November Feature Added here
                                    if (hlhmonthlyPayrollHeader."Loan Repayment" > 0) then begin
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                        LineGenJournalLine.Validate("Account No.", getEmpLoanAccount(employee."No."));
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader."Loan Repayment");
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                    end;

                                    if (hlhmonthlyPayrollHeader.Adjustment > 0) then begin
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                        LineGenJournalLine.Validate("Account No.", getSalaryAdjAccount());
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Adjustment);
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                    end;

                                    if (hlhmonthlyPayrollHeader."Other Deductions" > 0) then begin
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                        LineGenJournalLine.Validate("Account No.", getSalaryAdjAccount());
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader."Other Deductions");
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                    end;

                                    //November Feature Ends here

                                    if (Format(getNetAccountType()) = 'Employee') then begin
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::Employee);
                                        LineGenJournalLine.Validate("Account No.", employee."No.");
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Netpay);
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                    end
                                    else
                                        if (Format(getNetAccountType()) = 'G/L Account') then begin
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                            LineGenJournalLine.Validate("Account No.", getNetAccount());
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Netpay);
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end;
                                    LineGenJournalLine.Reset();
                                    //////////LINE POSTING END
                                    ////////Full Time Staff Salary Posting Ends Here
                                end;
                            end
                            else
                                if (hlhmonthlyPayrollHeader."Emp. Type" = 'Contract') then begin
                                    ////////Contract Staff Salary Posting Starts Here
                                    if (getWHTaxAccount() = '') then
                                        Error(err5Lbl);
                                    if ((getNetAccount() = '') and (Format(getNetAccountType()) = 'G/L Account')) then
                                        Error(err3Lbl);
                                    if (Format(getNetAccountType()) = '') then
                                        Error(err3bLbl);
                                    if (Format(getDebitAccountType()) = '') then
                                        Error(err4Lbl);
                                    if ((getEmpLoanAccount(employee."No.") = '') and (hlhmonthlyPayrollHeader."Loan Repayment" > 0)) then
                                        Error(err6Lbl, employee."No.");
                                    if ((getSalaryAdjAccount() = '') and ((hlhmonthlyPayrollHeader.Adjustment > 0))) then
                                        Error(err7Lbl);
                                    if ((getSalaryAdjAccount() = '') and (hlhmonthlyPayrollHeader."Other Deductions" > 0)) then
                                        Error(err7Lbl)
                                    else begin
                                        //////////HEADER POSTING BEGIN -- 
                                        LineGenJournalLine.Reset();
                                        if (Format(getDebitAccountType()) = 'Employee') then begin
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::Employee);
                                            LineGenJournalLine.Validate("Account No.", employee."No.");
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Payee + hlhmonthlyPayrollHeader.Netpay + hlhmonthlyPayrollHeader."Loan Repayment" + hlhmonthlyPayrollHeader."Other Deductions" - hlhmonthlyPayrollHeader.Adjustment);
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end
                                        else
                                            if (Format(getDebitAccountType()) = 'G/L Account') then begin
                                                LineGenJournalLine.Init();
                                                LineGenJournalLine.Validate("Posting Date", WorkDate());
                                                LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                                LineGenJournalLine.Validate("Document No.", periodCode);
                                                LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::"G/L Account");
                                                LineGenJournalLine.Validate("Account No.", getDebitAccountNo());
                                                LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                                LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Payee + hlhmonthlyPayrollHeader.Netpay + hlhmonthlyPayrollHeader."Loan Repayment" + hlhmonthlyPayrollHeader."Other Deductions" - hlhmonthlyPayrollHeader.Adjustment);
                                                GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                            end;
                                        //////////HEADER POSTING END

                                        //////////LINE POSTING BEGIN
                                        LineGenJournalLine.Init();
                                        LineGenJournalLine.Validate("Posting Date", WorkDate());
                                        LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                        LineGenJournalLine.Validate("Document No.", periodCode);
                                        LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                        LineGenJournalLine.Validate("Account No.", getWHTaxAccount());
                                        LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                        LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Payee);
                                        GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);

                                        //November Feature Added here
                                        if (hlhmonthlyPayrollHeader."Loan Repayment" > 0) then begin //If employee has loan
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                            LineGenJournalLine.Validate("Account No.", getEmpLoanAccount(employee."No."));
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader."Loan Repayment");
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end;

                                        if (hlhmonthlyPayrollHeader.Adjustment > 0) then begin  //If employee has Adjustment
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                            LineGenJournalLine.Validate("Account No.", getSalaryAdjAccount());
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, hlhmonthlyPayrollHeader.Adjustment);
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end;

                                        if (hlhmonthlyPayrollHeader."Other Deductions" > 0) then begin //If employee has Other Deductions
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                            LineGenJournalLine.Validate("Account No.", getSalaryAdjAccount());
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader."Other Deductions");
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end;
                                        //November Feature Ends here

                                        if (Format(getNetAccountType()) = 'Employee') then begin
                                            LineGenJournalLine.Init();
                                            LineGenJournalLine.Validate("Posting Date", WorkDate());
                                            LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                            LineGenJournalLine.Validate("Document No.", periodCode);
                                            LineGenJournalLine.Validate("Account Type", LineGenJournalLine."Account Type"::Employee);
                                            LineGenJournalLine.Validate("Account No.", employee."No.");
                                            LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                            LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Netpay);
                                            GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                        end
                                        else
                                            if (Format(getNetAccountType()) = 'G/L Account') then begin
                                                LineGenJournalLine.Init();
                                                LineGenJournalLine.Validate("Posting Date", WorkDate());
                                                LineGenJournalLine.Validate("Document Type", LineGenJournalLine."Document Type"::" ");
                                                LineGenJournalLine.Validate("Document No.", periodCode);
                                                LineGenJournalLine.Validate("Account Type", hlhPostingSetupLine."Account Type"::"G/L Account");
                                                LineGenJournalLine.Validate("Account No.", getNetAccount());
                                                LineGenJournalLine.Validate(Description, hlhmonthlyPayrollHeader."Employee Name");
                                                LineGenJournalLine.Validate(Amount, -hlhmonthlyPayrollHeader.Netpay);
                                                GLPostGenJnlPostLine.RunWithCheck(LineGenJournalLine);
                                            end;
                                        LineGenJournalLine.Reset();
                                        //////////LINE POSTING SETUP END
                                        ////////Contract Staff Salary Posting Starts Here
                                    end;
                                end;

                        until hlhmonthlyPayrollHeader.Next() = 0;
                until employee.Next() = 0;
            hlhpayroll.setPosted(periodCode);
            hlhpayroll.closePayrollPeriod(periodCode);
            hlhpayroll.setPaymentDate(periodCode);
            Message(successMsg);
        end
        else
            Error(errLbl);
    end;


    /// <summary>
    /// getDebitAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getDebitAccountNo(): Code[20]
    var
        hlhSalaryPostingSetup: Record "HLH Salary Posting Setup";
    begin
        hlhSalaryPostingSetup.Get();
        if (hlhSalaryPostingSetup.FindFirst()) then
            exit(hlhSalaryPostingSetup."Account No");
    end;

    /// <summary>
    /// getDebitAccountType.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getDebitAccountType(): Option "G/L Account","Employee"
    var
        hlhSalaryPostingSetup: Record "HLH Salary Posting Setup";
    begin
        hlhSalaryPostingSetup.Get();
        if (hlhSalaryPostingSetup.FindFirst()) then
            exit(hlhSalaryPostingSetup."Account Type");
    end;

    /// <summary>
    /// getDebitAccountSalaryType.
    /// </summary>
    /// <returns>Return value of type Option.</returns>
    procedure getDebitAccountSalaryType(): Option "Gross","Net"
    var
        hlhSalaryPostingSetup: Record "HLH Salary Posting Setup";
    begin
        hlhSalaryPostingSetup.Get();
        if (hlhSalaryPostingSetup.FindFirst()) then
            exit(hlhSalaryPostingSetup."Salary Type");
    end;

    /// <summary>
    /// getPayeeAccount.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure getPayeeAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::Payee);
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// getPensionAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getPensionAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::Pension);
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// getNetAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getNetAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::Net);
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// getNetAccountType.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getNetAccountType(): Option "G/L Account","Employee"
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::Net);
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account Type");
    end;

    /// <summary>
    /// getWHTaxAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getWHTaxAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::"W/H Tax");
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// get13thMonthAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure get13thMonthAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::"13th Month");
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// getLeaveAllowanceAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getLeaveAllowanceAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::"Leave Allowance");
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.");
    end;

    /// <summary>
    /// getSalaryAdjAccount.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure getSalaryAdjAccount(): Code[20]
    var
        hlhPostingSetupLine: Record "HLH Posting Setup Line";
    begin
        hlhPostingSetupLine.SetRange("Salary Type", hlhPostingSetupLine."Salary Type"::"Postive/Negative Adj.");
        if (hlhPostingSetupLine.FindFirst()) then
            exit(hlhPostingSetupLine."Account No.")
        else
            exit('');
    end;

    /// <summary>
    /// getEmpLoanAccount.
    /// </summary>
    /// <param name="empNo">Text.</param>
    /// <returns>Return value of type Code[20].</returns>
    procedure getEmpLoanAccount(empNo: Text): Code[20]
    var
        employee: Record Employee;
    begin
        if (employee.Get(empNo)) then
            exit(employee."Loan Account No");
    end;

    /// <summary>
    /// postAnnualAllowances.
    /// </summary>
    procedure postAnnualLeaveAllowances()
    var
        employee: Record Employee;
        LAnnLineGenJournalLine: Record "Gen. Journal Line";
        LAnnGLPostGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        hlhpayroll: Codeunit "HLH Payroll";
        workDate, lastPostedYear, currentMonth, month : Text;
        successMsg: Label 'Annual Leave Allowances details has been posted successfully', Comment = 'Success Message after posting';
        err1Lbl: Label 'Unable to Process Posting.\The Leave Allowance Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err2Lbl: Label 'Unable to Process Posting.\The 13th Month Allowance Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err3Lbl: Label 'Unable to Process Posting.\The Net Account No has not been setup in the MyPayCheq Salary Posting Setup!';
        err3bLbl: Label 'Unable to Process Posting.\The Net Account Type has not been setup in the MyPayCheq Salary Posting Setup!';
        err4Lbl: Label 'Unable to Process Posting.\Annual Leave Allowance has been posted already for this Year!';
        err6Lbl: Label 'Unable to Process Posting.\You can only post Annual Leave Allowance in DECEMBER';
    begin
        lastPostedYear := Format(hlhpayroll.getLeavePostedYear()).Split('/').Get(3);
        currentMonth := FORMAT(WorkDate(), 0, '<Month Text,9>').ToUpper().Trim();
        month := 'DECEMBER';
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        if (getLeaveAllowanceAccount() = '') then
            Error(err1Lbl);
        if (get13thMonthAccount() = '') then
            Error(err2Lbl);
        if ((getNetAccount() = '') and (Format(getNetAccountType()) = 'G/L Account')) then
            Error(err3Lbl);
        if (Format(getNetAccountType()) = '') then
            Error(err3bLbl);
        if (currentMonth <> month) then
            Error(err6Lbl);
        if ((hlhpayroll.getLeaveAllowancePostedStatus() = true) and (lastPostedYear = workDate)) then
            Error(err4Lbl)
        else begin
            employee.Reset();
            employee.SetRange(Status, employee.Status::Active);
            employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
            if (employee.FindSet()) then
                repeat
                    if (hlhpayroll.getAnnualLeaveAllowanceYTD(employee."No.") > 0) then begin
                        ////////// LEAVE ALLOWANCE POSTING BEGINS
                        LAnnLineGenJournalLine.Init();
                        LAnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                        LAnnLineGenJournalLine.Validate("Document Type", LAnnLineGenJournalLine."Document Type"::" ");
                        LAnnLineGenJournalLine.Validate("Document No.", 'Leave Allowance' + workDate);
                        LAnnLineGenJournalLine.Validate("Account Type", LAnnLineGenJournalLine."Account Type"::"G/L Account");
                        LAnnLineGenJournalLine.Validate("Account No.", getLeaveAllowanceAccount());
                        LAnnLineGenJournalLine.Validate(Description, employee.FullName());
                        LAnnLineGenJournalLine.Validate(Amount, hlhpayroll.getAnnualLeaveAllowanceYTD(employee."No."));
                        LAnnGLPostGenJnlPostLine.RunWithCheck(LAnnLineGenJournalLine);

                        if (Format(getNetAccountType()) = 'Employee') then begin
                            LAnnLineGenJournalLine.Init();
                            LAnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                            LAnnLineGenJournalLine.Validate("Document Type", LAnnLineGenJournalLine."Document Type"::" ");
                            LAnnLineGenJournalLine.Validate("Document No.", 'Leave Allowance' + workDate);
                            LAnnLineGenJournalLine.Validate("Account Type", LAnnLineGenJournalLine."Account Type"::Employee);
                            LAnnLineGenJournalLine.Validate("Account No.", employee."No.");
                            LAnnLineGenJournalLine.Validate(Description, employee.FullName());
                            LAnnLineGenJournalLine.Validate(Amount, -hlhpayroll.getAnnualLeaveAllowanceYTD(employee."No."));
                            LAnnGLPostGenJnlPostLine.RunWithCheck(LAnnLineGenJournalLine);
                        end
                        else
                            if (Format(getNetAccountType()) = 'G/L Account') then begin
                                LAnnLineGenJournalLine.Init();
                                LAnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                                LAnnLineGenJournalLine.Validate("Document Type", LAnnLineGenJournalLine."Document Type"::" ");
                                LAnnLineGenJournalLine.Validate("Document No.", 'Leave Allowance' + workDate);
                                LAnnLineGenJournalLine.Validate("Account Type", LAnnLineGenJournalLine."Account Type"::"G/L Account");
                                LAnnLineGenJournalLine.Validate("Account No.", getNetAccount());
                                LAnnLineGenJournalLine.Validate(Description, employee.FullName());
                                LAnnLineGenJournalLine.Validate(Amount, -hlhpayroll.getAnnualLeaveAllowanceYTD(employee."No."));
                                LAnnGLPostGenJnlPostLine.RunWithCheck(LAnnLineGenJournalLine);
                            end;
                        LAnnLineGenJournalLine.Reset();
                        /////// LEAVE ALLOWANCE POSTING ENDS
                    end;
                until employee.Next() = 0;
            Message(successMsg);
            hlhpayroll.setLeaveAllowancePostedStatus();
            hlhpayroll.setLeavePostingYear();
        end;
    end;

    /// <summary>
    /// postAnnual13thMonthAllowances.
    /// </summary>
    procedure postAnnual13thMonthAllowances()
    var
        employee: Record Employee;
        AnnLineGenJournalLine: Record "Gen. Journal Line";
        AnnGLPostGenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        hlhpayroll: Codeunit "HLH Payroll";
        workDate, lastPostedYear, currentMonth, month : Text;
        successMsg: Label 'Annual 13th Month Allowances details has been posted successfully', Comment = 'Success Message after posting';
        err1Lbl: Label 'Unable to Process Posting.\The Leave Allowance Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err2Lbl: Label 'Unable to Process Posting.\The 13th Month Allowance Account has not been setup in the MyPayCheq Salary Posting Setup!';
        err3Lbl: Label 'Unable to Process Posting.\The Net Account No has not been setup in the MyPayCheq Salary Posting Setup!';
        err3bLbl: Label 'Unable to Process Posting.\The Net Account Type has not been setup in the MyPayCheq Salary Posting Setup!';
        err4Lbl: Label 'Unable to Process Posting.\Annual 13th Month Allowance has been posted already for this Year!';
        err6Lbl: Label 'Unable to Process Posting.\You can only post Annual 13 Month Allowance in DECEMBER';
    begin
        lastPostedYear := Format(hlhpayroll.getLeavePostedYear()).Split('/').Get(3);
        currentMonth := FORMAT(WorkDate(), 0, '<Month Text,9>').ToUpper().Trim();
        month := 'DECEMBER';
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        if (getLeaveAllowanceAccount() = '') then
            Error(err1Lbl);
        if (get13thMonthAccount() = '') then
            Error(err2Lbl);
        if ((getNetAccount() = '') and (Format(getNetAccountType()) = 'G/L Account')) then
            Error(err3Lbl);
        if (Format(getNetAccountType()) = '') then
            Error(err3bLbl);
        if (currentMonth <> month) then
            Error(err6Lbl);
        if ((hlhpayroll.getLeaveAllowancePostedStatus() = true) and (lastPostedYear = workDate)) then
            Error(err4Lbl)
        else begin
            employee.Reset();
            employee.SetRange(Status, employee.Status::Active);
            employee.SetRange("Employment Type", employee."Employment Type"::"Full Time");
            if (employee.FindSet()) then
                repeat
                    if (hlhpayroll.getAnnual13MonthAllowanceYTD(employee."No.") > 0) then begin
                        ////////// 13MONTH POSTING BEGINS
                        AnnLineGenJournalLine.Init();
                        AnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                        AnnLineGenJournalLine.Validate("Document Type", AnnLineGenJournalLine."Document Type"::" ");
                        AnnLineGenJournalLine.Validate("Document No.", '13th Month' + workDate);
                        AnnLineGenJournalLine.Validate("Account Type", AnnLineGenJournalLine."Account Type"::"G/L Account");
                        AnnLineGenJournalLine.Validate("Account No.", get13thMonthAccount());
                        AnnLineGenJournalLine.Validate(Description, employee.FullName());
                        AnnLineGenJournalLine.Validate(Amount, hlhpayroll.getAnnual13MonthAllowanceYTD(employee."No."));
                        AnnGLPostGenJnlPostLine.RunWithCheck(AnnLineGenJournalLine);

                        if (Format(getNetAccountType()) = 'Employee') then begin
                            AnnLineGenJournalLine.Init();
                            AnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                            AnnLineGenJournalLine.Validate("Document Type", AnnLineGenJournalLine."Document Type"::" ");
                            AnnLineGenJournalLine.Validate("Document No.", '13th Month' + workDate);
                            AnnLineGenJournalLine.Validate("Account Type", AnnLineGenJournalLine."Account Type"::Employee);
                            AnnLineGenJournalLine.Validate("Account No.", employee."No.");
                            AnnLineGenJournalLine.Validate(Description, employee.FullName());
                            AnnLineGenJournalLine.Validate(Amount, -hlhpayroll.getAnnual13MonthAllowanceYTD(employee."No."));
                            AnnGLPostGenJnlPostLine.RunWithCheck(AnnLineGenJournalLine);
                        end
                        else
                            if (Format(getNetAccountType()) = 'G/L Account') then begin
                                AnnLineGenJournalLine.Init();
                                AnnLineGenJournalLine.Validate("Posting Date", WorkDate());
                                AnnLineGenJournalLine.Validate("Document Type", AnnLineGenJournalLine."Document Type"::" ");
                                AnnLineGenJournalLine.Validate("Document No.", '13th Month' + workDate);
                                AnnLineGenJournalLine.Validate("Account Type", AnnLineGenJournalLine."Account Type"::"G/L Account");
                                AnnLineGenJournalLine.Validate("Account No.", getNetAccount());
                                AnnLineGenJournalLine.Validate(Description, employee.FullName());
                                AnnLineGenJournalLine.Validate(Amount, -hlhpayroll.getAnnual13MonthAllowanceYTD(employee."No."));
                                AnnGLPostGenJnlPostLine.RunWithCheck(AnnLineGenJournalLine);
                            end;
                        AnnLineGenJournalLine.Reset();
                        /////// 13TH MONTH POSTING ENDS
                    end;
                until employee.Next() = 0;
            Message(successMsg);
            hlhpayroll.set13thMonthAllowancePostedStatus();
            hlhpayroll.set13thMonthPostingYear();
        end;
    end;

    /// <summary>
    /// adjustSalary.
    /// </summary>
    /// <param name="periodCode">Code[50].</param>
    /// <param name="empNo">Text.</param>
    /// <param name="amt">Decimal.</param>
    /// <param name="entryType">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure adjustSalary(periodCode: Code[50]; empNo: Text; amt: Decimal; entryType: Text): Boolean
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
    begin
        hlhMonthlyPayrollHeader.SetRange("Period Code", periodCode);
        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
        if (hlhMonthlyPayrollHeader.FindFirst()) then
            if (entryType = 'Positive Adjustment') then begin
                hlhMonthlyPayrollHeader.Validate(Netpay, hlhMonthlyPayrollHeader.Netpay + amt);
                hlhMonthlyPayrollHeader.Validate(Adjustment, hlhMonthlyPayrollHeader.Adjustment + amt);
                if (hlhMonthlyPayrollHeader.Modify(true)) then
                    exit(true);
            end
            else
                if (entryType = 'Negative Adjustment') then begin
                    hlhMonthlyPayrollHeader.Validate(Netpay, hlhMonthlyPayrollHeader.Netpay - amt);
                    hlhMonthlyPayrollHeader.Validate("Total Deductions", hlhMonthlyPayrollHeader."Total Deductions" + amt);
                    hlhMonthlyPayrollHeader.Validate("Other Deductions", hlhMonthlyPayrollHeader."Other Deductions" + amt);
                    if (hlhMonthlyPayrollHeader.Modify(true)) then
                        exit(true);
                end;
    end;

    /// <summary>
    /// deductLoan.
    /// </summary>
    /// <param name="periodCode">Code[50].</param>
    /// <param name="empNo">Text.</param>
    /// <param name="amt">Decimal.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure deductLoan(periodCode: Code[50]; empNo: Text; amt: Decimal): Boolean
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
    begin
        hlhMonthlyPayrollHeader.SetRange("Period Code", periodCode);
        hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
        if (hlhMonthlyPayrollHeader.FindFirst()) then begin
            hlhMonthlyPayrollHeader.Validate(Netpay, hlhMonthlyPayrollHeader.Netpay - amt);
            hlhMonthlyPayrollHeader.Validate("Total Deductions", hlhMonthlyPayrollHeader."Total Deductions" + amt);
            hlhMonthlyPayrollHeader.Validate("Loan Repayment", hlhMonthlyPayrollHeader."Loan Repayment" + amt);
            if (hlhMonthlyPayrollHeader.Modify(true)) then
                exit(true);
        end;
    end;

    /// <summary>
    /// logLoanEntry.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="empName">Text.</param>
    /// <param name="DocNo">Code[20].</param>
    /// <param name="amt">Decimal.</param>
    /// <param name="Desc">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure logLoanEntry(periodCode: Text; empName: Text; DocNo: Code[20]; amt: Decimal; Desc: Text): Boolean
    var
        hlhLoanRepaymentEntries: Record "HLH Loan Repayment Entries";
    begin
        hlhLoanRepaymentEntries.Init();
        hlhLoanRepaymentEntries.Validate("Period Code", periodCode);
        hlhLoanRepaymentEntries.Validate(Employee, empName);
        hlhLoanRepaymentEntries.Validate("Document No", DocNo);
        hlhLoanRepaymentEntries.Validate(Amount, amt);
        hlhLoanRepaymentEntries.Validate(Description, Desc);
        if (hlhLoanRepaymentEntries.Insert(true)) then
            exit(true)
        else
            exit(false);
    end;

    /// <summary>
    /// logSalaryAdjustmentEntry.
    /// </summary>
    /// <param name="periodCode">Text.</param>
    /// <param name="empName">Text.</param>
    /// <param name="DocNo">Code[20].</param>
    /// <param name="amt">Decimal.</param>
    /// <param name="Desc">Text.</param>
    /// <param name="EntryType">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure logSalaryAdjustmentEntry(periodCode: Text; empName: Text; DocNo: Code[20]; amt: Decimal; Desc: Text; EntryType: Text): Boolean
    var
        hlhSalaryAdjustmentsEntries: Record "HLH Salary Adjustments Entries";
    begin
        hlhSalaryAdjustmentsEntries.Init();
        hlhSalaryAdjustmentsEntries.Validate("Period Code", periodCode);
        hlhSalaryAdjustmentsEntries.Validate(Employee, empName);
        hlhSalaryAdjustmentsEntries.Validate("Document No", DocNo);
        hlhSalaryAdjustmentsEntries.Validate(Amount, amt);
        hlhSalaryAdjustmentsEntries.Validate(Description, Desc);
        hlhSalaryAdjustmentsEntries.Validate("Entry Type", EntryType);
        if (hlhSalaryAdjustmentsEntries.Insert(true)) then
            exit(true)
        else
            exit(false);
    end;
}