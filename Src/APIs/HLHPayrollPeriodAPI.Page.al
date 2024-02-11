/// <summary>
/// Page HLH Payroll Period API (ID 50016).
/// </summary>
page 50016 "HLH Payroll Period API"
{
    PageType = API;
    Caption = 'monthlyPayrollPeriod';
    APIPublisher = 'havis360';
    APIGroup = 'myPayCheqPayrollPeriod';
    APIVersion = 'v1.0';
    EntityName = 'payrollPeriodEntity';
    EntitySetName = 'payrollPeriodSet';
    SourceTable = "HLH Payroll Periods";
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater("Payroll Period API")
            {

                field(periodCode; Rec."Period Code")
                {
                    Caption = 'Period Code';
                    Editable = false;
                }
                field(startDate; Rec.Start_Date)
                {
                    Caption = 'Start_Date';
                    Editable = false;
                }
                field(endDate; Rec.End_Date)
                {
                    Caption = 'End_Date';
                    Editable = false;
                }
                field(closed; Rec.Closed)
                {
                    Caption = 'Closed';
                    Editable = false;
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    Editable = false;
                }
                field(noOfDays; Rec."No Of Days")
                {
                    Caption = 'No Of Days';
                    Editable = false;
                }
                field(posted; Rec.Posted)
                {
                    Caption = 'Posted';
                    Editable = false;
                }
                field("paymentDate"; Rec."Posting Date")
                {
                    Caption = 'Payment Date';
                    Editable = false;
                }
            }
        }
    }
}