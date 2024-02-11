/// <summary>
/// Table HLH Monthly Payroll Header (ID 50006).
/// </summary>
table 50006 "HLH Monthly Payroll Header"
{
    DataClassification = CustomerContent;
    Caption = 'Monthly Payroll Header';

    fields
    {
        field(1; "Period Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Total Deductions"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payee"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Total Allowances"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Netpay"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; Basic; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Pension"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Gross"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Payment Status"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Emp. Type"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Payer ID"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(14; Housing; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; Transport; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Other Allowances"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; Address; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(20; Department; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Adjustment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Leave Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "13th Month Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Loan Repayment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(25; "Other Deductions"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(26; "Other Reimbursements"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Designation"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(29; "Days Present"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(30; "Account Number"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Account Name"; Text[300])
        {
            DataClassification = CustomerContent;
        }
        field(32; "Bank Name"; Text[300])
        {
            DataClassification = CustomerContent;
        }
        field(33; "Bank Code"; Text[10])
        {
            DataClassification = CustomerContent;
        }
        field(34; "Bank Sort Code"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(35; "Pension Fund Admin."; Text[500])
        {
            DataClassification = CustomerContent;
        }
        //BEGIN >> Add New fields - November 2023
        field(36; "RSA Pin"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(37; "First Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(38; "Middle Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(39; "Last Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Private Phone No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(41; "Private Email"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        //END >> Add New fields - November 2023
    }

    keys
    {
        key(PK; "Period Code", "Employee No.")
        {
            Clustered = true;
        }
        key(SK; "Employee No.")
        {

        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}