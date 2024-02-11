/// <summary>
/// Table HLH Departments (ID 50000).
/// </summary>
table 50000 "HLH Departments"
{
    DataClassification = CustomerContent;
    Caption = 'Departments';

    fields
    {
        field(1; "Department Code"; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Department Name"; Text[200])
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
        key(PK; "Department Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ErrLbl: Label 'You must specify a value for Department Code';
    begin
        if ("Department Code" = '') then
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