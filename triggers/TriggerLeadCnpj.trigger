trigger TriggerLeadCnpj on Lead (before insert, after insert, before update, after update, 
before delete, after delete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        MeusMetodos.leadVerificaCnpj(trigger.new, trigger.oldMap);    }

}