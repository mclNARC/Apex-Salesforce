import { api, LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import buscarImovel from '@salesforce/apex/ImovelLWController.buscarImovel';
import alterarNomeEmpreendimento from '@salesforce/apex/ImovelLWController.alterarNomeEmpreendimento';
import alteradorImovel from '@salesforce/apex/ImovelLWController.alteradorDeImovel';
import { updateRecord } from 'lightning/uiRecordApi';

export default class PrimeiroApp extends LightningElement {
   @api recordId;
   
   error = 'Erro';
   nomeImovel ;
   status;
   PossuiSacada;
   valor;
   vagas ;
   metragem ;
   sacadaSelecionada;

   connectedCallback(){
       this.getImovel();
       
   }
   
   getImovel(){
       buscarImovel(
           {
        idImv: this.recordId
       }
       )
       .then(result => {
           this.nomeImovel = result.NomeDoEmpreendimento__c
           this.valor = result.ValorBase__c
           this.metragem = result.Metragem__c
           this.status = result.Status__c
           this.vagas = result.QuantidadeDeVagas__c
           this.PossuiSacada = result.PossuiSacada__c
       })
       .catch(error=>{
           this.error = error;
       })
   }

   
    alteraNomeImovel(){
        alterarNomeEmpreendimento(
            {
         idImv: this.recordId,
         novoNome: this.nomeImovel
        }
        )
        .then(result => {
            updateRecord({ fields: {Id: this.recordId}});
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Done!! ',
                variant: 'seccess'

            });
            this.dispatchEvent(event);
        })

        .catch(error=>{
            this.error = error;
        })
    }
    alterarImovel(){
        alteradorImovel(
            {
         idImv: this.recordId,
         novaMetragem: this.metragem,
         novoStatus: this.status,
         novaVaga: this.vagas,
         novoValor: this.valor
        }
        )
        .then(result => {
            updateRecord({ fields: {Id: this.recordId}});
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Done!! ',
                variant: 'seccess'

            });
            this.dispatchEvent(event);
        })

        .catch(error=>{
            this.error = error;
        })
    }
    
    
    handleNomeChange(event){
        this.nomeImovel = event.target.value;

    }
    handleStatusChange(event){
        this.status = event.target.value;

    }
    handleValorChange(event){
        this.valor = event.target.value;

    }
    handleMetragemChange(event){
        this.metragem = event.target.value;

    }
    handleVagasChange(event){
        this.vagas = event.target.value;

    }



    onClickButtonSalvar(event){
      this.alteraNomeImovel();
      this.alterarImovel();
    }

    onClickButtonCancelar(event){
       
    }
    onClickButtonSacada(event){
        this.sacadaSelecionada = event.target.checked;
    }
}