/// <summary>
/// TableExtension HLH Employee Table Ext. (ID 50000) extends Record Employee.
/// </summary>
tableextension 50000 "HLH Employee Table Ext." extends Employee
{
    fields
    {
        field(50001; "Annual Gross"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Monthly Gross"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Gross Income"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50004; "13th Month Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50005; "Leave Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Tax Identification No."; Code[150])
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Pension Fund Admin."; Text[500])
        {
            DataClassification = CustomerContent;
            TableRelation = "HLH Pension Administrators";
        }
        field(50008; "RSA Pin"; Code[150])
        {
            DataClassification = CustomerContent;
        }
        field(50009; "Employment Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Full Time","Contract";
        }
        field(50010; "Department"; Text[150])
        {
            DataClassification = CustomerContent;
            TableRelation = "HLH Departments";
        }
        field(50011; "Annual Basic"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Total Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Total Annual Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50014; "Annual Netpay"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50015; "Payee"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Pension"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Annual Transport"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Annual Housing"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Actual Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50020; "Annual Tax Payable"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50021; "Minimum Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50022; "Computed Annual Tax"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50023; "Taxable Income"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50024; "NH Fund"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50025; "NHIS"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50026; "Gratuities"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "Life Assurance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50028; "Consolidated Relief Allowance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50029; "Bank Name"; Code[300])
        {
            DataClassification = CustomerContent;
            TableRelation = "HLH Banks Setup";
        }
        field(50030; "Account Name"; Text[300])
        {
            DataClassification = CustomerContent;
        }
        field(50031; "Unit"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "HLH Department Units"."Unit Name" where("Department Code" = field(Department));
        }
        //BEGIN >> Add New Changes - November 2023
        field(50032; "Loan Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "G/L Account";
        }
        field(50033; "Loan Account No"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Direct Posting" = const(true));
            trigger OnValidate()
            begin
                if "Loan Account Type" = "Loan Account Type"::"G/L Account" then begin
                    GLAccount.GET("Loan Account No");
                    "Loan Account Name" := GLAccount.Name;
                end
            end;
        }
        field(50034; "Loan Account Name"; Text[500])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    var
        GLAccount: Record "G/L Account";
    //BEGIN >> Add New Changes - November 2023
}