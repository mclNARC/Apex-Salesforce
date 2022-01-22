 global class BatchScheduler implements Schedulable {
    global static void agendar(String dataAgendamento){
        System.schedule('Atualizar Opportunidades',dataAgendamento,new BatchScheduler());

    }
    
    
    global void execute(SchedulableContext context){
     Database.executeBatch(new ExcBatch(),1);

}
}
