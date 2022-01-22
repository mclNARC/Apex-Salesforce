public  class caseQueueable implements Queueable {
    List<Case> listCase;
    
    
    public CaseQueueable(List<Case> lista){
        this.listCase = lista;
    }
    List<Account> listAcc = [SELECT Id, Name FROM Account];
    
    public void execute(QueueableContext context ){
        for (Case caso : listCase) {
            for (Account acc : listAcc) {
                if(caso.AccountId.equals(acc.Id)){
                    Contact contato = new Contact();
                    contato.AccountId = acc.Id;
                    contato.AssistantName = (' Assistente'+ acc);
                    contato.OwnerId = acc.OwnerId;

                }
                
            }

            
        }

    }
}
