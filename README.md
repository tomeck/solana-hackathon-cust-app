# solana-hackathon-cust-app
Simulated customer wallet iPhone app for the Solana DeFi Hackathon March 1 2021

# What it does
This fully native iPhone app simulates a consumer digital wallet.  The wallet holds USDC, can make instant payments at a merchant's Point of Sale, and can review a history of transactions.  Please refer to the repo tomeck/solana-hackathon-pos which contains a simulated Point of Sale terminal that accepts payments from this consumer wallet.

# How it works
The app integrates with the [Circle API's](https://developers.circle.com) to do the following:

1. Obtain the current balance of the consumer's soft wallet that is hosted at Circle.   NB: The wallet is setup for USDC only. The retrieval of the balance is done via a GET call to Circle's /wallets API 
2. Get a transaction history of the payments made from this app (only the 50 most recent transactions are displayable).  The retrieval of the transaction history is done via a GET call to Circle's /transfers API.
3. Make a payment of USDC to the merchant.  This is accomplished by scanning a QR code which encodes the following: address on the Solana network at which the merchant accepts USDC payments, the name of the merchant, and the invoice amount that the customer must pay.  After scanning the QR code, this data is extracted, and a transfer of USDC funds is initiated from the customer's USDC wallet to the Solana network.  This transfer is initiated via a POST call to the Circle /transfers API

## Tracking the payment (USDC transfer)
There are three ways to track the successful completion of the transfer:

1. **Within the app**, the user can tap the "Transactions" tab to see the transaction history.  The transactions are sorted in reverse-chronological order, hence the topmost entry will reflect the current transfer in progress.  You will notice that the transaction is initially in the *pending* state.  You can pull the list down to refresh it.   In a few seconds it will reflect the *complete* status
2. You can also track the transaction via the **Solana blockchain explorer**.
