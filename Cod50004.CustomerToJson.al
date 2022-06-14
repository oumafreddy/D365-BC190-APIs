codeunit 50004 "CustomerToJson"
{
    procedure CustomerToJson(): JsonArray
    var
        CustomerRec: Record "Customer";
        JCustomer: JsonArray;
    begin
        if CustomerRec.FindSet then
            repeat
                AddSalesLineToJson(CustomerRec, JCustomer);
            until CustomerRec.Next() = 0;
        exit(JCustomer);
    end;

    local procedure AddSalesLineToJson(CustomerRec: Record "Customer"; JCustomer: JsonArray)
    var
        JCustLine: JsonObject;
    begin
        JCustLine.Add('no', CustomerRec."No.");
        JCustLine.Add('quantity', CustomerRec.Name);

        JCustomer.Add(JCustLine);
    end;
}
