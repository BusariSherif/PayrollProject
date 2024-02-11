/// <summary>
/// Table HLH Loan Entries (ID 50012).
/// </summary>
table 50012 "HLH Loan Repayment Entries"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Repayment Entries';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Document No"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Period Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; Employee; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[350])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; ID)
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