/// <summary>
/// Page HLH PostSalary (ID 50019).
/// </summary>
page 50019 "HLH Post Salary"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Post Salary';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(PeriodCode; PeriodCode)
                {
                    ApplicationArea = All;
                    TableRelation = "HLH Payroll Periods" where("Approval Status" = const(Approved), Posted = const(false));
                    ToolTip = 'Specifies the value of the Period Code field.';
                    Caption = 'Period Code';

                    trigger OnValidate()
                    begin
                        CurrPage.Payroll.Page.loadMonthlySalaryByPeriod(PeriodCode);
                    end;
                }
            }
            part("Payroll"; "HLH Monthly Payroll Header")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Monthly Salary Breakdown';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                Caption = 'Post Salary';
                ToolTip = 'Executes the Post action.';
                trigger OnAction()
                var
                    salPost: Codeunit "HLH Salary Posting";
                begin
                    salPost.PostSalary(PeriodCode);
                end;
            }
            action(PostAnnual13thMonthAllowance)
            {
                ApplicationArea = All;
                Image = PostDocument;
                Caption = 'Post Annual 13th Month Allowance';
                ToolTip = 'Executes the Post 13th Month Allowance.';
                trigger OnAction()
                var
                    salPost: Codeunit "HLH Salary Posting";
                begin
                    salPost.postAnnual13thMonthAllowances();
                end;
            }
            action(PostAnnualLeaveAllowance)
            {
                ApplicationArea = All;
                Image = PostDocument;
                Caption = 'Post Annual Leave Allowance';
                ToolTip = 'Executes the Post Annual Leave Allowance.';
                trigger OnAction()
                var
                    salPost: Codeunit "HLH Salary Posting";
                begin
                    salPost.postAnnualLeaveAllowances();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        accessControl: Record "Access Control";
        errLbl: Label 'You do not have the right permission to open this page';
    begin
        accessControl.SetRange("User Security ID", UserSecurityId());
        accessControl.SetFilter("Role ID", 'HLH Accounts Perm.');
        if (accessControl.IsEmpty) then
            Error(errLbl)
        else
            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod('NOTHING');
    end;

    var
        PeriodCode: Code[50];
}