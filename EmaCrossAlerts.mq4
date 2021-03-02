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
datetime timeTicker = 0;
bool priceIsAbove5Ema = false;
bool priceIsAbove20Ema = false;
bool fiveEmaIsAboveTwentyEma = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   isBullishTrend = startIsBullishTrend;
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
      
      Comment(StringFormat("isBullishTrend: %G \npriceIsAbove5Ema: %G \npriceIsAbove20Ema: %G \nfiveEmaIsAboveTwentyEma: %G \nlastClosePrice : %G \nfiveEmaValue : %G \ntwentyEmaValue : %G ",isBullishTrend,priceIsAbove5Ema, priceIsAbove20Ema, fiveEmaIsAboveTwentyEma  , lastClosePrice, fiveEmaValue,twentyEmaValue ));
      
      if(isBullishTrend != startIsBullishTrend) //trend has changed
      {
         //Print("###Trend Change : lastClosePrice=" + lastClosePrice + " , fiveEmaValue=" + fiveEmaValue + ", twentyEmaValue =" + twentyEmaValue );
         Alert("Trend change on " + Symbol() + "Timeframe: " + Period());
         
      }
   }
   
   
  }
//+------------------------------------------------------------------+
