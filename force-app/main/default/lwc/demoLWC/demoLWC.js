import { LightningElement, api, track } from 'lwc';
import toastContainer from 'lightning/toastContainer';
import Toast from 'lightning/toast';

export default class DemoLWC extends LightningElement {

    constructor() {
        super();
        console.log("parent cunstructor");
        console.log(this.template)
    }

    connectedCallback() {
        console.log("parent connectedCallback");
    }

    renderedCallback() {
        console.log("parent renderedCallback");
    }

    disconnectedCallback() {
        console.log("parent disconnectedCallback");
    }

    errorCallback(error, stack) {
        console.log("parent errorCallback");
    }

    isModalOpen = false;
    values = ['moksh', 'sharma', 'tmp']
    objj = { dd: 'moksh', tmp: 'dfajifajsd' }
 
    handleClick() {
        // this.isModalOpen = !this.isModalOpen
        this.values = [...this.values, 'dd']
    }
}
