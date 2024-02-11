/// <summary>
/// Table HLH Monthly Payroll Line (ID 50005).
/// </summary>
table 50005 "HLH Monthly Payroll Line"
{
    DataClassification = CustomerContent;
    Caption = 'Monthly Payroll Line';

    fields
    {
        field(1; "Payroll Period"; Code[50])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Employee No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Salary Type"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Salary Desc."; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Salary Category"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Payroll Period", "Employee No.", "Salary Type")
        {
            Clustered = true;
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