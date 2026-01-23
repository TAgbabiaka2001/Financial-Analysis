# import necessary libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import certifi
import yfinance as yf
import datetime as dt

from curl_cffi import requests # Requires 'pip install curl_cffi'

# Use a session with SSL verification disabled
with requests.Session(impersonate="chrome") as session:
    session.verify = False 
    ticker = yf.Ticker("MSFT", session=session)
    print(ticker.info)

# Define the stock tickers and date range
Stocks = ['SPY', 'GLD', 'VOO', 'VTI', 'QQQ']
endDate = dt.datetime(2025,12,31)
startDate = endDate - dt.timedelta(days=365*5)

# Download historical data for the defined stocks
etf_portfolio = yf.download(tickers=Stocks, start = startDate, end = endDate)

# Calculate log returns (daily returns) and plot them
etf_portfolio_Close = etf_portfolio['Close']
etf_portfolio_returns = np.log(etf_portfolio_Close / etf_portfolio_Close.shift(1))
plt.plot(etf_portfolio_returns)

# Calculate cumulative returns and plot them
etf_portfolio_Cum_returns = etf_portfolio_returns.cumsum()
etf_portfolio_Cum_returns.plot(title='Cumulative Returns of ETF Portfolio', figsize=(10,6))

# Create columns for $1000 investment in each ETF and total investment value
etf_portfolio['GLD_Investment'] = 1000 * np.exp(etf_portfolio_returns['GLD'].fillna(0).cumsum())
etf_portfolio['SPY_Investment'] = 1000 * np.exp(etf_portfolio_returns['SPY'].fillna(0).cumsum())
etf_portfolio['VOO_Investment'] = 1000 * np.exp(etf_portfolio_returns['VOO'].fillna(0).cumsum())
etf_portfolio['VTI_Investment'] = 1000 * np.exp(etf_portfolio_returns['VTI'].fillna(0).cumsum())
etf_portfolio['QQQ_Investment'] = 1000 * np.exp(etf_portfolio_returns['QQQ'].fillna(0).cumsum())
etf_portfolio['Total_Investment'] = (etf_portfolio['GLD_Investment'] + etf_portfolio['SPY_Investment'] +
                                    etf_portfolio['VOO_Investment'] + etf_portfolio['VTI_Investment'] +
                                    etf_portfolio['QQQ_Investment'])
print(etf_portfolio[['GLD_Investment', 'SPY_Investment', 'VOO_Investment', 'VTI_Investment', 'QQQ_Investment', 'Total_Investment']])