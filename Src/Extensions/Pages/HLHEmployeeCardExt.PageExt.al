/// <summary>
/// PageExtension HLH Employee Card Ext. (ID 50001) extends Record Employee Card.
/// </summary>
pageextension 50001 "HLH Employee Card Ext." extends "Employee Card"
{
    layout
    {
        addafter("Job Title")
        {
            field(Department; Rec.Department)
            {
                ApplicationArea = All;
                LookupPageId = "HLH Departments List";
                ShowMandatory = true;
                NotBlank = true;
                ToolTip = 'Specifies the value of the Department field.';

                trigger OnValidate()
                begin
                    if (Rec.Department <> xRec.Department) then
                        Rec.Unit := '';
                end;
            }
            field(Unit; Rec.Unit)
            {
                ApplicationArea = All;
                LookupPageId = "HLH Department Units List";
                ShowMandatory = true;
                NotBlank = true;
                ToolTip = 'Specifies the value of the Unit field.';
            }
        }
        addbefore("Emplymt. Contract Code")
        {
            field("Employment Type"; Rec."Employment Type")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                NotBlank = true;
                ToolTip = 'Specifies the value of the Employment Type field.';
            }
        }
        addbefore("Social Security No.")
        {
            field("Tax Identification No."; Rec."Tax Identification No.")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                NotBlank = true;
                ToolTip = 'Specifies the value of the Tax Identification No. field.';
            }
        }
        addafter(Personal)
        {
            group("Pension Fund")
            {
                field("Pension Fund Admin."; Rec."Pension Fund Admin.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pension Fund Admin. field.';
                }
                field("PSA Pin"; Rec."RSA Pin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RSA Pin field.';
                }
            }
        }
        addafter(Payments)
        {
            group("Salary Detail")
            {
                field("Annual Gross"; Rec."Annual Gross")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Annual Gross field.';
                }
                field("Life Assurance"; Rec."Life Assurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Life Assurance field.';
                }
                field("NH Fund"; Rec."NH Fund")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NH Fund field.';
                    Visible = false;
                }
                field(NHIS; Rec.NHIS)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NHIS field.';
                    Visible = false;
                }
                field(Gratuities; Rec.Gratuities)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gratuities field.';
                    Visible = false;
                }
                field("Monthly Gross"; Rec."Monthly Gross")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the Monthly Gross field.';
                }

                field("Gross Income"; Rec."Gross Income")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the Gross Income field.';
                }
                field("Annual Netpay"; Rec."Annual Netpay")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the Annual Netpay field.';
                }
            }
        }
        addafter("Salary Detail")
        {
            group(Allowances)
            {
                field("13th Month Allowance"; Rec."13th Month Allowance")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the 13th Month Allowance field.';
                }
                field("Leave Allowance"; Rec."Leave Allowance")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the Leave Allowance field.';
                }
                field("Total Allowance"; Rec."Total Allowance")
                {
                    ApplicationArea = All;
                    Editable = False;
                    ToolTip = 'Specifies the value of the Total Allowance field.';
                }
            }

            group(Deductions)
            {
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(Pension; Rec.Pension)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Pension field.';
                }
                field("Total Annual Deduction"; Rec."Total Annual Deduction")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Annual Deduction field.';
                }
            }
        }
        addafter(Deductions)
        {
            part("Salary Breakdown"; "HLH Emp. Salary Breakdown")
            {
                ApplicationArea = All;
                SubPageLink = "Employee No." = field("No.");
            }
        }
        addafter("Bank Account No.")
        {
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = All;
                LookupPageId = "HLH Banks Setup List";
                ShowMandatory = true;
                NotBlank = true;
                ToolTip = 'Specifies the value of the Bank Name field.';
                trigger OnValidate()
                begin
                    if (Rec."Bank Name" <> xRec."Bank Name") then
                        Rec."Account Name" := '';
                end;
            }
            field("Account Name"; Rec."Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Name field.';
                Editable = false;
            }
            //BEGIN >> Add New Changes - November 2023
            field("Loan Account Type"; Rec."Loan Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Account Type field.';
            }
            field("Loan Account No"; Rec."Loan Account No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Account No field.';
            }
            field("Loan Account Name"; Rec."Loan Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Account Name field.';
            }
            //END >> Add New Changes - November 2023
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                if (Rec."Bank Account No." <> xRec."Bank Account No.") then
                    Rec."Account Name" := '';
            end;
        }
        //BEGIN >> Add New Changes - November 2023
        modify(Extension)
        {
            Caption = 'Emp. ID Card No.';
        }
        modify("Alt. Address Code")
        {
            Caption = 'Marital Status';
        }
        modify("Alt. Address Start Date")
        {
            Caption = 'First Date of Promotion';
        }
        modify("Alt. Address End Date")
        {
            Caption = 'Last Date of Promotion';
        }
        modify("Emplymt. Contract Code")
        {
            Caption = 'Recruitment Type';
        }
        modify("Statistics Group Code")
        {
            Caption = 'Emp. Grade Levels';
        }
        modify("Union Code")
        {
            Caption = 'Employee KPI';
        }
        modify("Union Membership No.")
        {
            Caption = 'Manager';
        }
        //END >> Add New fields - November 2023
    }

    actions
    {
        addfirst(Processing)
        {
            action("Calculate Salary Breakdown")
            {
                ApplicationArea = All;
                Image = CalculateSimulation;
                ToolTip = 'Executes the Calculate Salary Breakdown action.';
                trigger OnAction()
                var
                    payrollCU: Codeunit "HLH Payroll";
                begin
                    payrollCU.reCalculateSalaryDetail(Rec);
                end;
            }
            action("Validate Bank Account")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Validate Bank Account action.';
                Image = BankAccountRec;
                trigger OnAction()
                var
                    getBank: Record "HLH Banks Setup";
                    getAccName: Codeunit "HLH MyPayCheq Mgt.";
                    BankCode: Text[300];
                begin
                    getBank.SetRange("Bank Name", Rec."Bank Name");
                    if getBank.FindFirst() then begin
                        BankCode := getBank."Bank Code";
                        Rec."Account Name" := CopyStr(getAccName.getAccountName(Rec."Bank Account No.", BankCode), 1, MaxStrLen(Rec."Account Name"));
                    end
                    else begin
                        BankCode := '';
                        Rec."Account Name" := '';
                    end;

                end;
            }
        }
    }
}