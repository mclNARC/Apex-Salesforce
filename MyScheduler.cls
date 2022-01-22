global  class MyScheduler implements Schedulable {

    
    global static void agendar(String dataAgendamento){
        System.schedule('Atualizar Opportunidades',dataAgendamento,new MyScheduler());

    }
    
    
    global void execute(SchedulableContext context){
        List<Opportunity> listOpp = [SELECT Id, Name, OwnerId, CloseDate FROM Opportunity
        WHERE IsClosed = FALSE AND (CloseDate < TODAY AND StageName != 'Closed Won' )  ];
        
        for (Opportunity op : listOpp) {
            op.StageName = 'Closed Lost';
            
        }
        update listOpp;
    }

}
