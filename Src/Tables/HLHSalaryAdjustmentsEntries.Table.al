/// <summary>
/// Table HLH Salary Adjustments Entries (ID 50013).
/// </summary>
table 50013 "HLH Salary Adjustments Entries"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Adjustments Entries';

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
        field(7; "Entry Type"; Text[50])
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