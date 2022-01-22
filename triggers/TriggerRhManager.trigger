trigger TriggerRhManager on Contact (before insert, after insert, before update, after update, 
before delete, after delete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        MeusMetodos.alteraRhManager();
    }

}