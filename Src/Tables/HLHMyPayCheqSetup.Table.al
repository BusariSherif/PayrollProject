/// <summary>
/// Table HLH MyPayCheq Setup (ID 50007).
/// </summary>
table 50007 "HLH MyPayCheq Setup"
{
    DataClassification = CustomerContent;
    Caption = 'MyPayCheq Setup';

    fields
    {
        field(1; "Primary Key"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Approver ID"; Text[150])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                userSetup: Record "User";
            begin
                userSetup.SetRange("User Name", "Approver ID");
                if (userSetup.FindFirst()) then
                    "Approver Email" := userSetup."Contact Email";
            end;
        }
        field(3; "Approver Email"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Show Annual Allowances"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Payroll Account Admin."; Text[150])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                userSetup: Record "User";
            begin
                userSetup.SetRange("User Name", "Payroll Account Admin.");
                if (userSetup.FindFirst()) then
                    "Accounts Email" := userSetup."Contact Email";
            end;
        }
        field(6; "Accounts Email"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; "13th Month Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Leave Allowance Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; "13 Month Posted Year"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Leave Posted Year"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Approver 2 ID"; Text[150])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                userSetup: Record "User";
            begin
                userSetup.SetRange("User Name", "Approver 2 ID");
                if (userSetup.FindFirst()) then
                    "Approver 2 Email" := userSetup."Contact Email";
            end;
        }
        field(12; "Approver 2 Email"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(13; "PayStack API Key"; Text[1000])
        {
            DataClassification = CustomerContent;
        }
        //BEGIN >> New Requests Additions in November 2023
        field(14; "Salary Adj. Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(15; "Loan Repayment Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        //END >> New Requests Additions in November 2023
    }

    keys
    {
        key(PK; "Primary Key")
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
        Error('You can not delete this Setup.');
    end;

    trigger OnRename()
    begin

    end;

}