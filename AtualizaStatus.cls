public with sharing class AtualizaStatus {
   public static void atualizaStatusPorProposta(List<PropostaDeCompra__c> listProposta, Map<Id, PropostaDeCompra__c> mapOldProposta){
    List<PropostaDeCompra__c> listaPrpCompra = new List<PropostaDeCompra__c> ();
    
    mapOldProposta = mapOldProposta == null? new Map <Id, PropostaDeCompra__c>() : mapOldProposta;

    for(PropostaDeCompra__c propostas : listProposta){
         PropostaDeCompra__c oldMap;

         oldMap = mapOldProposta.get(propostas.Id);
         if(oldMap != null &&(propostas.Status__c == oldMap.Status__c || propostas.Status__c !='Em análise')){
             continue;
         }
         
         
         listaPrpCompra.add(propostas);
         if(!listaPrpCompra.isEmpty()){
            atualizaStatusPorProposta(listaPrpCompra);
         }
    }
   }
   public static void atualizaStatusPorProposta(List<PropostaDeCompra__c> listProposta){
        Set<Id> setImovelId = new Set<Id>();
        for(PropostaDeCompra__c propostas : listProposta){
            setImovelId.add(propostas.Imovel__c);
        }
        List<Imovel__c> listaImovel = buscarImovel(setImovelId);

        for(Imovel__c imv : listaImovel){
            imv.Status__c = 'Reservado';
        }

        update listaImovel;
   }

   public static void atualizaStatusAprovado(List<PropostaDeCompra__c> listProposta, Map<Id, 
   PropostaDeCompra__c> mapOldProposta){
    List<PropostaDeCompra__c> listaPrpCompra = new List<PropostaDeCompra__c> ();
    
    mapOldProposta = mapOldProposta == null? new Map <Id, PropostaDeCompra__c>() : mapOldProposta;

    for(PropostaDeCompra__c propostas : listProposta){
         PropostaDeCompra__c oldMap;

         oldMap = mapOldProposta.get(propostas.Id);
         if(oldMap != null &&(propostas.Status__c == oldMap.Status__c || propostas.Status__c !='Finalizada')){
             continue;
         }
         
         
         listaPrpCompra.add(propostas);
         if(!listaPrpCompra.isEmpty()){
            atualizaStatusAprovado(listaPrpCompra);
         }
    }
   }

   public static void atualizaStatusAprovado(List<PropostaDeCompra__c> listProposta){
    Set<Id> setImovelId = new Set<Id>();
    for(PropostaDeCompra__c propostas : listProposta){
        setImovelId.add(propostas.Imovel__c);
    }
    List<Imovel__c> listaImovel = buscarImovel(setImovelId);

    for(Imovel__c imv : listaImovel){
        imv.Status__c = 'Vendido';
    }

    update listaImovel;
}





   public static List<Imovel__c> buscarImovel(Set<id> setImovelId){
       return[Select Id, Status__c From Imovel__c Where Id in :setImovelId];

   }
   
   public static void bloqueiaProposta(List<PropostaDeCompra__c> listProposta){
       //List<PropostaDeCompra__c> listProposta = [SELECT Id, Imovel__c FROM PropostaDeCompra__c];
       List<Imovel__c> listImovel = [SELECT Id
       , Status__c FROM Imovel__c];
       for(PropostaDeCompra__c proposta : listProposta){
           for(Imovel__c imovel : listImovel)
            if(proposta.Imovel__c == imovel.Id && imovel.Status__c == 'Vendido' ){
                proposta.addError('Imóvel já vendido !!');

           }
       }


   }

   public static void enviarEmailComissionado(List<PropostaDeCompra__c> listProposta){
       List<String> emails = new List<String>();
       List<User> listUser = [SELECT Id, Email From User];
       //List<Comissao__c> listComissao = [SELECT OwnerId from Comissao__c];
       //List<PropostaDeCompra__c> listProposta = [SELECT Vendedor__c,Status__c FROM PropostaDeCompra__c];
      for(User user: listUser){
          for(PropostaDeCompra__c proposta: listProposta){
            if(user.Id == proposta.Vendedor__c && proposta.Status__c == 'Finalizada'){
                emails.add(user.Email);
                Messaging.reserveSingleEmailCapacity(5);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = emails; 
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Salesforce ');
                mail.setSubject('Comissão : ' + proposta.Id);
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody('Receberá comissão brevemente' + proposta.Id);
                mail.setHtmlBody('Prosposta e Valor' + proposta.Id +  proposta.Valor__c);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });


            }
          }

      }
              
     }
     public static List<PropostaDeCompra__c> buscaPropostas(){
         return [SELECT Id ,Vendedor__c,Status__c,Valor__c FROM PropostaDeCompra__c];
     }
           
}
