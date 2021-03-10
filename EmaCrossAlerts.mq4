//+------------------------------------------------------------------+
//|                                               EmaCrossAlerts.mq4 |
//|                                 Copyright 2020, Dollar Mavericks |
//|                                  https://www.dollarmavericks.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Dollar Mavericks"
#property link      "https://www.dollarmavericks.com"
#property version   "1.00"
#property strict


input bool startIsBullishTrend = false;
bool isBullishTrend = false;
bool higherTimeframeBrokeStructure = false;
datetime timeTicker = 0;
bool priceIsAbove5Ema = false;
bool priceIsAbove20Ema = false;
bool fiveEmaIsAboveTwentyEma = false;
int currentTimeframe = 0;
int higherTimeframe = 0;
double breakoutPrice = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   isBullishTrend = startIsBullishTrend;
   currentTimeframe = Period();
   higherTimeframe = getHigherTimeframe();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime currentTime = iTime(NULL,0,0);
   
   
   if(currentTime != timeTicker)
   {
      
      timeTicker = currentTime;
      double fiveEmaValue = iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,0);
      double twentyEmaValue = iMA(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,0);
      double lastClosePrice = iClose(NULL,0,0);
      double lastOpenPrice = iOpen(NULL,0,0);
      bool currentCandleIsBullish = lastClosePrice > lastOpenPrice;
      priceIsAbove5Ema = lastClosePrice >= fiveEmaValue;
      priceIsAbove20Ema = lastClosePrice >= twentyEmaValue;
      fiveEmaIsAboveTwentyEma = fiveEmaValue >= twentyEmaValue;
      
      isBullishTrend = (fiveEmaValue >= twentyEmaValue) && (lastClosePrice > twentyEmaValue);
      higherTimeframeBrokeStructure = startIsBullishTrend ? ( iLow(NULL,higherTimeframe,0) < iLow(NULL,higherTimeframe,1) && iClose(NULL,higherTimeframe,0) < iOpen(NULL,higherTimeframe,0) ) : (iHigh(NULL,higherTimeframe,0) > iHigh(NULL,higherTimeframe,1) && iClose(NULL,higherTimeframe,0) > iOpen(NULL,higherTimeframe,0) );
      
      Comment(StringFormat("higherTimeframeBrokeStructure: %G \nstartIsBullishTrend: %G \nisBullishTrend: %G \npriceIsAbove5Ema: %G \npriceIsAbove20Ema: %G \nfiveEmaIsAboveTwentyEma: %G \nCurrent Timeframe: %G ",higherTimeframeBrokeStructure,startIsBullishTrend,isBullishTrend,priceIsAbove5Ema, priceIsAbove20Ema, fiveEmaIsAboveTwentyEma  ,currentTimeframe ));
  
      if(higherTimeframeBrokeStructure && isBullishTrend != startIsBullishTrend) //trend has changed
      {
         //Print("###Trend Change : lastClosePrice=" + lastClosePrice + " , fiveEmaValue=" + fiveEmaValue + ", twentyEmaValue =" + twentyEmaValue );
         Alert("Trend change on " + Symbol() + "Timeframe: " + Period());
         
         if(breakoutPrice == 0 && ((startIsBullishTrend && currentCandleIsBullish) || ( !startIsBullishTrend && !currentCandleIsBullish )))
         {
            breakoutPrice = currentCandleIsBullish ? iLow(NULL,0,0) : iHigh(NULL,0,0);
         }
         
         if(breakoutPrice > 0)
         {
            if((startIsBullishTrend && Bid < breakoutPrice) || ( !startIsBullishTrend && Ask > breakoutPrice ))
            {
               Alert("Total Breakout on " + Symbol() + "Timeframe: " + Period());
            }
            
         }
         
      }
   }
   
   
  }
//+------------------------------------------------------------------+
int getHigherTimeframe()
{
   if(currentTimeframe == 1)
   {
      return 5;
   }
   
    if(currentTimeframe == 5)
   {
      return 15;
   }
   
    if(currentTimeframe == 15)
   {
      return 60;
   }
   
    if(currentTimeframe == 60)
   {
      return 240;
   }
   
    if(currentTimeframe == 240)
   {
      return 1440;
   }
   
   return currentTimeframe * 4;
}