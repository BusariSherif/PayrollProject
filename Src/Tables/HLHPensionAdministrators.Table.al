/// <summary>
/// Table HLH Pension Administrator (ID 50001).
/// </summary>
table 50001 "HLH Pension Administrators"
{
    DataClassification = CustomerContent;
    Caption = 'Pension Administrators';

    fields
    {
        field(1; "PFA Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "PFA Name"; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[500])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "PFA Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ErrLbl: Label 'You must specify a value for PFA Code';
    begin
        if ("PFA Code" = '') then
            Error(ErrLbl);
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