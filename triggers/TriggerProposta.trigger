trigger TriggerProposta on PropostaDeCompra__c (before insert, after insert, before update, after update, 
before delete, after delete) {

    if(Trigger.isAfter && Trigger.isUpdate){
        AtualizaStatus.atualizaStatusPorProposta(trigger.new, trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        AtualizaStatus.atualizaStatusAprovado(trigger.new, trigger.oldMap);
    }

    if(Trigger.isBefore && Trigger.isInsert){
        AtualizaStatus.bloqueiaProposta(trigger.new);
    }

    if(Trigger.isBefore && Trigger.isInsert){
        AtualizaStatus.enviarEmailComissionado(trigger.new);
    }
}