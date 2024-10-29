({
    doInit: function (component, event, helper) {

        const cmp_obj = new Map();

        cmp_obj.set('imgUrl', '')
        cmp_obj.set('description', 'value')
        cmp_obj.set('fontSize', '2rem')
        cmp_obj.set('fontColor', 'red')
        cmp_obj.set('backgroundColor', 'red')

        component.set('v.cmp_obj', cmp_obj);

        return;
    },

    updateObjectValues: function (component, event, helper) {


        const field1 = component.find('cmp-input-field1').get('v.value');
        const field2 = component.find('cmp-input-field2').get('v.value');
        const field3 = component.find('cmp-input-field3').get('v.value');
        const field4 = component.find('cmp-input-field4').get('v.value');
        const field5 = component.find('cmp-input-field5').get('v.value');

        console.log(field1, field2, field3, field4, field5)

        let mappp = component.get('v.cmp_obj');

        field1.length > 0 && mappp.set('imgUrl', field1)
        field2.length > 0 && mappp.set('description', field2)
        field3.length > 0 && mappp.set('fontSize', field3)
        field4.length > 0 && mappp.set('fontColor', field4)
        field5.length > 0 && mappp.set('backgroundColor', field5)
        
        
        component.set('v.cmp_obj', mappp);

        return;
    },
})