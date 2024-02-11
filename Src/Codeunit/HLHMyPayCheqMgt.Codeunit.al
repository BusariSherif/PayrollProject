/// <summary>
/// Codeunit HLH MyPayCheq Mgt. (ID 50002).
/// </summary>
codeunit 50002 "HLH MyPayCheq Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)]
    local procedure MyPayCheqSetupRegister()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertAssistedSetup('MyPayCheq Setup', 'MyPayCheq Setup',
                                             'This setup will guide you through the Global Setup for MyPayCheq Payroll Application',
                                             1,
                                             ObjectType::Page,
                                             Page::"HLH MyPayCheq Setup",
                                             enum::"Assisted Setup Group"::DoMoreWithBC,
                                             'https://www.ha-shem.com/policies',
                                             enum::"Video Category"::DoMoreWithBC,
                                             'https://www.ha-shem.com/services');
    end;

    /// <summary>
    /// getAccountName. Method to validate a bank account number of an employee using the paystack API
    /// </summary>
    /// <param name="accNo">VAR Text.</param>
    /// <param name="bankCode">Text.</param>
    /// <returns>Return variable accName of type Text.</returns>
    procedure getAccountName(accNo: Text; bankCode: Text) accName: Text;
    var
        httpClientVar: HttpClient;
        httpResponseMessageVar: HttpResponseMessage;
        responseText: Text;
        tempName: Text;
        jObject: JsonObject;
        jToken: JsonToken;
        jObject1: JsonObject;
        jToken1: JsonToken;
        emptyAccNoLbl: Label 'Account Number can not be empty!';
        accNoErrLbl: Label 'Account Number is incorrect\Value must be 10 digit.';
        tokenNotFoundLbl: Label 'API Token value can not be found in the Setup!';
        verificationErrLbl: Label 'Could not verify account, please contact your Administrator.';
        accErrorLbl: Label 'Could not fetch account detail: %1\Please check the account detail and retry.\Failed with status code: %2', Comment = '%1 = Status Code %2 = Reason Phrase';
        APIToken: Text;
    begin
        APIToken := getBearerToken();
        if (APIToken = '') then //Making sure API Token is not empty in the setup page
            Error(tokenNotFoundLbl);
        if accNo = '' then //Making sure acc no is not empty
            Error(emptyAccNoLbl);
        if (StrLen(accNo) <> 10) then // Making sure acc no is not less or more than 10 digits
            Error(accNoErrLbl)
        else begin
            httpClientVar.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + APIToken);
            httpClientVar.Get('https://api.paystack.co/bank/resolve?account_number=' + accNo + '&bank_code=' + bankCode, httpResponseMessageVar);
            if httpResponseMessageVar.IsSuccessStatusCode then begin
                httpResponseMessageVar.Content().ReadAs(responseText);
                jObject.ReadFrom(responseText);
                jObject.Get('data', jToken);

                if jToken.IsObject then begin
                    jToken.WriteTo(tempName);
                    jObject1.ReadFrom(tempName);
                    jObject1.Get('account_name', jToken1);
                    accName := jToken1.AsValue().AsText();
                    exit(accName);
                end
                else
                    Error(verificationErrLbl);
            end
            else begin
                httpResponseMessageVar.Content().ReadAs(responseText);
                Message(accErrorLbl, httpResponseMessageVar.ReasonPhrase, httpResponseMessageVar.HttpStatusCode);
            end;
        end;
    end;

    /// <summary>
    /// getBearerToken. Method to get API Token (Paystack) form the setup page
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure getBearerToken(): Text
    var
        hlhMyPayCheqSetup: Record "HLH MyPayCheq Setup";
        APIKeyNotFoundLbl: Label 'API Key not Found!';
    begin
        if hlhMyPayCheqsetup.FindFirst() then
            exit(hlhMyPayCheqsetup."PayStack API Key")
        else
            Error(APIKeyNotFoundLbl);
    end;

}