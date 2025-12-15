[🇧🇷 Ver em Português](./README_PTBR.md)

# 🎟️ Raffle Smart Contract (Sui Move)

This project implements a **simple on-chain raffle** using the **Move language on the Sui blockchain**.  
Users can buy tickets, and the raffle creator can close the raffle, randomly select a winner, and distribute the collected funds automatically.

---

## 📌 Overview

- Each raffle is represented by a `Raffle` object
- Users buy tickets by paying SUI
- Tickets are stored as indexed entries in a table
- When the raffle is closed, a winner is selected randomly
- The total pot is split between:
  - the raffle owner
  - the winner

This project is **for educational purposes only**.

---

## 🧱 Architecture

### Raffle Object
The `Raffle` struct stores:
- Raffle metadata (title, owner)
- Ticket price
- Number of tickets sold
- A table mapping ticket indices to buyer addresses
- The accumulated pot stored as `Balance<SUI>`
- The winning ticket index (after the raffle ends)

### Tickets
Tickets are represented only by an **index and the buyer address**.  
No Ticket NFT or object is created to keep the implementation simple and cost-efficient.

---

## 🔁 Raffle Flow

1. The creator deploys a raffle
2. Users buy tickets by sending SUI
3. The collected value is added to the raffle pot
4. The creator closes the raffle
5. A random ticket index is selected
6. The pot is distributed to the owner, and winner

---

## 🔐 Security Notes & Limitations

- The random number generation used is **not secure for production**
- The raffle must be closed manually by the owner
- No refund mechanism is implemented
- This project is intended for learning purposes only

---

## 🚀 Possible Improvements

- Secure randomness (commit–reveal, VRF, or beacon-based RNG)
- Admin capability for governance
- Ticket NFTs for transferability
- Automatic raffle closing based on time or epoch

## Runnig the project 

### 1. Publish the Package

Publish your Raffle Move package to the Sui network:

```bash
sui client publish
```

This will deploy the package and give you the `PACKAGE_ID` for the next steps.

---

### 2. Create a Raffle

Create a new raffle with a title and ticket price:

```bash
sui client call --package [PACKAGE_ID] --module raffle --function create --args [RAFFLE_TITLE] [TICKET_PRICE_MINT]
```

- RAFFLE_TITLE: Name of your raffle (string)
- TICKET_PRICE_MINT: Ticket price in MIST (u64)

---

### 3. Buy Tickets

Users can buy tickets for the raffle using a SUI coin:

```bash
sui client call --package [PACKAGE_ID] --module raffle --function buy_ticket --args [RAFFLE_ID] [COIN_ID] --gas [GAS_COIN_ID] --gas-budget 10000000
```

- RAFFLE_ID: ID of the raffle object
- COIN_ID: SUI coin used to pay for the ticket
- GAS_COIN_ID: SUI coin used to pay for gas (must be different from COIN_ID)

---

### 4. End the Raffle

The raffle owner can close the raffle, draw a winner, and distribute the pot:

```bash
sui client call --package [PACKAGE_ID] --module raffle --function end --args [RAFFLE_ID] [RANDOM] --gas [GAS_COIN_ID] --gas-budget 10000000
```

- RAFFLE_ID: ID of the raffle object
- RANDOM: Sui Random singleton (0x000000000000000000000000000000000000008)
- GAS_COIN_ID: SUI coin used to pay for gas

---

## 📚 Disclaimer

This project was developed as part of a **sui bootcamp** and is **not production-ready**.  
It is intended to demonstrate basic concepts of Move and Sui.
