codeunit 50002 "VendorFunctions"
{
    procedure CreateVendor(AccountNumber: Code[20]; Name: Text; Address: Text; City: Text; PhoneNumber: Text; Email: Text) JsonResponseString: Text
    var
        JsonRespObj: JsonObject;
        Vend: Record Vendor;
        TaxArea: Record "Tax Area";
        VendPostGroup: Record "Vendor Posting Group";
        GenBusPostGroup: Record "Gen. Business Posting Group";

    begin
        Terminate := false;
        DefTaxArea := 'DefTaxArea';
        DefVendPG := 'DefVendPG';
        DefGenBuPG := 'DefGenBuPG';

        if not InitVendData() then begin
            Terminate := true;
            JsonRespObj.Add('Message', 'Unable to init default Vendor and vendor data');
        end;
        if not Terminate then begin
            Vend.Reset();
            Vend.SetRange("No.", AccountNumber);
            if Vend.FindFirst() then begin
                Terminate := true;
                JsonRespObj.Add('Message', 'Vendor No. ' + AccountNumber + ' already exists');
            end;
        end;
        if not Terminate then begin
            Vend.Init();
            Vend."No." := AccountNumber;
            Vend.Name := Name;
            Vend.Address := Address;
            Vend.City := City;
            Vend."Phone No." := PhoneNumber;

            Vend."Tax Area Code" := DefTaxArea;
            Vend."Vendor Posting Group" := DefVendPG;
            Vend."Gen. Bus. Posting Group" := DefGenBuPG;
            Vend."E-Mail" := Email;
            Vend.Insert(true);

            JsonRespObj.Add('message', 'Vendor No. ' + AccountNumber + ' successfully created');
        end;

        //Get final status
        if Terminate then begin
            JsonRespObj.Add('is_successful', 'false');
        end else begin
            JsonRespObj.Add('is_successful', 'true');
        end;
        //Json to string result
        JsonRespObj.WriteTo(JsonResponseString);
    end;

    procedure getOneVendor(AccountNumber: Code[20]) JsonResponseString: Text
    var
        Vend: Record Vendor;
    begin
        Clear(JsonRespObj);

        Vend.Reset();
        Vend.SetRange("No.", AccountNumber);
        if Vend.FindFirst() then begin
            Vend.CalcFields("Balance (LCY)");
            Vend.CalcFields("Balance Due (LCY)");

            JsonRespObj.Add('account_number', Vend."No.");
            JsonRespObj.Add('name', Vend.Name);
            JsonRespObj.Add('city', Vend.City);
            JsonRespObj.Add('address', Vend.Address);
            JsonRespObj.Add('phone_number', Vend."Phone No.");
            JsonRespObj.Add('balance', Vend."Balance (LCY)");
            JsonRespObj.Add('balance_due', Vend."Balance Due (LCY)");
            JsonRespObj.Add('email_address', Vend."E-Mail");

            JsonRespObj.Add('is_successful', 'true');
        end else begin
            JsonRespObj.Add('is_successful', 'false');
            JsonRespObj.Add('message', 'Vendor No. ' + AccountNumber + ' does not exist');
        end;
        //Json to string result
        JsonRespObj.WriteTo(JsonResponseString);
    end;

    procedure getALLVendors() txtResponseString: Text
    VAR
        Json_Array: JsonArray;
        Json_Item: JsonObject;
        Json_Object: JsonObject;
        Vendor: Record Vendor;
    begin
        Clear(Json_Array);
        Clear(Json_Item);
        Clear(txtResponseString);

        Vendor.Reset;
        if Vendor.FindSet(false, false) then begin
            repeat
                Vendor.CalcFields("Balance (LCY)");
                Vendor.CalcFields("Balance Due (LCY)");

                Json_Item.Add('account_number', Vendor."No.");
                Json_Item.Add('name', Vendor."Name");
                Json_Item.Add('city', Vendor.City);
                Json_Item.Add('address', Vendor.Address);
                Json_Item.Add('phone_number', Vendor."Phone No.");
                Json_Item.Add('balance', Vendor."Balance (LCY)");
                Json_Item.Add('balance_due', Vendor."Balance Due (LCY)");
                Json_Item.Add('email_address', Vendor."E-Mail");


                Json_Array.Add(Json_Item);
                Clear(Json_Item);

            until Vendor.Next() = 0;
            Json_Object.Add('is_successful', 'true');
            Json_Object.Add('records', Json_Array);
            Json_Object.WriteTo(txtResponseString);
        end;
    end;

    procedure ModifyOneVendor(AccountNumber: Code[20]; Name: Text; Address: Text; City: Text; PhoneNumber: Text; Email: Text) JsonResponseString: Text
    var
        Vend: Record Vendor;
    begin
        Vend.Reset();
        Vend.SetRange("No.", AccountNumber);
        if Vend.FindFirst() then begin
            Vend.Name := Name;
            Vend.Address := Address;
            Vend.City := City;
            Vend."Phone No." := PhoneNumber;
            Vend."Tax Area Code" := DefTaxArea; //
            Vend."Vendor Posting Group" := DefVendPG;//
            Vend."Gen. Bus. Posting Group" := DefGenBuPG;//
            Vend."E-Mail" := Email;
            Vend.Modify(true);

            JsonRespObj.Add('name', Vend.Name);
            JsonRespObj.Add('city', Vend.City);
            JsonRespObj.Add('address', Vend.Address);
            JsonRespObj.Add('phone_number', Vend."Phone No.");
            JsonRespObj.Add('is_successful', 'false');
        end else begin
            JsonRespObj.Add('is_successful', 'false');
            JsonRespObj.Add('message', 'Vender No. ' + AccountNumber + ' does not exist');
        end;
        //Json to string result
        JsonRespObj.WriteTo(JsonResponseString);
    end;

    procedure InitVendData() Response: Boolean
    var
        TaxArea: Record "Tax Area";
        VendPG: Record "Vendor Posting Group";
        GenBuPG: Record "Gen. Business Posting Group";
    begin
        Response := false;
        DefTaxArea := 'DefTaxArea';
        DefVendPG := 'DefVendPG';
        DefGenBuPG := 'DefGenBuPG';

        TaxArea.Reset();
        TaxArea.SetRange(Code, DefTaxArea);
        if not TaxArea.FindFirst() then begin
            TaxArea.Init();
            TaxArea.Code := DefTaxArea;
            TaxArea.Description := 'Default Tax Area';
            TaxArea.Insert(true);
        end;

        VendPG.Reset();
        VendPG.SetRange(Code, DefVendPG);
        if not VendPG.FindFirst() then begin
            VendPG.Init();
            VendPG.Code := DefVendPG;
            VendPG.Description := 'Default Vendor Posting Group';
            VendPG.Insert(true);
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

        JsonReqObj: JsonObject;
        JsonRespObj: JsonObject;
        JsonArrayObj: JsonArray;

        DefTaxArea: Text;
        DefVendPG: Text;
        DefGenBuPG: Text;
}
