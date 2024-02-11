/// <summary>
/// Codeunit HLH Calc. Days In a Month (ID 50001).
/// </summary>
codeunit 50001 "HLH Calc. Days In a Month"
{
    /// <summary>
    /// CalculateWorkingDays. Method to calculate how many number of working days within a give date range
    /// typically a month is expected.
    /// </summary>
    /// <param name="StartDate">Date.</param>
    /// <param name="EndDate">Date.</param>
    /// <param name="Var WorkingDays">Integer.</param>
    /// <param name="Var NonWorkingDays">Integer.</param>
    /// <param name="Var TotalDays">Integer.</param>
    procedure CalculateWorkingDays(StartDate: Date; EndDate: Date; Var WorkingDays: Integer; Var NonWorkingDays: Integer; Var TotalDays: Integer)
    begin
        ClearValues(WorkingDays, NonWorkingDays, TotalDays);
        CheckMinimumRequired(StartDate, EndDate);
        CountDays(StartDate, EndDate, WorkingDays, NonWorkingDays, TotalDays);
    end;

    //Check that start or end date is not null
    local procedure CheckMinimumRequired(StartDate: Date; EndDate: Date)
    var
        CompanyInformation: Record "Company Information";
        ErrLbl: Label 'Start Date and End Date is Mandatory.';
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error(ErrLbl);

        CompanyInformation.Get();
        CompanyInformation.TESTFIELD("Base Calendar Code");
    end;

    local procedure CountDays(StartDate: Date; EndDate: Date; Var WorkingDays: Integer; Var NonWorkingDays: Integer; Var TotalDays: Integer)
    var
        CustomizedCalendarChange: Record "Customized Calendar Change";
        CompanyInformation: Record "Company Information";
        CalendarManagement: Codeunit "Calendar Management";
        CheckDate: Date;
    begin
        CompanyInformation.Get();
        CalendarManagement.SetSource(CompanyInformation, CustomizedCalendarChange);
        TotalDays := (EndDate - StartDate) + 1;
        CheckDate := StartDate;
        repeat
            if CalendarManagement.IsNonworkingDay(CheckDate, CustomizedCalendarChange) THEN
                NonWorkingDays += 1;
            CheckDate := CalcDate('<1D>', CheckDate);
        until (CheckDate > EndDate);
        WorkingDays := TotalDays - NonWorkingDays;
    end;

    local procedure ClearValues(var WorkingDays: Integer; var NonWorkingDays: Integer; var TotalDays: Integer)
    begin
        Clear(WorkingDays);
        Clear(TotalDays);
        Clear(NonWorkingDays);
    end;
}