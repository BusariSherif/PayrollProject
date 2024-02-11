/// <summary>
/// Table HLH Department Units (ID 50011).
/// </summary>
table 50011 "HLH Department Units"
{
    DataClassification = CustomerContent;
    Caption = 'Department Units Table';

    fields
    {
        field(1; "Unit Name"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Department Code"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "HLH Departments"."Department Code";
        }
    }

    keys
    {
        key(PK; "Department Code", "Unit Name")
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