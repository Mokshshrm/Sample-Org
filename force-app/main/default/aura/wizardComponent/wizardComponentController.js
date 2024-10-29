({

    doInit: function (component, event, helper) {
        helper.progressBar(component, event);
        component.set('v.accData', {
            sobjectType: 'Account',
            Name: null,
            Phone: null,
            AccountNumber: null,
            Site: null,
            Type: null,
            Ownership: null,
        })
        component.set('v.conData', {
            sobjectType: 'Contact',
            FirstName: null,
            LastName: null,
            Phone: null,
            Email: null,
            Title: null,
            Birthdate: null,
        })

        component.set('v.eveData', {

        });
        return;
    },

    prev: function (component, event, helper) {

        if (component.get('v.cmp_no') === 1)
            return;

        var action = component.find('component' + component.get('v.cmp_no'));
        action.getData(true);

        return;
    },

    next: function (component, event, helper) {

        if (component.get('v.cmp_no') === 3)
            return;

        var action = component.find('component' + component.get('v.cmp_no'));
        action.getData(false);

        return;
    },

    save: function (component, event, helper) {
        console.log('save');
    },

    handleFormData: function (component, event, helper) {

        let SObject = 'v.' + event.getParam('SObject');
        let data = event.getParam('data');

        if (data === undefined) {
            console.log('Will be not rendered');
            return;
        }

        component.set(SObject, data);

        if (event.getParam('isPrev') == false) {

            component.set('v.cmp_no', Math.min(component.get('v.cmp_no') + 1, 3));

            if (component.get('v.cmp_no') === 3)
                component.set('v.next', false);
            else if (component.get('v.prev'))
                component.set('v.prev', false);

            console.log('next')
        }
        else {

            component.set('v.cmp_no', Math.max(1, component.get('v.cmp_no') - 1));

            if (component.get('v.cmp_no') === 1)
                component.set('v.prev', true);
            else if (component.get('v.prev'))
                component.set('v.prev', false);

            if (!component.get('v.next'))
                component.set('v.next', true)

            console.log('prev')
        }

        helper.setOnViewComponent(component, event);
        helper.progressBar(component, event, helper);
    }
})