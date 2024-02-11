/// <summary>
/// Table HLH Bank (ID 50010).
/// </summary>
table 50010 "HLH Banks Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Bank List';

    fields
    {

        field(1; "Bank Name"; Code[300])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Bank Code"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Long Bank Code"; Text[300])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Sort Code"; Text[300])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bank Name")
        {
            Clustered = true;
        }
        key(SK; "Sort Code", "Bank Code")
        {

        }
    }

    trigger OnInsert()
    var
        ErrLbl: Label 'You must specify a value for Bank Name';
    begin
        if ("Bank Name" = '') then
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