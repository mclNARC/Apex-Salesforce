public with sharing class AccountQueueable implements Queueable {
    List<Account> listContas;


    public AccountQueueable(List<Account> listaConta) {
        this.listContas = listaConta;
    }
    
    List<Contact> listCtt = [SELECT AccountId, OwnerId FROM Contact LIMIT 50];
    List<Case> listaCases = new List<Case>();
    public void execute(QueueableContext context ){
        for(Account acc : listContas){
            for(Contact ctt : listCtt){
                if (acc.Id.equals(ctt.AccountId)) {
                    Case caso = new Case();
                    caso.OwnerId = acc.OwnerId;
                    caso.AccountId = acc.Id;
                    caso.Reason = ('Case reason'+ acc);
                    caso.ContactId = ctt.AccountId;
                    caso.Subject = ('Assunto do Caso:');
                    listaCases.add(caso);
                }
            }

        }

        System.enqueueJob(new CaseQueueable(listaCases));
    }

}
