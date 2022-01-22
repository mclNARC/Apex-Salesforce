trigger TriggerFuture on Account (before insert,before update) {
    if(Trigger.isBefore){
        if (Trigger.isUpdate) {
            MethodsFuture.validacaoRegistro(Trigger.new);
        }
    }


}