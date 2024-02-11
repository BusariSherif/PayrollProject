/// <summary>
/// Table HLH Salary Posting Setup (ID 50009).
/// </summary>
table 50009 "HLH Salary Posting Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Salary Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Gross";
            InitValue = "Gross";
        }
        field(3; "Posting Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Debit Account";
            InitValue = "Debit Account";
            Editable = false;
        }
        field(4; "Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "G/L Account","Employee";
            trigger OnValidate()
            begin
                if ("Account Type" = "Account Type"::Employee) then begin
                    "Account Name" := '';
                    "Account No" := '';
                end;
            end;
        }
        field(5; "Account No"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = CONST(false), "Direct Posting" = const(true));

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                    GLAccount.GET("Account No");
                    "Account Name" := GLAccount.Name;
                end;
            end;
        }
        field(6; "Account Name"; Text[500])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        GLAccount: Record "G/L Account";

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