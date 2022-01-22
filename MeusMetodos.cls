public with sharing class MeusMetodos {

    public static void capturaContaExistente(){
        List<Account> listConta = MeusMetodosDAO.buscarAccountCnpj();
        List<Decimal> setCnpj = new List <Decimal>();
    Map <Decimal,Account> accountExistenteMap = new Map<Decimal,Account>();

    for(Account acc : listConta){
        setCnpj.add(acc.Cnpj__c);
    }
    
    List<Account> listAccount = [SELECT Id, Name, Cnpj__c FROM Account WHERE Cnpj__c IN : setCnpj];

    for(Account acc : listAccount){
        accountExistenteMap.put(acc.Cnpj__c , acc);
    }
    for(Account a : listConta){
       
        Account contaExistente = accountExistenteMap.get(a.Cnpj__c);
        
        if(contaExistente !=null){
            a.addError('Conta Já Existente');

        }
    }
    }


    public static void alteraRhManager(){
        List<Contact> listCtt = MeusMetodosDAO.buscarContatos();
        List<Account> listAcc = MeusMetodosDAO.buscarContas();
        List<Account> listContas = new List<Account>();
        for(Contact cnt : listCtt){
            for (Account acc : listAcc) {
                if (cnt.Id == acc.Id && (cnt.Department.equals('RH')&& cnt.Description.equals('Manager'))) {
                    acc.RhManager__c = true;
                    acc.RHManageName__c = cnt.Name;
                    listContas.add(acc);
                    
                }
            }

        }
        update listContas;
    }

    public static void leadVerificaCnpj(List<Lead> listLead, Map<Id,Lead> mapOldLead){
         List<Lead> listLeads = new List<Lead>();
        mapOldLead = mapOldLead == null? new Map <Id, Lead>() :mapOldLead;
        for (Lead lead : listLead) {
            Lead oldLead;
            oldLead = mapOldLead.get(lead.Id);
            if (oldLead != null &&  oldLead.Cnpj__c != lead.Cnpj__c) {
                listLeads.add(lead);
                
            }
            
        }

        verificacaoCnpj(listLeads);
     }
    public static void verificacaoCnpj(List<Lead> listaLead){
        List<Account> listAcc = MeusMetodosDAO.buscarContas();
        List<Lead> listLead = new List<Lead>();
        for (Lead ld : listaLead) {
            for(Account acc: listAcc){
                if(ld.Cnpj__c != acc.Cnpj__c){
                    ld.addError('Cnpj não encontrado na base');
                }else {
                    listLead.add(ld);
                    ld.ClienteExiste__c = true;
                    Opportunity op = new Opportunity();
                    op.AccountId = acc.Id;
                    op.StageName = 'Prospecting';
                }
            }
             
             
         }
         update listLead;
        }
    public static void addContaNovaNasOportunidades(){
        List<Opportunity> listOpp = MeusMetodosDAO.buscarOppFiltrada();
        List<Opportunity> listOportunidades = new List<Opportunity>();
        Account novaConta = new Account();
        for (Opportunity opp : listOpp) {
            if (listOpp != null) {
                listOportunidades.add(opp);
                opp.AccountId = novaConta.Id;
                opp.Name = novaConta.Name;
                
            }
            
        }
        update listOportunidades;

    }


}
