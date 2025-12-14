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

---

## 📚 Disclaimer

This project was developed as part of a **sui bootcamp** and is **not production-ready**.  
It is intended to demonstrate basic concepts of Move and Sui.
