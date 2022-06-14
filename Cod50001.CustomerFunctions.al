codeunit 50001 "CustomerFunctions"
{
    procedure CreateCustomer(AccountNumber: Code[20]; Name: Text; Address: Text; City: Text; PhoneNumber: Text; Email: Text;
    CustPG: Text; GenBuPG: Text; RecivablesAccount: Code[20])
                            JsonResponseString: Text
    var
        Json_Object: JsonObject;
        Cust: Record Customer;
        TaxArea: Record "Tax Area";
        CustPostGroup: Record "Customer Posting Group";
        GenBusPostGroup: Record "Gen. Business Posting Group";

    begin
        Terminate := false;
        DefTaxArea := 'DefTaxArea';
        DefCustPG := 'DefCustPG';
        DefGenBuPG := 'DefGenBuPG';

        if not InitCustData(RecivablesAccount) then begin
            Terminate := true;
            Json_Object.Add('message', 'Unable to init default customer data');
        end;

        if not Terminate then begin
            Cust.Reset();
            Cust.SetRange("No.", AccountNumber);
            if Cust.FindFirst() then begin
                Terminate := true;
                Json_Object.Add('message', 'Customer No. ' + AccountNumber + ' already exists');
            end;
        end;

        if not Terminate then begin
            Cust.Init();
            Cust."No." := AccountNumber;
            Cust.Name := Name;
            Cust.Address := Address;
            Cust.City := City;
            Cust."Phone No." := PhoneNumber;
            Cust."Tax Area Code" := DefTaxArea;

            if CustPG <> '' then begin
                Cust."Customer Posting Group" := CustPG;
            end else begin
                Cust."Customer Posting Group" := DefCustPG;
            end;

            if GenBuPG <> '' then begin
                Cust."Gen. Bus. Posting Group" := GenBuPG;
            end else begin
                Cust."Gen. Bus. Posting Group" := DefGenBuPG;
            end;



            Cust."E-Mail" := Email;
            Cust.Insert(true);

            Json_Object.Add('message', 'Customer No. ' + AccountNumber + ' successfully created');
        end;

        //Get final status
        if Terminate then begin
            Json_Object.Add('is_successful', 'false');
        end else begin
            Json_Object.Add('is_successful', 'true');
        end;
        //Json to string result
        Json_Object.WriteTo(JsonResponseString);
        EXIT(JsonResponseString);
    end;

    procedure getOneCustomer(CustomerNumber: Code[20]) JsonResponseString: Text
    var
        Cust: Record Customer;
    begin
        Clear(Json_Object);

        Cust.Reset();
        Cust.SetRange("No.", CustomerNumber);
        if Cust.FindFirst() then begin
            Cust.CalcFields("Balance (LCY)");
            Cust.CalcFields("Balance Due (LCY)");
            Json_Object.Add('account_number', Cust."No.");
            Json_Object.Add('name', Cust.Name);
            Json_Object.Add('city', Cust.City);
            Json_Object.Add('address', Cust.Address);
            Json_Object.Add('phone_number', Cust."Phone No.");
            Json_Object.Add('balance', cust."Balance (LCY)");
            Json_Object.Add('balance_due', Cust."Balance Due (LCY)");
            Json_Object.Add('email_address', Cust."E-Mail");
            Json_Object.Add('is_successful', 'true');
        end else begin
            Json_Object.Add('is_successful', 'false');
            Json_Object.Add('message', 'Customer No. ' + CustomerNumber + ' does not exist');
        end;
        //Json to string result
        Json_Object.WriteTo(JsonResponseString);
    end;

    procedure getALLCustomer() txtResponseString: Text
    VAR
        Json_Array: JsonArray;
        Json_Item: JsonObject;
        Json_Object: JsonObject;
        Cust: Record Customer;
    begin
        Clear(Json_Array);
        Clear(Json_Item);
        Clear(txtResponseString);

        Cust.Reset;
        Cust.SetAutoCalcFields(Balance);
        if Cust.FindSet(false, false) then begin
            repeat
                Cust.CalcFields("Balance (LCY)");
                Cust.CalcFields("Balance Due (LCY)");


                Json_Item.Add('account_number', Cust."No.");
                Json_Item.Add('name', Cust."Name");
                Json_Item.Add('city', Cust.City);
                Json_Item.Add('address', Cust.Address);
                Json_Item.Add('phone_number', Cust."Phone No.");
                Json_Item.Add('balance', Cust."Balance (LCY)");
                Json_Item.Add('balance_due', Cust."Balance Due (LCY)");
                Json_Item.Add('email_address', Cust."E-Mail");

                Json_Array.Add(Json_Item);
                Clear(Json_Item);

            until Cust.Next() = 0;

            Json_Object.Add('records', Json_Array);
            Json_Object.Add('is_successful', 'true');
            Json_Object.WriteTo(txtResponseString);
        end;
    end;

    procedure DeleteOneCustomer(AccountNumber: Code[20]) JsonResponseString: Text
    var
        Cust: Record Customer;
    begin
        Cust.Reset();
        Cust.SetRange("No.", AccountNumber);
        if Cust.FindFirst() then begin
            Cust.Delete(true);
            Json_Object.Add('is_successful', 'true');
        end else begin
            Json_Object.Add('is_successful', 'false');
            Json_Object.Add('message', 'Customer No. ' + AccountNumber + ' does not exist');
        end;
        //Json to string result
        Json_Object.WriteTo(JsonResponseString);
        exit(JsonResponseString);
    end;

    procedure InitCustData(RecievablesGLAccount: Text) Response: Boolean
    var
        TaxArea: Record "Tax Area";
        CustPG: Record "Customer Posting Group";
        GenBuPG: Record "Gen. Business Posting Group";
    begin
        Response := false;
        DefTaxArea := 'DefTaxArea';
        DefCustPG := 'DefCustPG';
        DefGenBuPG := 'DefGenBuPG';

        TaxArea.Reset();
        TaxArea.SetRange(Code, DefTaxArea);
        if not TaxArea.FindFirst() then begin
            TaxArea.Init();
            TaxArea.Code := DefTaxArea;
            TaxArea.Description := 'Default Tax Area';
            TaxArea.Insert(true);
        end;

        CustPG.Reset();
        CustPG.SetRange(Code, DefCustPG);
        if not CustPG.FindFirst() then begin
            CustPG.Init();
            CustPG.Code := DefCustPG;
            CustPG.Description := 'Default Customer Posting Group';
            CustPG."Receivables Account" := RecievablesGLAccount;
            CustPG.Insert(true);
        end;


        GenBuPG.Reset();
        GenBuPG.SetRange(Code, DefGenBuPG);
        if not GenBuPG.FindFirst() then begin
            GenBuPG.Init();
            GenBuPG.Code := DefGenBuPG;
            GenBuPG.Description := 'Default Gen. Business Posting Group';
            GenBuPG.Insert(true);
        end;
        Response := true;
    end;

    var
        LineNo: Integer;
        Terminate: Boolean;
        JT1: JsonToken;
        JT2: JsonToken;
        JT3: JsonToken;

        Json_Object: JsonObject;
        JsonArrayObj: JsonArray;

        DefTaxArea: Text;
        DefGenBuPG: Text;
        DefCustPG: text;
}
