/// <summary>
/// Page HLHHRRoleCenterCues (ID 50023).
/// </summary>
page 50023 HLHHRRoleCenterCues
{
    PageType = CardPart;
    UsageCategory = Administration;
    RefreshOnActivate = true;
    Caption = 'Payroll Periods Statistics';

    layout
    {
        area(Content)
        {
            cuegroup(PeriodStatus)
            {
                Caption = 'Payroll Status';
                field("Open"; openPeriods())
                {
                    Caption = 'Open Periods';
                    ToolTip = 'This displays the total number Payroll Periods that are Open';
                    ApplicationArea = All;
                    Style = Ambiguous;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange(Closed, false);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
                field("Closed"; closedPeriods())
                {
                    Caption = 'Closed Periods';
                    ToolTip = 'This displays the total number Payroll Periods that are Closed';
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange(Closed, true);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
            }
            cuegroup(PeriodApproval)
            {
                Caption = 'Approvals';
                field("OpenApprovals"; openApproval())
                {
                    Caption = 'Open';
                    ToolTip = 'This displays the total number of Payroll Periods that have Open Approvals';
                    ApplicationArea = All;
                    Style = AttentionAccent;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Open);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
                field("Pending"; pendingApproval())
                {
                    Caption = 'Pending Approval';
                    ToolTip = 'This displays the total number of Payroll Periods that are Pending Approvals';
                    ApplicationArea = All;
                    Style = Subordinate;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Pending);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
                field("Rejected"; rejectedApproval())
                {
                    Caption = 'Rejected Approval';
                    ToolTip = 'This displays the total number of Payroll Periods that have been Rejected';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Rejected);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
                field("Approved"; approvedApproval())
                {
                    Caption = 'Approved';
                    ToolTip = 'This displays the total number of Payroll Periods that have been Approved';
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                    begin
                        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Approved);
                        Page.Run(50007, hlhPayrollPeriods);
                    end;
                }
            }

            cuegroup(PaymentStatistics)
            {
                Caption = 'Payment Statistics';
                field("totalLastPaidAmt"; totalLastPaid())
                {
                    Caption = 'Total Last Payment';
                    ToolTip = 'This displays the total amount paid for the last Salary Period';
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = true;
                    AutoFormatExpression = GetAmountFormat();
                    AutoFormatType = 11;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
                    begin
                        hlhPayrollPeriods.SetRange(Posted, true);
                        hlhPayrollPeriods.SetCurrentKey(End_Date);
                        hlhPayrollPeriods.SetAscending(End_Date, true);
                        if (hlhPayrollPeriods.FindLast()) then begin
                            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                            Page.Run(50008, hlhMonthlyPayrollHeader);
                        end;
                    end;
                }
                field("totalLastPaidAmtFullTime"; totalLastPaidPermanentStaff())
                {
                    Caption = 'Last Payment - Permanent-Staff';
                    ToolTip = 'This displays the total amount paid for the last Salary Period for Permanent Staff';
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = true;
                    AutoFormatExpression = GetAmountFormat();
                    AutoFormatType = 11;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
                    begin
                        hlhPayrollPeriods.SetRange(Posted, true);
                        hlhPayrollPeriods.SetCurrentKey(End_Date);
                        hlhPayrollPeriods.SetAscending(End_Date, true);
                        if (hlhPayrollPeriods.FindLast()) then begin
                            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                            hlhMonthlyPayrollHeader.SetRange("Emp. Type", 'Full Time');
                            Page.Run(50008, hlhMonthlyPayrollHeader);
                        end;
                    end;
                }
                field("totalLastPaidAmtContract"; totalLastPaidContractStaff())
                {
                    Caption = 'Last Payment - Contract-Staff';
                    ToolTip = 'This displays the total amount paid for the last Salary Period for Contract Staff';
                    ApplicationArea = All;
                    Style = Favorable;
                    AutoFormatExpression = GetAmountFormat();
                    AutoFormatType = 11;
                    StyleExpr = true;
                    trigger OnDrillDown()
                    var
                        "hlhPayrollPeriods": Record "HLH Payroll Periods";
                        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
                    begin
                        hlhPayrollPeriods.SetRange(Posted, true);
                        hlhPayrollPeriods.SetCurrentKey(End_Date);
                        hlhPayrollPeriods.SetAscending(End_Date, true);
                        if (hlhPayrollPeriods.FindLast()) then begin
                            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
                            hlhMonthlyPayrollHeader.SetRange("Emp. Type", 'Contract');
                            Page.Run(50008, hlhMonthlyPayrollHeader);
                        end;
                    end;
                }
            }
        }
    }

    /// <summary>
    /// openPeriods.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure openPeriods(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange(Closed, false);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// closedPeriods.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure closedPeriods(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange(Closed, true);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// pendingApproval.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure pendingApproval(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Pending);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// rejectedApproval.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure rejectedApproval(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Rejected);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// openApproval.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure openApproval(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Open);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// approvedApproval.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure approvedApproval(): Integer
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        counter: Integer;
    begin
        hlhPayrollPeriods.SetRange("Approval Status", hlhPayrollPeriods."Approval Status"::Approved);
        counter := 0;
        if (hlhPayrollPeriods.FindSet()) then
            repeat
                counter := counter + 1;
            until hlhPayrollPeriods.Next() = 0;
        exit(counter);
    end;

    /// <summary>
    /// totalLastPaid.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure totalLastPaid(): Decimal
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        totalAmt: Decimal;
    begin
        hlhPayrollPeriods.SetRange(Posted, true);
        hlhPayrollPeriods.SetCurrentKey("Posting Date");
        hlhPayrollPeriods.SetAscending("Posting Date", true);
        if (hlhPayrollPeriods.FindLast()) then begin
            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
            if (hlhMonthlyPayrollHeader.FindSet()) then
                repeat
                    totalAmt := totalAmt + hlhMonthlyPayrollHeader.Netpay;
                until hlhMonthlyPayrollHeader.Next() = 0;
            exit(totalAmt);
        end;
    end;

    /// <summary>
    /// totalLastPaidPermanentStaff.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure totalLastPaidPermanentStaff(): Decimal
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        totalAmt: Decimal;
    begin
        hlhPayrollPeriods.SetRange(Posted, true);
        hlhPayrollPeriods.SetCurrentKey("Posting Date");
        hlhPayrollPeriods.SetAscending("Posting Date", true);
        if (hlhPayrollPeriods.FindLast()) then begin
            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
            hlhMonthlyPayrollHeader.SetRange("Emp. Type", 'Full Time');
            if (hlhMonthlyPayrollHeader.FindSet()) then
                repeat
                    totalAmt := totalAmt + hlhMonthlyPayrollHeader.Netpay;
                until hlhMonthlyPayrollHeader.Next() = 0;
            exit(totalAmt);
        end;
    end;

    /// <summary>
    /// totalLastPaidContractStaff.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    procedure totalLastPaidContractStaff(): Decimal
    var
        hlhPayrollPeriods: Record "HLH Payroll Periods";
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        totalAmt: Decimal;
    begin
        hlhPayrollPeriods.SetRange(Posted, true);
        hlhPayrollPeriods.SetCurrentKey("Posting Date");
        hlhPayrollPeriods.SetAscending("Posting Date", true);
        if (hlhPayrollPeriods.FindLast()) then begin
            hlhMonthlyPayrollHeader.SetRange("Period Code", hlhPayrollPeriods."Period Code");
            hlhMonthlyPayrollHeader.SetRange("Emp. Type", 'Contract');
            if (hlhMonthlyPayrollHeader.FindSet()) then
                repeat
                    totalAmt := totalAmt + hlhMonthlyPayrollHeader.Netpay;
                until hlhMonthlyPayrollHeader.Next() = 0;
            exit(totalAmt);
        end;
    end;

    /// <summary>
    /// GetAmountFormat.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetAmountFormat(): Text
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        UserPersonalization: Record "User Personalization";
        CurrencySymbol: Text[10];
    begin
        GeneralLedgerSetup.Get();
        CurrencySymbol := GeneralLedgerSetup.GetCurrencySymbol();

        if UserPersonalization.Get(UserSecurityId()) and (CurrencySymbol <> '') then
            case UserPersonalization."Locale ID" of
                1030, // da-DK
              1053, // sv-Se
              1044: // no-no
                    exit('<Precision,0:0><Standard Format,0>' + CurrencySymbol);
                2057, // en-gb
              1033, // en-us
              4108, // fr-ch
              1031, // de-de
              2055, // de-ch
              1040, // it-it
              2064, // it-ch
              1043, // nl-nl
              2067, // nl-be
              2060, // fr-be
              3079, // de-at
              1035, // fi
              1034: // es-es
                    exit(CurrencySymbol + '<Precision,0:0><Standard Format,0>');
            end;

        exit(GetDefaultAmountFormat());
    end;

    local procedure GetDefaultAmountFormat(): Text
    begin
        exit('<Precision,0:0><Standard Format,0>');
    end;

}