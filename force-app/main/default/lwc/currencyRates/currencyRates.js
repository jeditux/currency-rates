import { LightningElement } from 'lwc';
import getCurrencyRates from '@salesforce/apex/CurrencyRatesController.getCurrencyRates'

export default class CurrencyRates extends LightningElement {
    rates = [];

    connectedCallback() {
        getCurrencyRates()
            .then(data => {
                console.log('Currency rates received.');
                this.rates = data;
            }).catch(error => {
                console.log(error);
            });
    }
}