({
    doInit: function (component, event, helper) {

    },

    updateCss: function (component, event, helper) {

        let cssObj = component.get('v.cssObj')

        const descrption = document.getElementsByClassName('cmp-img-description')[0];
        const img = document.getElementsByClassName('img-tag')[0];

        img.setAttribute('src', cssObj.get('imgUrl'));
        descrption.style.fontSize = cssObj.get('fontSize');
        descrption.style.color = cssObj.get('fontColor');
        descrption.textContent = cssObj.get('description');
        
        return;
    }
})