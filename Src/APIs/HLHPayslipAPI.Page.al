/// <summary>
/// Page HLH Payslip API (ID 50022).
/// </summary>
page 50022 "HLH Payslip API"
{
    PageType = API;
    Caption = 'payslipAPI';
    APIPublisher = 'havis360';
    APIGroup = 'myPayCheqPayslip';
    APIVersion = 'v1.0';
    EntityName = 'entityMyPayCheqPayslip';
    EntitySetName = 'entitySetMyPayCheqPayslip';
    SourceTable = Integer;
    DelayedInsert = true;

    // layout
    // {
    //     area(Content)
    //     {
    //         repeater(GroupName)
    //         {
    //             field(fieldName; NameSource)
    //             {
    //                 Caption = 'fieldCaption';

    //             }
    //         }
    //     }
    // }

    /// <summary>
    /// sendPayslip. API method to allow sending of payslip from BC called from outside BC.
    /// </summary>
    /// <param name="PayPeriod">Code[20].</param>
    /// <param name="empNo">Text.</param>
    /// <param name="empName">text.</param>
    /// <param name="recipient">Text.</param>
    /// <returns>Return value of type Text.</returns>
    [ServiceEnabled]
    procedure sendPayslip(PayPeriod: Code[20]; empNo: Text; empName: text; recipient: Text): Text
    var
        hlhMonthlyPayrollHeader: Record "HLH Monthly Payroll Header";
        hlhPayroll: Codeunit "HLH Payroll";
        tempBlob: Codeunit "Temp Blob";
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        base64Convert: Codeunit "Base64 Convert";
        myRecordRef: RecordRef;
        dataInStream: InStream;
        dataOutStream: OutStream;
        txtB64: Text;
        format: ReportFormat;
        MailHdr: Text;
        month, year, monthYear : Text;
        successLbl: Label 'Success';
        emailErrLbl: Label 'Error: Unable to Send Email!';
        errReportLbl: Label 'Error: Unable to generate report!';
        notFoundLbl: Label 'Error: Record not found!';
        notPostedLbl: Label 'Error: Associated Salary has not been paid!';
    begin

        //Confirm if Period of the requested payslip has been posted
        if (hlhPayroll.getSalaryPostedStatus(PayPeriod)) then begin
            year := Format(Date2DMY(hlhPayroll.getEndDate(PayPeriod), 3));
            month := FORMAT(hlhPayroll.getEndDate(PayPeriod), 0, '<Month Text,9>').ToUpper();
            monthYear := month + '' + year;
            MailHdr := 'Dear ' + empName + ',<br><br> ' +
            'Kindly find attached your Payslip for the month of ' + monthYear + ' for your reference.<br><br>'
            + 'Thank you.';
            //Getting the period/salary record that corresponds to the request if exists
            if (hlhMonthlyPayrollHeader.Get(PayPeriod, empNo)) then begin
                hlhMonthlyPayrollHeader.SetRange("Period Code", PayPeriod);
                hlhMonthlyPayrollHeader.SetRange("Employee No.", empNo);
                myRecordRef.GetTable(hlhMonthlyPayrollHeader);
                tempBlob.CreateOutStream(dataOutStream);
                //Generating the payslip in pdf format if found
                if Report.SaveAs(Report::"HLH Payslip", '', format::Pdf, dataOutStream, myRecordRef) then begin
                    tempBlob.CreateInStream(dataInStream);
                    txtB64 := base64Convert.ToBase64(dataInStream, true);
                    emailMessage.Create(recipient, 'Monthly Payslip', MailHdr);
                    emailMessage.SetBodyHTMLFormatted(true);
                    emailMessage.AddAttachment('Payslip.pdf', 'application/pdf', txtB64);
                    //Sending payslip to the requester
                    if (email.Send(emailMessage, "Email Scenario"::MyPayCheq)) then
                        exit(successLbl) //Email sent return success message - to API caller
                    else
                        exit(emailErrLbl); //Email not sent return failure message - to API caller
                end
                else
                    exit(errReportLbl); //Unable to generate report return error - to API caller
            end
            else
                exit(notFoundLbl); //Payroll record not found return error - to API caller
        end
        else
            exit(notPostedLbl); //Payroll has not been posted return error - to API caller
    end;
}