({
    handleFormData: function (component, event, helper) {


        const action = $A.get('e.c:FlowingDataFromWizard')
        
        const data = {
            sobjectType: 'Event'
        }

        if (!helper.validation(data)) {
            action.setParams({
                SObject: 'eveData',
                data: undefined,
                isPrev: event.getParam('arguments').isPrev
            });
        }
        else {
            action.setParams({
                SObject: 'eveData',
                data: data,
                isPrev: event.getParam('arguments').isPrev
            });
        }

        action.fire();
    }
})