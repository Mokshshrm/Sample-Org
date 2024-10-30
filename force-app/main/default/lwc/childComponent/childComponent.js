import { api, LightningElement, track } from 'lwc';

export default class ChildComponent extends LightningElement {

    constructor(){
        super();
        console.log('child')
    }
    @api namee
    @api obj;

    renderr = true;

    handleClickk() {
        console.log('child');
        this.renderr = !this.renderr;
        this.namee = 'namee';
    }

}