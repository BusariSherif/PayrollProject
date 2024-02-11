/// <summary>
/// Table HLH Salary Structure (ID 50003).
/// </summary>
table 50003 "HLH Salary Structure"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Structure';

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; Name; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[300])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Use For Payroll"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(5; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Basic","Housing","Transport","Allowances";
            OptionCaption = 'Basic,Housing,Transport,Other Allowances';
        }
    }

    keys
    {
        key(PK; ID, Name)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        hlhPayroll: Codeunit "HLH Payroll";
        TotalPercentage: Decimal;
        CurrTotPercentage: Decimal;
        ErrLbl: Label 'Total Percentage of Earnings can not be greater than 100.';
    begin
        TotalPercentage := hlhPayroll.calcPercentage();
        CurrTotPercentage := TotalPercentage + Percentage;
        /// Making sure that user can not exceed salary breakdown of 100% Total for Basic and Allowances
        If (CurrTotPercentage > 100.0) then
            Error(ErrLbl);
    end;

    trigger OnModify()
    var
        hlhPayroll: Codeunit "HLH Payroll";
        TotalPercentage: Decimal;
        CurrTotPercentage: Decimal;
        ErrLbl: Label 'Total Percentage of Earnings can not be greater than 100.';
    begin
        TotalPercentage := hlhPayroll.calcPercentage();
        CurrTotPercentage := TotalPercentage + Percentage;
        /// Making sure that user can not exceed salary breakdown of 100% Total for Basic and Allowances
        If ((CurrTotPercentage - xRec.Percentage) > 100.0) then
            Error(ErrLbl);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}