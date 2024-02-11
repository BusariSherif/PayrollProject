/// <summary>
/// Report HLH Payslip (ID 50000).
/// </summary>
report 50000 "HLH Payslip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Payslip';
    DefaultRenderingLayout = LayoutName;
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Monthly Payroll"; "HLH Monthly Payroll Header")
        {
            RequestFilterFields = "Period Code", "Employee No.";
            PrintOnlyIfDetail = true;
            column(Period_Code; "Period Code")
            {

            }
            column(Employee_No_; "Employee No.")
            {

            }
            column(Employee_Name; "Employee Name")
            {

            }
            column("EmploymentType"; "Emp. Type")
            {

            }
            column(Gross; Gross)
            {

            }
            column(Basic; Basic)
            {

            }
            column(Payee; Payee)
            {

            }
            column(Pension; Pension)
            {

            }
            column(Total_Allowances; "Total Allowances")
            {

            }
            column(Total_Deductions; "Total Deductions")
            {

            }
            column(Netpay; Netpay)
            {

            }
            column(AmountInWords; AmountInWords)
            {

            }
            column(noOfWorkingDays; noOfWorkingDays)
            {

            }
            column(showAnnualAllowances; showAnnualAllowances)
            {

            }
            column(empDepartment; empDepartment)
            {

            }
            column(empJobTitle; empJobTitle)
            {

            }
            column(empDateOfEmployment; empDateOfEmployment)
            {

            }
            column(Leave_Allowance; "Leave Allowance")
            {

            }
            column("Thirteenth_Month_Allowance"; "13th Month Allowance")
            {

            }
            column(Adjustment; Adjustment)
            {

            }
            column(Loan_Repayment; "Loan Repayment")
            {

            }
            column(Other_Reimbursements; "Other Reimbursements")
            {

            }
            column(Other_Deductions; "Other Deductions")
            {

            }
            column(payeeYTD; payeeYTD)
            {

            }
            column(pensionYTD; pensionYTD)
            {

            }
            column(adjustmentYTD; adjustmentYTD)
            {

            }
            column(leaveAllowanceYTD; leaveAllowanceYTD)
            {

            }
            column(thirtMnthAllowanceYTD; thirtMnthAllowanceYTD)
            {

            }
            column(loanYTD; loanYTD)
            {

            }
            column(otherDeductionYTD; otherDeductionYTD)
            {

            }
            column(otherReimbursementYTD; otherReimbursementYTD)
            {

            }
            column(Payment_Date; paymentDate)
            {

            }
            column(SalaryMonth; endDate)
            {

            }
            dataitem("Monthly Payroll Line"; "HLH Monthly Payroll Line")
            {
                DataItemLinkReference = "Monthly Payroll";
                DataItemLink = "Payroll Period" = field("Period Code"), "Employee No." = field("Employee No.");
                column(Line_Payroll_Period; "Payroll Period")
                {

                }
                column(Line_Employee_No; "Employee No.")
                {

                }
                column(Salary_Category; "Salary Category")
                {

                }
                column(Salary_Desc_; "Salary Desc.")
                {

                }
                column(Salary_Type; "Salary Type")
                {

                }
                column(Amount; Amount)
                {

                }
                column(toPrint; toPrint)
                {

                }
                dataitem("Company Information"; "Company Information")
                {
                    DataItemTableView = sorting("Primary Key");
                    column(Name; Name)
                    {

                    }
                    column(Address; Address)
                    {

                    }
                    column(Address_2; "Address 2")
                    {

                    }
                    column(City; City)
                    {

                    }
                    column(Post_Code; "Post Code")
                    {

                    }
                    column(Country_Region_Code; "Country/Region Code")
                    {

                    }
                    column(Phone_No_; "Phone No.")
                    {

                    }
                    column(E_Mail; "E-Mail")
                    {

                    }
                    column(Picture; Picture)
                    {

                    }
                }
                trigger OnAfterGetRecord()
                begin
                    getYTD("Payroll Period", "Employee No.", "Salary Type");
                end;
            }
            trigger OnAfterGetRecord()
            var
                // RepCheck: Report Check;
                getShowAnnAllowance: Codeunit "HLH Payroll";
                // Amt: Decimal;
                NoText: array[2] of Text[80];
                NoText2: array[2] of Text[80];
                DeciNum: List of [Text];
                Fract: List of [Text];
            // Kobo: Decimal;
            // currencyNaira: Code[10];
            // currencyKobo: Code[10];
            begin
                // Commented out Amt in Words logic to allow Github CICD to run successfully
                // To be unncommented with the above variables before publishing to BC environment 
                getPayeeYTD("Period Code", "Employee No.");
                // Amt := Round(Netpay + leaveAllowanceYTD + thirtMnthAllowanceYTD, 0.01);
                // currencyNaira := 'NGN';
                // currencyKobo := 'KOBO';
                // RepCheck.InitTextVariable();
                // RepCheck.FormatNoText(NoText, Amt, currencyNaira);
                DeciNum := NoText[1].Split(' AND ');
                // Evaluate(Kobo, (DeciNum.Get(2).Split('/').Get(1)));
                // RepCheck.FormatNoText(NoText2, Kobo, currencyKobo);
                Fract := NoText2[1].Split(' AND ');
                AmountInWords := DeciNum.Get(1) + ' NAIRA AND ' + Fract.Get(1).Split('****').Get(2) + ' KOBO Only';

                getNoOfWorkingDays("Period Code");  //Get number of working days is this payroll period
                getEmpDetail("Employee No."); //Get employee details
                getPaymentDate("Period Code"); //Get payment date
                getEndDate("Period Code"); //Get end Date to be used for Salary Month
                // getPayeeYTD("Period Code", "Employee No.");
                if (getShowAnnAllowance.showAnnuallAllowanceStatus() = false) then begin
                    "13th Month Allowance" := 0;
                    "Leave Allowance" := 0;
                end;
            end;
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Src/Reports/Payslip.rdl';
        }
    }

    /// <summary>
    /// getNoOfWorkingDays.
    /// </summary>
    /// <param name="perCode">Text.</param>
    /// <returns>Return variable workingDays of type Integer.</returns>
    procedure getNoOfWorkingDays(perCode: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", perCode);
        If (hlhPayrollPeriods.FindFirst()) then
            noOfWorkingDays := hlhPayrollPeriods."No Of Days";
    end;

    /// <summary>
    /// getEndDate.
    /// </summary>
    /// <param name="perCode">Text.</param>
    procedure getEndDate(perCode: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", perCode);
        if (hlhPayrollPeriods.FindFirst()) then
            endDate := hlhPayrollPeriods.End_Date;
    end;

    /// <summary>
    /// getPaymentDate.
    /// </summary>
    /// <param name="perCode">Text.</param>
    procedure getPaymentDate(perCode: Text)
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
    begin
        hlhPayrollPeriods.SetRange("Period Code", perCode);
        if (hlhPayrollPeriods.FindFirst()) then
            paymentDate := hlhPayrollPeriods."Posting Date";
    end;

    /// <summary>
    /// showAnnuallAllowanceStatus.
    /// </summary>
    procedure showAnnuallAllowanceStatus()
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
    begin
        if (hlhMyPayCheqSetup.FindFirst()) then
            showAnnualAllowances := hlhMyPayCheqSetup."Show Annual Allowances";
    end;

    /// <summary>
    /// getEmpDetail.
    /// </summary>
    /// <param name="empNoVar">Code[200].</param>
    procedure getEmpDetail(empNoVar: Code[200])
    var
        employee: Record Employee;
    begin
        employee.SetRange("No.", empNoVar);
        if (employee.FindFirst()) then begin
            empDepartment := employee.Department;
            empJobTitle := employee."Job Title";
            empDateOfEmployment := employee."Employment Date";
        end;
    end;

    /// <summary>
    /// getYTD.
    /// </summary>
    /// <param name="perCode">code[200].</param>
    /// <param name="empNoVar">Code[200].</param>
    /// <param name="salaryItem">Text.</param>

    // Method to get Year Till Date for Earnings
    procedure getYTD(perCode: code[200]; empNoVar: Code[200]; salaryItem: Text)
    var
        hlhMonthlyPayrollLine: Record "HLH Monthly Payroll Line";
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        workDate: Text;
        temp: Decimal;
    begin
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        hlhPayrollPeriods.SetRange(Posted, true);
        hlhPayrollPeriods.SetRange(Closed, true);
        if (hlhPayrollPeriods.FindSet()) then begin
            repeat
                if (Format(hlhPayrollPeriods."Start_Date").EndsWith(workDate)) then begin
                    hlhMonthlyPayrollLine.SetRange("Payroll Period", hlhPayrollPeriods."Period Code");
                    hlhMonthlyPayrollLine.SetRange("Employee No.", empNoVar);
                    hlhMonthlyPayrollLine.SetRange("Salary Type", salaryItem);
#pragma warning disable AA0005
                    if (hlhMonthlyPayrollLine.FindSet()) then begin
                        repeat
                            temp := temp + hlhMonthlyPayrollLine.Amount;
                        until hlhMonthlyPayrollLine.Next() = 0;
                    end;
#pragma warning restore AA0005
                end;
            until hlhPayrollPeriods.Next() = 0;
            toPrint := temp;
            temp := 0;
        end;
    end;

    /// <summary>
    /// payeeYTD.
    /// </summary>
    /// <param name="perCode">code[200].</param>
    /// <param name="empNoVar">Code[200].</param>
    procedure getPayeeYTD(perCode: code[200]; empNoVar: Code[200])
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        workDate: Text;
        tempPayee, tempPension, tempAdj, tempLeaveAllowance, temp13thMonth, tempLoan, tempOtherDed, tempOtherReimb : Decimal;
    begin
        workDate := Format(System.WorkDate()).Split('/').Get(3);
        hlhPayrollPeriods.SetRange(Posted, true);
        hlhPayrollPeriods.SetRange(Closed, true);
        if (hlhPayrollPeriods.FindSet()) then begin
            repeat
                if (Format(hlhPayrollPeriods."Start_Date").EndsWith(workDate)) then begin
                    hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                    hlhMonthlyPayrollHeader.SetRange("Employee No.", empNoVar);
                    // monthlyPayrollHdr.SetRange("Emp. Type",'Full Time');
#pragma warning disable AA0005
                    if (hlhMonthlyPayrollHeader.FindSet()) then begin
                        repeat
                            showAnnuallAllowanceStatus();
                            tempPayee := tempPayee + hlhMonthlyPayrollHeader.Payee;
                            tempPension := tempPension + hlhMonthlyPayrollHeader.Pension;
                            tempAdj := tempAdj + hlhMonthlyPayrollHeader.Adjustment;

                            if (showAnnualAllowances = true) then begin
                                temp13thMonth := temp13thMonth + hlhMonthlyPayrollHeader."13th Month Allowance";
                                tempLeaveAllowance := tempLeaveAllowance + hlhMonthlyPayrollHeader."Leave Allowance";
                            end;
                            tempLoan := tempLoan + hlhMonthlyPayrollHeader."Loan Repayment";
                            tempOtherDed := tempOtherDed + hlhMonthlyPayrollHeader."Other Deductions";
                            tempOtherReimb := tempOtherReimb + hlhMonthlyPayrollHeader."Other Reimbursements";
                        until hlhMonthlyPayrollHeader.Next() = 0;
                    end;
#pragma warning restore AA0005
                end;
            until hlhPayrollPeriods.Next() = 0;
            payeeYTD := tempPayee;
            pensionYTD := tempPension;
            adjustmentYTD := tempAdj;
            leaveAllowanceYTD := tempLeaveAllowance;
            thirtMnthAllowanceYTD := temp13thMonth;
            otherDeductionYTD := tempOtherDed;
            otherReimbursementYTD := tempOtherReimb;
            loanYTD := tempLoan;
            tempPayee := 0;
            tempPension := 0;
            tempAdj := 0;
            tempLeaveAllowance := 0;
            temp13thMonth := 0;
            tempLoan := 0;
            tempOtherDed := 0;
            tempOtherReimb := 0;
        end;
    end;

    var
        AmountInWords: Text;
        noOfWorkingDays: Integer;
        showAnnualAllowances: Boolean;
        empDepartment: Text;
        empJobTitle: Text;
        empDateOfEmployment, paymentDate, endDate : Date;
        toPrint: Decimal;
        payeeYTD, pensionYTD, adjustmentYTD, leaveAllowanceYTD, thirtMnthAllowanceYTD, loanYTD, otherDeductionYTD, otherReimbursementYTD : Decimal;
}