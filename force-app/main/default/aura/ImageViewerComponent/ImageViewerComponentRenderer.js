({
    afterRender: function (component, helper) {

        var action = component.get('c.updateCss');
        $A.enqueueAction(action);
        console.log('child rendered');
    }
})