/// <summary>
/// Page Salary Approval (ID 50013).
/// </summary>
page 50013 "HLH Salary Approval"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Salary Approval';

    layout
    {
        area(Content)
        {
            group("Salary Approval")
            {
                field("Period Code"; "Period Code")
                {
                    ApplicationArea = All;
                    Caption = 'Period Code';
                    TableRelation = "HLH Payroll Periods" where(Closed = const(false));
                    ToolTip = 'Specifies the value of the Period Code field.';
                    trigger OnValidate()
                    var
                        hlhPayrollPeriods: Record "HLH Payroll Periods";
                        apprvlStatusCU: Codeunit "HLH Payroll";
                        Err: Label 'Payroll Period field must not be empty!';
                        apprvlStatus: Option "Open","Pending","Approved","Rejected";
                    begin
                        if (("Period Code" <> '')) then begin
                            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod("Period Code");
                            hlhPayrollPeriods.SetRange("Period Code", "Period Code");
                            If (hlhPayrollPeriods.FindFirst()) then begin
                                Comment := hlhPayrollPeriods."Approval Comment";
                                ApprovalStatus := hlhPayrollPeriods."Approval Status";
                            end;
                        end
                        else
                            Error(Err);
                        apprvlStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                        if (Format(apprvlStatus) = 'Approved') then
                            commentEditable := false
                        else
                            commentEditable := true;
                    end;
                }
                field(Employee; Employee)
                {
                    ApplicationArea = All;
                    Caption = 'Employee';
                    ToolTip = 'Specifies the value of the Employee field.';
                    TableRelation = Employee where(Status = const(Active));

                    trigger OnValidate()
                    var
                        Err: Label 'Payroll Period field must not be empty!';
                    begin
                        if (("Period Code" <> '')) then
                            CurrPage.Payroll.Page.loadMonthlyFullTimeSalary("Period Code", Employee)
                        else
                            Error(Err);
                    end;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    Visible = commentVisible;
                    Editable = commentEditable;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Approval Status"; ApprovalStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Approval Status';
                    OptionCaption = 'Open,Pending,Approved,Rejected';
                    ToolTip = 'Specifies the value of the ApprovalStatus field.';
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
            action("Request Approval")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                ToolTip = 'Executes the Request Approval action.';
                trigger OnAction()
                var
                    apprvlStatusCU: Codeunit "HLH Payroll";
                    apprvlStatus: Option "Open","Pending","Approved","Rejected";
                    approverMail, approver2Mail, messageBody : Text;
                    approvalPageURL, month, year, monthYear : Text;
                    ErrLbl: Label 'The Payroll Period associated with this Salary is not Open!';
                    Err1Lbl: Label 'Unable to send Approval Request Mail! Please check the setup or internet connection.';
                    MsgLbl: Label 'Approval Request has been sent to Approver.';
                    Err3Lbl: Label 'Approver Email Address can not be found! \Please set an email address for the request.';
                    subjectLbl: Label 'Salary Approval Request';
                begin
                    approverMail := apprvlStatusCU.getApproverEmail();
                    approver2Mail := apprvlStatusCU.getApprover2Email();
                    year := Format(Date2DMY(apprvlStatusCU.getEndDate("Period Code"), 3));
                    month := FORMAT(apprvlStatusCU.getEndDate("Period Code"), 0, '<Month Text,9>').ToUpper();
                    monthYear := month + ' ' + year;
                    approvalPageURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, 50013);
                    messageBody := 'Dear MD,<br><br>Payslip schedule for the month of <Strong>' + monthYear + '</Strong>, (Period Code: ' + "Period Code" + ') has been submitted for your review. <br><br>Kindly click <a href="' + approvalPageURL + '">here</a> to approve or decline the request.<br>' +
                    '<h4>Regards,<br><strong>HR</strong></h4>';
                    apprvlStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                    if (Format(apprvlStatus) = 'Open') then begin

                        if (approverMail = '') then
                            Error(Err3Lbl);
                        if (apprvlStatusCU.sendMail(approverMail, messageBody, subjectLbl)) then begin
                            if (approver2Mail <> '') then
                                apprvlStatusCU.sendMail(approver2Mail, messageBody, subjectLbl);
                            apprvlStatusCU.setSalaryApprovalStatus("Period Code", Comment, apprvlStatus::Pending);
                            ApprovalStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                            apprvlStatusCU.setRequester("Period Code", UserId);
                            Message(MsgLbl);
                        end
                        else
                            Error(Err1Lbl);
                    end
                    else
                        Error(ErrLbl);
                end;
            }
            action("Approve")
            {
                ApplicationArea = All;
                Visible = approveVisible;
                Image = Approve;
                ToolTip = 'Executes the Approve action.';
                trigger OnAction()
                var
                    access: Record "Access Control";
                    apprvlStatusCU: Codeunit "HLH Payroll";
                    approverID, approver2ID, requester, requesterEmail, messageBody, accountsMessageBody, subject, accountsMail, month, year, monthYear : Text;
                    apprvlStatus: Option "Open","Pending","Approved","Rejected";
                    ErrLbl: Label 'You do not have the right permission to perform this action';
                    Err1Lbl: Label 'You can not approve this Document! \You have not been set up as the Approver.';
                    Err2Lbl: Label 'The Payroll Period associated with this Salary is not Pending!';
                    Err3Lbl: Label 'Unable to send email to the Requester! Please check the setup or internet connection.';
                    Err4Lbl: Label 'Unable to send email to the Accounts! Please check the setup or internet connection';
                    MsgLbl: Label 'Thank you for approving %1 (month) salary.', Comment = '%1 = Payroll Month and Year';
                begin
                    year := Format(Date2DMY(apprvlStatusCU.getEndDate("Period Code"), 3));
                    month := FORMAT(apprvlStatusCU.getEndDate("Period Code"), 0, '<Month Text,9>').ToUpper();
                    monthYear := month + ' ' + year;
                    messageBody := 'Dear HR,<br><br>Payslip schedule for the month of ' + monthYear + ' with Period Code: ' + "Period Code" + '  has been approved and forwarded to the accounts department for funds disbursement.<br><br>' +
                    '<h4>Regards,<br><strong>MD</strong></h4>';
                    accountsMessageBody := 'Dear Accounts,<br><br>Payslip schedule for the month of ' + monthYear + ' with Period Code: ' + "Period Code" + '  has been approved.<br><br> Kindly proceed with the disbursement of funds.<br><br>' +
                    '<h4>Regards,<br><strong>MD</strong></h4>';
                    access.SetRange("User Security ID", UserSecurityId());
                    access.SetFilter("Role ID", 'HLH Approval Perm.');
                    if (access.IsEmpty()) then
                        Error(ErrLbl)
                    else begin
                        accountsMail := apprvlStatusCU.getAccountsEmail();
                        requester := apprvlStatusCU.getRequestedBY("Period Code");
                        requesterEmail := apprvlStatusCU.getRequesterEmail(requester);
                        subject := 'PAYSLIP SCHEDULE APPROVED';
                        approverID := apprvlStatusCU.getApproverID();
                        approver2ID := apprvlStatusCU.getApprover2ID();

                        if ((approverID = UserId) or (approver2ID = UserId)) then begin
                            apprvlStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                            if (Format(apprvlStatus) = 'Pending') then begin
                                apprvlStatusCU.setSalaryApprovalStatus("Period Code", Comment, ApprovalStatus::Approved);
                                apprvlStatusCU.setApprovedBy("Period Code", UserId);
                                ApprovalStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                                Message(MsgLbl, monthYear);
                                if (apprvlStatusCU.sendMail(requesterEmail, messageBody, subject) = false) then
                                    Message(Err3Lbl);
                                if (apprvlStatusCU.sendMail(accountsMail, accountsMessageBody, subject) = false) then
                                    Message(Err4Lbl);
                            end
                            else
                                Error(Err2Lbl);
                        end
                        else
                            Error(Err1Lbl);
                    end;
                end;
            }
            action("Reject")
            {
                ApplicationArea = All;
                Image = Reject;
                Visible = approveVisible;
                ToolTip = 'Executes the Reject action.';
                trigger OnAction()
                var
                    access: Record "Access Control";
                    apprvlStatusCU: Codeunit "HLH Payroll";
                    approverID, approver2ID, messageBody, subject, requester, requesterEmail, month, year, monthYear : Text;
                    apprvlStatus: Option "Open","Pending","Approved","Rejected";
                    ErrLbl: Label 'You do not have the right permission to perform this action';
                    Err1Lbl: Label 'You can not reject this Document! \You have not been set up as the Approver.';
                    Err2Lbl: Label 'The Payroll Period associated with this Salary is not Pending!';
                    Err3Lbl: Label 'Unable to send email to the Requester!';
                    Err4Lbl: Label 'You need to give a reason for rejection!';
                    MsgLbl: Label '%1 (month) was rejected.', Comment = '%1 = Payroll Month and Year';
                begin
                    year := Format(Date2DMY(apprvlStatusCU.getEndDate("Period Code"), 3));
                    month := FORMAT(apprvlStatusCU.getEndDate("Period Code"), 0, '<Month Text,9>').ToUpper();
                    monthYear := month + ' ' + year;
                    messageBody := 'Dear HR,<br><br>Payslip schedule for the month of ' + monthYear + ' with Period Code: ' + "Period Code" + ' has been declined.<br><br>' +
                    'Please see below the reason for the rejection.<br><strong>Comment: </strong>' + Comment + '<br><br>Regards,<br><strong>MD</strong>';
                    access.SetRange("User Security ID", UserSecurityId());
                    access.SetFilter("Role ID", 'HLH Approval Perm.');
                    if (access.IsEmpty()) then
                        Error(ErrLbl)
                    else begin
                        requester := apprvlStatusCU.getRequestedBY("Period Code");
                        requesterEmail := apprvlStatusCU.getRequesterEmail(requester);
                        subject := 'PAYSLIP SCHEDULE DECLINED';
                        approverID := apprvlStatusCU.getApproverID();
                        approver2ID := apprvlStatusCU.getApprover2ID();

                        if ((approverID = UserId) or (approver2ID = UserId)) then begin
                            apprvlStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                            if (Format(apprvlStatus) = 'Pending') then begin
                                if (Comment = '') then
                                    Error(Err4Lbl)
                                else
                                    if (apprvlStatusCU.sendMail(requesterEmail, messageBody, subject)) then begin
                                        apprvlStatusCU.setSalaryApprovalStatus("Period Code", Comment, ApprovalStatus::Rejected);
                                        ApprovalStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                                        Message(MsgLbl, monthYear);
                                    end
                                    else
                                        Error(Err3Lbl);
                            end
                            else
                                Error(Err2Lbl);
                        end
                        else
                            Error(Err1Lbl);
                    end;
                end;
            }
            action(reOpen)
            {
                ApplicationArea = All;
                Caption = 'Re-Open';
                Image = ReOpen;
                ToolTip = 'Executes the Re-Open action.';
                trigger OnAction()
                var
                    accessControl: Record "Access Control";
                    apprvlStatusCU: Codeunit "HLH Payroll";
                    apprvlStatus: Option "Open","Pending","Approved","Rejected";
                    approverMail, approver2Mail, messageBody, month, year, monthYear : Text;
                    requester: Text;
                    ErrLbl: Label 'This Doument can not be re-opened, because it is either Open or Approved!';
                    Err1Lbl: Label 'You can not re-open this Document, because you do not have the right permission set.';
                    subjectLbl: Label 'Salary Approval Request Re-Opened';
                    MsgLbl: Label 'Salary Approval Request Re-Opened Successfully';
                    Err2Lbl: Label 'Approver Email Address can not be found! \Please set an email address for the request.';
                    Err3Lbl: Label 'Unable to send an email to the Approver that this period is re-opened! Please check the setup or internet connection.';

                begin
                    approverMail := apprvlStatusCU.getApproverEmail();
                    approver2Mail := apprvlStatusCU.getApprover2Email();
                    apprvlStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                    requester := apprvlStatusCU.getRequestedBY("Period Code");
                    year := Format(Date2DMY(apprvlStatusCU.getEndDate("Period Code"), 3));
                    month := FORMAT(apprvlStatusCU.getEndDate("Period Code"), 0, '<Month Text,9>').ToUpper();
                    monthYear := month + ' ' + year;
                    messageBody := 'Dear MD,<br><br>Payslip Approval Request for the month of <Strong>' + monthYear + '</Strong>, (Period Code: ' + "Period Code" + ') has been Re-Opened by ' + UserId + '. <br><br>' +
                    '<h4>Regards,<br><strong>HR</strong></h4>';

                    accessControl.SetRange("User Security ID", UserSecurityId());
                    accessControl.SetFilter("Role ID", '%1', 'HLH Permissions');
                    if (approverMail = '') then
                        Error(Err2Lbl);
                    if (accessControl.IsEmpty) then
                        Error(Err1Lbl)
                    else
                        if ((Format(apprvlStatus) = 'Pending') or (Format(apprvlStatus) = 'Rejected')) then begin
                            if (apprvlStatusCU.sendMail(approverMail, messageBody, subjectLbl)) then begin
                                apprvlStatusCU.setSalaryApprovalStatus("Period Code", Comment, ApprovalStatus::Open);
                                ApprovalStatus := apprvlStatusCU.getApprovalStatus("Period Code");
                                Message(MsgLbl);
                                if (approver2Mail <> '') then
                                    apprvlStatusCU.sendMail(approver2Mail, messageBody, subjectLbl);
                            end
                            else
                                Error(Err3Lbl);
                        end
                        else
                            Error(ErrLbl);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        accessControl: Record "Access Control";
        hlhPayroll: Codeunit "HLH Payroll";
        errLbl: Label 'You do not have the right permission to open this page';
        approverID, approver2ID : Text;
    begin
        accessControl.SetRange("User Security ID", UserSecurityId());
        accessControl.SetFilter("Role ID", '%1|%2', 'HLH Approval Perm.', 'HLH Permissions');
        if (accessControl.IsEmpty) then
            Error(errLbl)
        else begin
            CurrPage.Payroll.Page.loadMonthlySalaryByPeriod('NOTHING');
            approverID := hlhPayroll.getApproverID();
            approver2ID := hlhPayroll.getApprover2ID();
            if ((approverID = UserId) or (approver2ID = UserId)) then begin
                commentVisible := true;
                approveVisible := true;
            end
            else begin
                commentVisible := false;
                approveVisible := false;
            end;
        end;
    end;

    var
        "Period Code": Code[100];
        Employee: Text[150];
        approveVisible, commentVisible, commentEditable : Boolean;
        Comment: Text[500];
        ApprovalStatus: Option "Open","Pending","Approved","Rejected";
}