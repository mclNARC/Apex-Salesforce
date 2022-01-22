trigger TriggerAccountExistente on Account (before insert, after insert, before update, after update, 
before delete, after delete) {
    if(Trigger.isBefore){
        MeusMetodos.capturaContaExistente();
    }

}