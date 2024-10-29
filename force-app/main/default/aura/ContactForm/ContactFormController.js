({
    handleFormData: function (component, event, helper) {

        const FirstName = component.find('input-FirstName').get('v.value');
        const LastName = component.find('input-LastName').get('v.value');
        const Phone = component.find('input-Phone').get('v.value');
        const Email = component.find('input-Email').get('v.value');
        const Title = component.find('input-Title').get('v.value');
        const Birthdate = component.find('input-Birthdate').get('v.value');

        const action = $A.get('e.c:FlowingDataFromWizard')

        const data = {
            sobjectType: 'Contact',
            FirstName: FirstName,
            LastName: LastName,
            Phone: Phone,
            Email: Email,
            Title: Title,
            Birthdate: Birthdate,
        }
        
        if (!helper.validation(data)) {
            action.setParams({
                SObject: 'conData',
                data: undefined,
                isPrev: event.getParam('arguments').isPrev
            });
        }
        else {
            action.setParams({
                SObject: 'conData',
                data: data,
                isPrev: event.getParam('arguments').isPrev
            });
        }
        
        action.fire();  
    }
})