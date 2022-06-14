codeunit 50003 "ItemFunctions"
{
    procedure CreateItem(ItemNumber: Code[20]; Description: Text; UnitOfMeasure: Text; UnitPriceExclVAT: Decimal; ItemType: Integer) JsonResponseString: Text
    var
        JsonRespObj: JsonObject;
        Item: Record Item;
        TaxArea: Record "Tax Area";
        ItemPostGroup: Record "Inventory Posting Group";
        GenBusPostGroup: Record "Gen. Business Posting Group";
        SalesItemUOM: Record "Item Unit of Measure"; //For Sales UOM
        SalesItemUOM_2: Record "Item Unit of Measure"; //For Sales UOM
        UnitofMeasureRec: Record "Unit of Measure";
    begin
        Terminate := false;
        DefTaxArea := 'DefTaxArea';
        DefItemIventoryPG := 'DefItemIventoryPG';
        DefGenProdPG := 'DefGenProdPG';

        //Insert UOM into Sales Unit of Measure
        SalesItemUOM.Reset();
        SalesItemUOM.SetRange("Item No.", ItemNumber);
        SalesItemUOM.SetRange(Code, UnitOfMeasure);
        if not SalesItemUOM.FindFirst() then begin
            SalesItemUOM_2.Reset();
            SalesItemUOM_2.Init();
            SalesItemUOM_2.Code := UnitOfMeasure;
            SalesItemUOM_2."Item No." := ItemNumber;
            SalesItemUOM_2.Insert();
        end;

        //Insert UOM into Unit of Measure
        UnitofMeasureRec.Reset();
        UnitofMeasureRec.SetRange(Code, UnitOfMeasure);
        if not UnitofMeasureRec.FindFirst() then begin
            UnitofMeasureRec.Reset();
            UnitofMeasureRec.Init();
            UnitofMeasureRec.Code := UnitOfMeasure;
            UnitofMeasureRec.Description := UnitOfMeasure;
            UnitofMeasureRec.Insert();
        end;

        if not InitItemData() then begin
            Terminate := true;
            JsonRespObj.Add('message', 'Unable to init default Item and Item data');
        end;
        if not Terminate then begin
            Item.Reset();
            Item.SetRange("No.", ItemNumber);
            if Item.FindFirst() then begin
                Terminate := true;
                JsonRespObj.Add('message', 'Item No. ' + ItemNumber + ' already exists');
            end;
        end;


        if not Terminate then begin
            Item.Init();
            Item."No." := ItemNumber;
            Item.Description := Description;
            Item."Base Unit of Measure" := UnitOfMeasure;
            Item."Sales Unit of Measure" := UnitOfMeasure;
            Item."Inventory Posting Group" := DefItemIventoryPG;
            Item."Gen. Prod. Posting Group" := DefGenProdPG;
            Item."Unit Price" := UnitPriceExclVAT;
            item.Type := ItemType;
            Item.Insert(true);

            JsonRespObj.Add('item_number', ItemNumber);
            JsonRespObj.Add('message', 'Item No. ' + ItemNumber + ' successfully created with Sales UOM as ' + Item."Sales Unit of Measure");
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




    procedure getOneItem(ItemNumber: Code[20]) JsonResponseString: Text
    var
        Item: Record Item;
    begin
        Clear(JsonRespObj);

        Item.Reset();
        Item.SetRange("No.", ItemNumber);
        if Item.FindFirst() then begin
            JsonRespObj.Add('item_number', Item."No.");
            JsonRespObj.Add('item_type', format(Item.Type));
            JsonRespObj.Add('description', Item.Description);
            JsonRespObj.Add('base_uom', Item."Base Unit of Measure");
            JsonRespObj.Add('sales_uom', Item."Sales Unit of Measure");
            JsonRespObj.Add('unit_price', Item."Unit Price");
            JsonRespObj.Add('unit_cost', Item."Unit Cost");
            JsonRespObj.Add('is_successful', 'true');
        end else begin
            JsonRespObj.Add('is_successful', 'false');
            JsonRespObj.Add('Message', 'Item No. ' + ItemNumber + ' does not exist');
        end;
        //Json to string result
        JsonRespObj.WriteTo(JsonResponseString);
    end;

    procedure getALLItems() txtResponseString: Text
    VAR
        Json_Array: JsonArray;
        Json_Item: JsonObject;
        Json_Object: JsonObject;
        Item: Record Item;
    begin
        Clear(Json_Array);
        Clear(Json_Item);
        Clear(txtResponseString);

        Item.Reset;
        if Item.FindSet(false, false) then begin
            repeat
                Json_Item.Add('item_number', Item."No.");
                Json_Item.Add('item_type', format(Item.Type));
                Json_Item.Add('description', Item.Description);
                Json_Item.Add('base_uom', Item."Base Unit of Measure");
                Json_Item.Add('sales_uom', Item."Sales Unit of Measure");
                Json_Item.Add('unit_price', Item."Unit Price");
                Json_Item.Add('unit_cost', Item."Unit Cost");


                Json_Array.Add(Json_Item);
                Clear(Json_Item);

            until Item.Next() = 0;

            Json_Object.Add('records', Json_Array);
            Json_Object.Add('is_successful', 'true');
            Json_Object.WriteTo(txtResponseString);
        end;
    end;

    procedure GetItemTypes() txtResponseString: Text;
    var
        CurrItem: Enum "Sales Line Type";
        Json_Array: JsonArray;
        Json_Item: JsonObject;
        Json_Object: JsonObject;
    begin
        foreach CurrItem in Enum::"Sales Line Type".Ordinals() do begin
            // Message('%1', CurrItem);
            Json_Item.Add('type', format(CurrItem));
            Json_Array.Add(Json_Item);
            Clear(Json_Item);
        end;
        Json_Object.Add('records', Json_Array);
        Json_Object.WriteTo(txtResponseString);
    end;


    procedure ModifyOneItem(ItemNumber: Code[20]; Description: Text) JsonResponseString: Text
    var
        Item: Record Item;
    begin
        Item.Reset();
        Item.SetRange("No.", ItemNumber);
        if Item.FindFirst() then begin
            Item.Description := Description;
            Item.Modify(true);

            JsonRespObj.Add('description', Item.Description);
            JsonRespObj.Add('is_successful', 'false');
        end else begin
            JsonRespObj.Add('is_successful', 'false');
            JsonRespObj.Add('message', 'Itemer No. ' + ItemNumber + ' does not exist');
        end;
        //Json to string result
        JsonRespObj.WriteTo(JsonResponseString);
    end;

    procedure InitItemData() Response: Boolean
    var
        TaxArea: Record "Tax Area";
        ItemPG: Record "Inventory Posting Group";
        //GenBuPG: Record "Gen. Business Posting Group";
        GenProdPG: Record "Gen. Product Posting Group";
        ItemUOM: Record "Item Unit of Measure";
    begin
        Response := false;
        DefTaxArea := 'DefTaxArea';
        DefItemIventoryPG := 'DefItemIventoryPG';
        DefGenProdPG := 'DefGenProdPG';



        TaxArea.Reset();
        TaxArea.SetRange(Code, DefTaxArea);
        if not TaxArea.FindFirst() then begin
            TaxArea.Init();
            TaxArea.Code := DefTaxArea;
            TaxArea.Description := 'Default Tax Area';
            TaxArea.Insert(true);
        end;




        ItemPG.Reset();
        ItemPG.SetRange(Code, DefItemIventoryPG);
        if not ItemPG.FindFirst() then begin
            ItemPG.Init();
            ItemPG.Code := DefItemIventoryPG;
            ItemPG.Description := 'Default Inventory Posting Group';
            ItemPG.Insert(true);
        end;

        GenProdPG.Reset();
        GenProdPG.SetRange(Code, DefGenProdPG);
        if not GenProdPG.FindFirst() then begin
            GenProdPG.Init();
            GenProdPG.Code := DefGenProdPG;
            GenProdPG.Description := 'Default Gen. Business Posting Group';
            GenProdPG.Insert(true);
        end;
        Response := true;
    end;

    procedure getALLItemsBaseUOMSalesUOM() txtResponseString: Text
    VAR
        Json_Array: JsonArray;
        Json_Item: JsonObject;
        Json_Object: JsonObject;
        Item: Record Item;
    begin
        Clear(Json_Array);
        Clear(Json_Item);
        Clear(Json_Object);
        ;
        Clear(txtResponseString);

        Item.Reset;
        Item.SetAutoCalcFields(Inventory);
        if Item.FindSet(false, false) then begin
            repeat
                Json_Item.Add('item_number', Item."No.");
                Json_Item.Add('description', Item.Description);
                Json_Item.Add('base_uom', Item."Base Unit of Measure");
                Json_Item.Add('sales_uom', Item."Sales Unit of Measure");
                Json_Item.Add('inventory', Item.Inventory);
                Json_Item.Add('is_successful', 'true');

                Json_Array.Add(Json_Item);
                Clear(Json_Item);

            until Item.Next() = 0;

            Json_Object.Add('records', Json_Array);
            Json_Object.WriteTo(txtResponseString);
        end;
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
        DefItemIventoryPG: Text;
        DefGenProdPG: Text;
}
