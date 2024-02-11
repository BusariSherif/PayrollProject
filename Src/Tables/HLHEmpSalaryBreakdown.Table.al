/// <summary>
/// Table HLH Emp. Salary Breakdown (ID 50002).
/// </summary>
table 50002 "HLH Emp. Salary Breakdown"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Salary Breakdown';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Emp. Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Salary Name"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Salary Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Basic","Housing","Transport","Allowances";
            OptionCaption = 'Basic,Housing,Transport,Other Allowances';
        }
    }

    keys
    {
        key(PK; ID, "Employee No.")
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