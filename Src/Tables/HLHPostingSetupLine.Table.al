/// <summary>
/// Table HLH Posting Setup (ID 50008).
/// </summary>
table 50008 "HLH Posting Setup Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(2; "Salary Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Net","Payee","Pension","W/H Tax","Postive/Negative Adj.","Leave Allowance","13th Month";
        }
        field(3; "Posting Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Balancing Account";
            InitValue = "Balancing Account";
            Editable = false;
        }
        field(4; "Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "G/L Account","Employee";
            trigger OnValidate()
            var
                ErrorLbl: Label 'You can only have the combinations of Net-Employee and NOT %1-%2', comment = '%1=Salary Type and %2=Account TYpe';
            begin
                if ("Account Type" = "Account Type"::Employee) then begin
                    "Account Name" := '';
                    "Account No." := '';
                end;
                if (("Salary Type" <> "Salary Type"::Net) and ("Account Type" = "Account Type"::Employee)) then
                    Error(ErrorLbl, "Salary Type", "Account Type");
            end;
        }
        field(5; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No." where(Blocked = const(false), "Direct Posting" = const(true));

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    GLAccount.GET("Account No.");
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
        key(PK; "Salary Type")
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