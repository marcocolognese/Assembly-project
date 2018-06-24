#include <stdio.h>



void leggi();
int confronta(int inserito);
void dinamico();



int main(){

    leggi();

return 0;
}



void leggi(){
    int i,inserito,confronto;
    int tentativi=0;

    printf("Inserire codice (tre valori)\n");
    do{         
        scanf("%i",&inserito);
        tentativi++;
        confronto=confronta(inserito);
        if (confronto==0 && tentativi<3)
            printf("Codice errato, inserire nuovamente il codice\n");
     }
        while(confronto!=1 && tentativi<3);

      if(tentativi==3 && confronto!=1)
        printf("Failure controllo codice. Modalità safe inserita.\n");
}



int confronta(int inserito){
    int cod_dina=332,cod_safe=992,ok=1;

    if(inserito!=cod_dina)
            ok=0;   
    if(ok==1){//attivo 332
        printf("Modalità controllo dinamico inserita\n");
        dinamico();
        return 1;
    }
    if(inserito!=cod_safe)
            return 0;
    if(ok==0){//attivo 992
        printf("Modalità controllo emergenza inserita\n");
        return 1;
    }   
}

             
                       
void dinamico(){
    int tot;
    float nA,nB,nC,nD,nE,nF,somma;
    float x,y,z;
    float k1=3,k2=6,k3=12;
    float flap1,flap2,flap3,flap4;

    printf("Inserire il numero totale dei passeggeri a bordo\n");
    scanf("%i",&tot);

    printf("Inserire il numero totale passeggeri per le file A, B, C (nA nB nC)\n");
    scanf("%f %f %f",&nA,&nB,&nC);

    printf("Inserire il numero totale passeggeri per le file D, E, F (nD nE nF)\n");
    scanf("%f %f %f",&nD,&nE,&nF);
    
    somma=nA+nB+nC+nD+nE+nF;

    if(somma!=tot){
        printf("Somma totali file diverso da totale passeggeri\n");
        dinamico();
        }
    
    x=nA-nF;
    y=nB-nE;
    z=nC-nD;
    flap1=(x*k1/2)+(y*k2/2);
    flap2=(k2*y/2)+(z*k3/2);
    flap3=(-(y*k2/2))-(z*k3/2);
    flap4=(-(x*k1/2))-(y*k2/2);

    printf("\nBias_flap1=%f\nBias_flap2=%f\nBias_flap3=%f\nBias_flap4=%f\n\n",flap1,flap2,flap3,flap4);

}
