({
    finishComponent: function () {
        console.log('finishComponent');
    },

    progressBar: function (component, event, helper) {

        let cmp_no = component.get('v.cmp_no');
        let pValue = Math.ceil(cmp_no * (100 / 3));
        component.set('v.progress_value', (pValue));

        return;
    },

    setOnViewComponent: function (component, event) {

        let cmp_no = component.get('v.cmp_no');

        if (cmp_no === 1) {
            component.set('v.var_first', true);
            component.set('v.var_second', false);
            component.set('v.var_third', false);
        }
        else if (cmp_no === 2) {
            component.set('v.var_first', false);
            component.set('v.var_second', true);
            component.set('v.var_third', false);
        }
        else {
            component.set('v.var_first', false);
            component.set('v.var_second', false);
            component.set('v.var_third', true);
        }
    },
    fireParentEvent: function (component, event, helper) {

        console.log('firing event if anyony here');

        var action = $A.get('e.c:FlowingDataFromWizard');
        action.fire()
    },

    handleFlowDataEvent: function (component, event, helper) {
        return true;
    },
})