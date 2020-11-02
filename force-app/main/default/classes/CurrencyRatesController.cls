public with sharing class CurrencyRatesController {

    private static final String CURRENCY_RATES_URL = 'https://api.ratesapi.io/api/latest';

    @AuraEnabled(Cacheable = true)
    public static List<Rate> getCurrencyRates() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(CURRENCY_RATES_URL);
        request.setMethod('GET');
        try {
            HttpResponse response = http.send(request);
            List<Rate> rates = new List<Rate>();
            if (response.getStatusCode() == 200) {
                System.debug(response.getBody());
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String baseCurrency;
                if (result.containsKey('base')) {
                    baseCurrency = (String) result.get('base');
                }
                Map<String, Object> rateValues = new Map<String, Object>();
                if (result.containsKey('rates')) {
                    rateValues = (Map<String, Object>) result.get('rates');
                }
                if (String.isNotBlank(baseCurrency) && !rateValues.isEmpty()) {
                    for (String curr : rateValues.keySet()) {
                        Rate r = new Rate();
                        r.baseCurrency = baseCurrency;
                        r.quotedCurrency = curr;
                        r.value = (Double) rateValues.get(curr);
                        rates.add(r);
                    }
                }
            }
            return rates;
        } catch (Exception ex) {
            throw new AuraHandledException('Bad Request: ' + ex.getMessage());
        }
    }

    public class Rate {
        @AuraEnabled
        public String quotedCurrency;
        @AuraEnabled
        public String baseCurrency;
        @AuraEnabled
        public double value;
    }


}
