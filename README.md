# D365-BC190-APIs
Dynamics 365 Business Central custom JSON APIs 
                                         ** v.0.0.002**
On condition that the business/client has done MANDATORY SETUPS on D365 BC190 i.e., System general ledger setup(Defining financial year),
No. series setup (for Sales Invoice, Posted sales invoice, purchase invoice, posted purhcase invoice,& Bank No.s).
Bank accounts defined, General journal templates in place i.e., cash receipt journal, Payment journal.
Following the below *SETUP SCRIPTS* one can use the setups endpoint to define the desired code name for various posting group
Types(e.g, VAT Posting group, Customer posting group, General posting group etc). With the MANDATORY SETUPS defined 
together with the ENDPOINT MANDATORY SETUPS as listed below in that order 1 -6 followed,
......Process of purchase invoice, sales Invoicing, Cash receipting Can be carried out end to end. 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NB:
- Account Numbers defined in the scripts were based on a test/sample Chart of Accounts
- Before doing steups inquire from Client/business their Chart Of Accounts
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

*********************************************************************************
SETUPS SCRIPTS
***********************************************************************************************
1.
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <GenProductPositngSetup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defGenProdoctPGCode>DEFGENPRODPG</defGenProdoctPGCode>
            <defGenBusinessPGCode>DEFGENBUPG</defGenBusinessPGCode>
            <salesAccount>4001</salesAccount>
            <salesLineDiscAccount>4001</salesLineDiscAccount>
            <salesInvDiscAccount>4001</salesInvDiscAccount>
            <salesPmtDiscDebitAcc>4001</salesPmtDiscDebitAcc>
            <purchAccount>4001</purchAccount>
            <purchLineDiscAccount>4001</purchLineDiscAccount>
            <purchInvDiscAccount>4001</purchInvDiscAccount>
            <purchPmtDiscCreditAcc>4001</purchPmtDiscCreditAcc>
            <cOGSAccount>4001</cOGSAccount>
            <inventoryAdjmtAccount>4001</inventoryAdjmtAccount>
            <salesCreditMemoAccount>4001</salesCreditMemoAccount>
            <purchCreditMemoAccount>4001</purchCreditMemoAccount>
            <salesPmtDiscCreditAcc>4001</salesPmtDiscCreditAcc>
            <purchPmtDiscDebitAcc>4001</purchPmtDiscDebitAcc>
            <salesPmtTolDebitAcc>4001</salesPmtTolDebitAcc>
            <salesPmtTolCreditAcc>4001</salesPmtTolCreditAcc>
            <purchPmtTolDebitAcc>4001</purchPmtTolDebitAcc>
            <purchPmtTolCreditAcc>4001</purchPmtTolCreditAcc>
            <salesPrepaymentsAccount>4001</salesPrepaymentsAccount>
            <purchPrepaymentsAccount>4001</purchPrepaymentsAccount>
            <purchFADiscAccount>4001</purchFADiscAccount>
            <invtAccrualAccInterim>4001</invtAccrualAccInterim>
            <cOGSAccountInterim>4001</cOGSAccountInterim>
            <directCostAppliedAccount>4001</directCostAppliedAccount>
            <overheadAppliedAccount>4001</overheadAppliedAccount>
            <purchaseVarianceAccount>4001</purchaseVarianceAccount>
        </GenProductPositngSetup>
    </Body>
</Envelope>

---------------------------------------------------------------------------------------------------------
2.
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <CustomerPostingGroup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defCustomerPGCode>DEFCUSTPG</defCustomerPGCode>
            <receivablesAccount>1002</receivablesAccount>
        </CustomerPostingGroup>
    </Body>
</Envelope>
-----------------------------------------------------------------------------------------------------------
3.
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <VendorPostingGroup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defVendorPGCode>DEFVENDPG</defVendorPGCode>
            <payablesAccount>2001</payablesAccount>
        </VendorPostingGroup>
    </Body>
</Envelope>

-------------------------------------------------------------------------------------------------------------
4.
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ItemInventoryPositngSetup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defItemIventoryPGCode>DEFCUSTPG</defItemIventoryPGCode>
            <inventoryAccount>5001</inventoryAccount>
            <inventoryAccountInterim>5001</inventoryAccountInterim>
            <wIPAccount>5001</wIPAccount>
            <materialVarianceAccount>5001</materialVarianceAccount>
            <capacityVarianceAccount>5001</capacityVarianceAccount>
            <mfgOverheadVarianceAccount>5001</mfgOverheadVarianceAccount>
            <capOverheadVarianceAccount>5001</capOverheadVarianceAccount>
        </ItemInventoryPositngSetup>
    </Body>
</Envelope>
--------------------------------------------------------------------------------------------------------------------
5. 
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <VATPositngSetup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defVATProdoctPGCode>DEFVATPRODPG</defVATProdoctPGCode>
            <defVATBusinessPGCode>DEFVATBUPG</defVATBusinessPGCode>
            <salesVATAccount>2001</salesVATAccount>
            <salesVATUnrealAccount>2001</salesVATUnrealAccount>
            <purchaseVATAccount>2001</purchaseVATAccount>
            <purchVATUnrealAccount>2001</purchVATUnrealAccount>
        </VATPositngSetup>
    </Body>
</Envelope>
-----------------------------------------------------------------------------------------------------------------------
6.
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <VATPositngSetup xmlns="urn:microsoft-dynamics-schemas/codeunit/ND_Setups">
            <defVATProdoctPGCode></defVATProdoctPGCode>
            <defVATBusinessPGCode></defVATBusinessPGCode>
            <salesVATAccount>2001</salesVATAccount>
            <salesVATUnrealAccount>2001</salesVATUnrealAccount>
            <purchaseVATAccount>2001</purchaseVATAccount>
            <purchVATUnrealAccount>2001</purchVATUnrealAccount>
        </VATPositngSetup>
    </Body>
</Envelope>
--------------------------------------------------------------------------------------------------------------------------
