/// <summary>
/// Table HLH Payroll Periods (ID 50004).
/// </summary>
table 50004 "HLH Payroll Periods"
{
    DataClassification = CustomerContent;
    Caption = 'Payroll Periods';

    fields
    {
        field(1; "Period Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Start_Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "End_Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Closed"; Boolean)
        {
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(5; "No Of Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Open","Pending","Approved","Rejected";
            OptionCaption = 'Open,Pending,Approved,Rejected';
            InitValue = "Open";
        }
        field(9; "Approval Comment"; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Requester"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; "ApprovedBy"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Period Code")
        {
            Clustered = true;
        }
        key(SK; "Posting Date")
        {

        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    var
        hlhPayroll: Codeunit "HLH Payroll";
        err1Lbl: Label 'You can not modify this record because it already contains salary records!';
    // errLbl: Label 'You can not modify this record because it is either Pending or Approved.';
    begin
        // if ((hlhPayroll.getApprovalStatus(xRec."Period Code") = "Approval Status"::Pending) or
        //     (hlhPayroll.getApprovalStatus(xRec."Period Code") = "Approval Status"::Approved)) then
        //     Error(errLbl);
        if (hlhPayroll.isSalaryNotGenerated(xRec."Period Code") = true) then
            Error(err1Lbl);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    var
        hlhPayroll: Codeunit "HLH Payroll";
        errLbl: Label 'You can not rename this record because it already contains salary records!';
    begin
        if (hlhPayroll.isSalaryNotGenerated(xRec."Period Code") = true) then
            Error(errLbl);
    end;

}