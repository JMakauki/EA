// version 1
   // Grid Strategies
   // Zone recovery strtegies


//+------------------------------------------------------------------+
//|                                                         Grid.mq4 |
//|                                  Copyright 2022. Johnson Makauki |
//|                                    https://www.makauki.epizy.com |
//+------------------------------------------------------------------+
#property copyright "Copyright \x00A9 2022. Johnson Makauki"
#property link      "https://www.mql5.com/en/users/johnsonmakauki"
#property icon      "me.ico"
#property version   "1.00"
#property strict
#property description "This expert advisor(EA) can apply four strategies when trading in financial markets. However the user must choose which strategy should be used everytime the EA is launched. If you wish to use more than one strategy at a time, then you can run multiple instances of this EA and choose one strategy for each instance."

double spread=Ask-Bid;

enum yesno
  {
   No,
   Yes
  };
enum str
  {
   Grid,//GRID STRATEGY
   Zone//ZONE RECOVERY 
  };
sinput str strategy;//SELECT A STRATEGY
yesno usegrid=strategy==Grid?Yes:No;

sinput string line1;//-
sinput string line2;//-

//Grid variables begin
sinput string grid="================================================";//=== G R I D    S T R A T E G Y   S E T T I N G S
sinput yesno reverse=No; //Reverse this strategy?
int border=2;
int sorder=3;
sinput double lot=0.01; //Lot size (For each order)
double mylot=1;
double fp;
double topprice;
double bottomprice;
bool isDeleted;
bool isSelected;
int choice;
int rchoice=1;
sinput int gridSizePips=60;// Grid gap size (pips)
int gridSize=gridSizePips*10;
sinput float maxstops=10; //Maximum grids
double sl=Point*gridSize;
double tp=sl*maxstops;
double remainder;
double currentPrice;
double maxPrice;
double minPrice;

double equity;
double firstequity;
double fixedequity=AccountEquity();
sinput float profit=10;//Percentage Profit
sinput float loss=10; //Percentage Loss
int upstops;
int downstops;
//Grid variables end

//Zone variables begin
sinput string line;//-
sinput string zone="================================================";//=== ZONE RECOVERY STRATEGY SETTINGS
yesno usezone=strategy==Zone?Yes:No;//Use this stragegy?
sinput yesno zonereverse=No;//Reverse this strategy?
sinput int gapsize=40;// Recovery gap size (pips)
float gap=Point*gapsize*10;
sinput double zonelot=0.01; // Initial lot size
sinput double maxlot=100;// Maximum lot size
sinput double zoneprofit=20;//Profit target in %

//Zone variables end


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start() {
   Alert("A ROBOT HAS BEEN ATTACHED TO THIS CHART");

//Grid start begin   
if(usegrid==Yes)
{
   if (reverse==No)
   {
      
   
      if (OrdersTotal()==0) {
         border = OrderSend(Symbol(),OP_BUY,lot*mylot,Ask,50,0,Bid+sl,"I HAVE BOUGHT HERE",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELL,lot*mylot,Bid,50,0,Ask-sl,"I HAVE SOLD HERE",0,NULL,NULL);
         border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
         border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,0,Bid+2*sl,"A buy stop",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,0,Ask-2*sl,"A sell stop",0,NULL,NULL);
      }


      isSelected=OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
      fp = Ask;
      currentPrice= Ask;
      maxPrice=Ask;
      minPrice=Ask;
      choice =1;
      
      topprice=fp+4;
      bottomprice=fp-4;
      
      equity=AccountEquity();
      firstequity=AccountEquity();
      
      upstops=0;
      downstops=0;

   }
   else if (reverse==Yes)
   {
      if (OrdersTotal()==0) {
         border = OrderSend(Symbol(),OP_BUY,lot*mylot,Ask,50,Bid-sl,0,"I HAVE BOUGHT HERE",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELL,lot*mylot,Bid,50,Ask+sl,0,"I HAVE SOLD HERE",0,NULL,NULL);
         border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,Bid-2*sl,0,"A buy limit",0,NULL,NULL);
         border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,Bid,0,"A buy stop",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,Ask+2*sl,0,"A sell limit",0,NULL,NULL);
         sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,Ask,0,"A sell stop",0,NULL,NULL);
      }


      isSelected=OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
      fp = Ask;
      currentPrice= Ask;
      maxPrice=Ask;
      minPrice=Ask;
      choice =1;
      
      topprice=fp+4;
      bottomprice=fp-4;
      
      equity=AccountEquity();
      firstequity=AccountEquity();
      
      upstops=0;
      downstops=0;
   }
}
//Grid start end




//Zone start begin
   if(usezone==Yes)
   {
      spread=Ask-Bid;
      if(zonereverse==No)
      {
         if (OrdersTotal()==0){
            border = OrderSend(Symbol(),OP_BUY,zonelot,Ask,50,Ask-gap*3-spread,Ask+gap*2,"I HAVE BOUGHT HERE",0,NULL,NULL);
            //sorder = OrderSend(Symbol(),OP_SELLLIMIT,2*lot,Ask+gap,50,Ask+gap*3/2,Ask-gap*1/2,"I HAVE SOLD HERE",0,NULL,NULL);
            isSelected=OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            
            fp = OrderOpenPrice(); 
            choice =1;
            
            equity=AccountEquity();
         }
       }
       else if(zonereverse==Yes)
       {
         if (OrdersTotal()==0){
            border = OrderSend(Symbol(),OP_BUY,zonelot,Ask,50,Ask-gap*2-spread,Ask+gap*3,"I HAVE BOUGHT HERE",0,NULL,NULL);
            //sorder = OrderSend(Symbol(),OP_SELLLIMIT,2*lot,Ask+gap,50,Ask+gap*3/2,Ask-gap*1/2,"I HAVE SOLD HERE",0,NULL,NULL);
            isSelected=OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            
            fp = OrderOpenPrice(); 
            choice =1;
            
            equity=AccountEquity();
          }
        }
    }
//Zone start end
}

//+------------------------------------------------------------------+
//|       Close function                                                           |
//+------------------------------------------------------------------+
void closeall() {
   int total=OrdersTotal();
   for (int i=total-1; i>=0; i--) {
      isSelected=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if (OrderType()== OP_BUYSTOP) {
         isDeleted= OrderDelete(OrderTicket(),clrAntiqueWhite);

      }
      if (OrderType()== OP_SELLSTOP) {
         isDeleted= OrderDelete(OrderTicket(),clrAntiqueWhite);

      }
      if (OrderType()== OP_BUYLIMIT) {
         isDeleted= OrderDelete(OrderTicket(),clrAntiqueWhite);

      }
      if (OrderType()== OP_SELLLIMIT) {
         isDeleted= OrderDelete(OrderTicket(),clrAntiqueWhite);

      }
      if (OrderType()== OP_BUY) {
         isDeleted= OrderClose(OrderTicket(),OrderLots(),Bid,60,clrOrange);

      }
      if (OrderType()== OP_SELL) {
         isDeleted= OrderClose(OrderTicket(),OrderLots(),Ask,60,clrOrange);

      }

   }
}



//+------------------------------------------------------------------+
//|         Set stops                                                         |
//+------------------------------------------------------------------+
void setStops() {
if(usegrid==Yes)
{
   if (reverse==Yes)
   {
   
      int pips=(Ask-fp)/Point;
      remainder=pips%gridSize;
      if(Bid>fp+sl/2 && remainder==0 && (currentPrice>Ask+sl/2 || currentPrice<Ask-sl/2) && Bid<=fp+tp)
        {
        
         if(Bid>maxPrice+sl/2)
           {
            currentPrice= Ask;
            maxPrice=Ask;
            upstops++;
                 
            border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,Bid,0,"A buy stop",0,NULL,NULL);
            sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,Ask+2*sl,0,"A sell limit",0,NULL,NULL);
            
            sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,Ask,0,"A sell stop",0,NULL,NULL);
            
           }else
               {
                  if(Bid>currentPrice+sl/2)
                    {
                     sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,Ask,0,"A sell stop",0,NULL,NULL);
                     currentPrice = Ask;
                    }
                    if(Bid<currentPrice-sl/2)
                      {
                        border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,Bid,0,"A buy stop",0,NULL,NULL);
                        currentPrice = Ask;
                      }

               }
         
        } 
               
           
            pips=(fp-Ask)/Point;
            remainder=pips%gridSize;
            if(Ask<fp-sl/2 && (remainder)==0 && (currentPrice>Ask+sl/2 || currentPrice<Ask-sl/2)&& Ask>=fp-tp)
               {
        
               if(Ask<minPrice-sl/2)
                 {

                  currentPrice= Ask;
                  minPrice=Ask;
                  downstops++;
                  
                  border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,Bid,0,"A buy stop",0,NULL,NULL);
                  
                  sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,Ask,0,"A sell stop",0,NULL,NULL);
                  border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,Bid-2*sl,0,"A buy limit",0,NULL,NULL);
               }else
                     {
                        if(Ask<currentPrice-sl/2)
                        {
                           sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
                           currentPrice = Ask;
                        }
                        if(Ask>currentPrice+sl/2)
                           {
                              border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
                              currentPrice = Ask;   
                           }
                        
                     }
               
               }     
            
            
            
            if(currentPrice>fp+sl/2 && Ask==fp)
              {
               border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,Bid,0,"A buy stop",0,NULL,NULL);
               currentPrice = Ask;
              }
             if(currentPrice<fp-sl/2 && Ask==fp)
               {
                sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,Ask,0,"A sell stop",0,NULL,NULL);
                currentPrice = Ask;   
               }
   }
   else if (reverse==No)
   {
      int pips=(Ask-fp)/Point;
      remainder=pips%gridSize;
      if(Bid>fp+sl/2 && remainder==0 && (currentPrice>Ask+sl/2 || currentPrice<Ask-sl/2) && Bid<=fp+tp)
        {
        
         if(Bid>maxPrice+sl/2)
           {
            currentPrice= Ask;
            maxPrice=Ask;
            upstops++;
                 
            border = OrderSend(Symbol(),OP_BUYSTOP,lot,Ask+sl,50,0,Bid+2*sl,"A buy stop",0,NULL,NULL);
            sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
            
            border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
            
           }else
               {
                  if(Bid>currentPrice+sl/2)
                    {
                     border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
                     currentPrice = Ask;
                    }
                    if(Bid<currentPrice-sl/2)
                      {
                        sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
                        currentPrice = Ask;
                      }

               }
         
        } 
               
           
            pips=(fp-Ask)/Point;
            remainder=pips%gridSize;
            if(Ask<fp-sl/2 && (remainder)==0 && (currentPrice>Ask+sl/2 || currentPrice<Ask-sl/2)&& Ask>=fp-tp)
               {
        
               if(Ask<minPrice-sl/2)
                 {

                  currentPrice= Ask;
                  minPrice=Ask;
                  downstops++;
                  
                  sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
                  
                  sorder = OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-sl,50,0,Ask-2*sl,"A sell stop",0,NULL,NULL);
                  border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
               }else
                     {
                        if(Ask<currentPrice-sl/2)
                        {
                           sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
                           currentPrice = Ask;
                        }
                        if(Ask>currentPrice+sl/2)
                           {
                              border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
                              currentPrice = Ask;   
                           }
                        
                     }
               
               }     
            
            
            
            if(currentPrice>fp+sl/2 && Ask==fp)
              {
               sorder = OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+sl,50,0,Ask,"A sell limit",0,NULL,NULL);
               currentPrice = Ask;
              }
             if(currentPrice<fp-sl/2 && Ask==fp)
               {
                border = OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask-sl,50,0,Bid,"A buy limit",0,NULL,NULL);
                currentPrice = Ask;   
               }
   }
   
   
   //Profit-loss targets
   if(AccountEquity()>equity+fixedequity*profit/100)
    {
     closeall();
     //mylot=mylot*2;
     start();
    }
    
    
  if(AccountEquity()<equity-fixedequity*loss/100)
    {
     closeall();
     //mylot=mylot/2;
     start();
    }
}  
}

void zoneSetStops(){

  if(usezone==Yes)
  {
      if(zonereverse==No)
      {
         isSelected=OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);   
         if (choice == 1){
            
            if (OrderType()== OP_BUY){
               if (OrderLots() <=maxlot){
                  sorder=OrderSend(Symbol(),OP_SELLSTOP,2*OrderLots(),OrderOpenPrice()-gap,50,OrderOpenPrice()+gap*2+spread,OrderOpenPrice()-gap*3,NULL,0,0,clrBlueViolet);         }
               else{ 
                   closeall();
                   choice=2;
                   start();
               }
            }
            if (OrderType()== OP_SELL){
               if (OrderLots() <=maxlot){
                  border=OrderSend(Symbol(),OP_BUYSTOP,2*OrderLots(),OrderOpenPrice()+gap,50,OrderOpenPrice()-gap*2-spread,OrderOpenPrice()+gap*3,NULL,0,0,clrDarkOrange);
               }
               else{
                   closeall();
                   choice=2;
                   start();
               }
            } 
         }
         
           if (OrdersTotal()<2) {
               isDeleted=OrderDelete(OrderTicket(),clrDodgerBlue);
               if (OrdersTotal()==0 ) start();
               
           }
           
           if(AccountEquity()>equity+equity*profit/100)
             {
              closeall();
              start();
             }  
       }
       else if(zonereverse==Yes)
       {
            isSelected=OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);
            if (choice == 1){
               
               if (OrderType()== OP_BUY){
                  if (OrderLots() <=maxlot){
                     sorder=OrderSend(Symbol(),OP_SELLLIMIT,2*OrderLots(),OrderOpenPrice()+gap,50,OrderOpenPrice()+gap*3+spread,OrderOpenPrice()-gap*2,NULL,0,0,clrBlueViolet);         }
                  else{ 
                      closeall();
                      choice=2;
                      start();
                  }
               }
               if (OrderType()== OP_SELL){
                  if (OrderLots() <=maxlot){
                     border=OrderSend(Symbol(),OP_BUYLIMIT,2*OrderLots(),OrderOpenPrice()+gap,50,OrderOpenPrice()-gap*3-spread,OrderOpenPrice()+gap*2,NULL,0,0,clrDarkOrange);
                  }
                  else{
                      closeall();
                      choice=2;
                      start();
                  }
               } 
            }
            
              if (OrdersTotal()<2) {
                  isDeleted=OrderDelete(OrderTicket(),clrDodgerBlue);
                  if (OrdersTotal()==0 ) start();
                  
              }
              
              if(AccountEquity()>equity+equity*profit/100)
                {
                 closeall();
                 start();
                }  
       }
      
   }   
   
}



void recover(){
      if (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
         isSelected=OrderSelect(OrdersTotal()-2,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()== OP_BUY){
         if((Bid-OrderOpenPrice())>=4) {
            rchoice=2;
            sorder = OrderSend(Symbol(),OP_SELL,OrderLots()/3,Bid,50,Bid+2,Bid-4,"I HAVE BOUGHT HERE",0,NULL,NULL);
         }
      }else
      if(OrderType()== OP_SELL){
         if((OrderOpenPrice()-Ask)>=4) {
            rchoice=2;
            border = OrderSend(Symbol(),OP_BUY,OrderLots()/3,Ask,50,Ask-2,Ask+4,"I HAVE BOUGHT HERE",0,NULL,NULL);
         }
      }
}




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//---
   
   start();
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---

}



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
//---
   Comment (
   "Overall Profit: ",AccountEquity()-equity,"\n\n",   
   "STRATEGY: ",strategy==Grid?(reverse==Yes?"GRID (Reversed)":"GRID"):(zonereverse==Yes?"ZONE RECOVERY (Reversed)":"ZONE RECOVERY")
   );
  
  setStops();
  zoneSetStops();
  
  
  
  
  //LABELS
  
  ObjectCreate("profit",OBJ_LABEL,0,0,0,0,0,0,0);
  ObjectCreate("equity",OBJ_LABEL,0,0,0,0,0,0,0);
  ObjectCreate("percent",OBJ_LABEL,0,0,0,0,0,0,0);
  ObjectSet("profit",OBJPROP_CORNER,CORNER_LEFT_LOWER);
  ObjectSet("equity",OBJPROP_CORNER,CORNER_LEFT_LOWER);
  ObjectSet("percent",OBJPROP_CORNER,CORNER_LEFT_LOWER);
  float totalprofit=AccountEquity()-fixedequity;
  float tzprofit=totalprofit*2000;
  int initialequity=fixedequity*2000;
  int percent=(tzprofit/initialequity)*100;
  
  ObjectSet("equity",OBJPROP_YDISTANCE,75);
  ObjectSet("percent",OBJPROP_YDISTANCE,10);
  ObjectSetText("equity","Deposit (tzs): "+initialequity,20,NULL,Blue);
  if(tzprofit>0)
    {
     ObjectSetText("profit","  Profit   (tzs): "+tzprofit,20,NULL,Blue);
     ObjectSetText("percent","  % Profit: "+percent+"%",20,NULL,Blue);
    }else
       {
        ObjectSetText("profit","  Profit   (tzs): "+tzprofit,20,NULL,Red);
        ObjectSetText("percent","  % Profit: "+percent+"%",20,NULL,Red);
       }
  
  

    /*
    if(upstops>=maxstops || downstops>=maxstops)
    {
     closeall();
     start();
    }
    
   */
  
}

//+------------------------------------------------------------------+