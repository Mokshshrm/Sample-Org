({
    handleFormData: function (component, event, helper) {

        const Name = component.find('input-Name').get('v.value');
        const Phone = component.find('input-Phone').get('v.value');
        const AccountNumber = component.find('input-AccountNumber').get('v.value');
        const Site = component.find('input-Site').get('v.value');
        const Type = component.find('input-Type').get('v.value');
        const Ownership = component.find('input-Ownership').get('v.value');


        const action = $A.get('e.c:FlowingDataFromWizard')

        const data = {
            sobjectType: 'Account',
            Name: Name,
            Phone: Phone,
            AccountNumber: AccountNumber,
            Site: Site,
            Type: Type,
            Ownership: Ownership
        }

        if (!helper.validation(data)) {
            action.setParams({
                SObject: 'accData',
                data: undefined,
                isPrev:event.getParam('arguments').isPrev 
            });
        } else {
            action.setParams({
                SObject: 'accData',
                data: data,
                isPrev:event.getParam('arguments').isPrev
            });
        }

        action.fire();
    }
})