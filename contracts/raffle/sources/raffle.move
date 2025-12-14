module raffle::raffle;

use sui::coin::{Self, Coin};
use sui::sui::SUI;
use sui::balance::{Self, Balance};
use sui::table::{Self, Table};
use sui::random::{Self, Random};
use raffle::ticket;
use sui::random::new_generator;

const ERR_CLOSED_RAFFLE: u64 = 1;
const ERR_INSUFFICIENT_FOUND: u64 = 2;
const ERR_NOT_OWNER: u64 = 3;
const ERR_INSUFFICIENT_PARTICIPANTS: u64 = 4;

public struct Raffle has key, store {
    id: UID,
    owner: address,
    title: vector<u8>,
    ticket_price: u64,
    winner_ticket: option::Option<u64>,
    pot: Balance<SUI>,
    sold: u64,
    tickets: Table<u64, address>
}

public fun create(title: vector<u8>, ticket_price: u64, ctx: &mut TxContext) {
    let raffle = Raffle {
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        title,
        ticket_price,
        winner_ticket: option::none<u64>(),
        pot: balance::zero<SUI>(),
        sold: 0,
        tickets: sui::table::new<u64, address>(ctx)
    };

    transfer::share_object(raffle)
}

public fun buy_ticket(raffle: &mut Raffle, mut payment: Coin<SUI>, ctx: &mut TxContext) {
    // validate if the raffle is opened
    assert!(option::is_none(&raffle.winner_ticket), ERR_CLOSED_RAFFLE);

    // validate if the payment is sufficient
    assert!(sui::coin::value(&payment) >= raffle.ticket_price, ERR_INSUFFICIENT_FOUND);

    let sender_address = tx_context::sender(ctx);

    // create the ticket
    let ticket = ticket::create(ctx, object::id(raffle));

    // add the ticket payment to the pot
    let ticket_payment = coin::split(&mut payment, raffle.ticket_price, ctx);
    balance::join(&mut raffle.pot, coin::into_balance(ticket_payment));

    // refund user if sent more than ticket_price
    transfer::public_transfer(payment, sender_address);

    // save the ticket on the table and increase the counter
    let index = raffle.sold;
    table::add(&mut raffle.tickets, index, sender_address);
    raffle.sold = index + 1;

    transfer::public_transfer(ticket, sender_address);
}

public fun end(raffle: &mut Raffle, random: &Random, ctx: &mut TxContext) {
    // validate if the raffle is opened
    assert!(option::is_none(&raffle.winner_ticket), ERR_CLOSED_RAFFLE);

    // validate if the raffle has sold tickets
    assert!(raffle.sold > 1, ERR_INSUFFICIENT_PARTICIPANTS);

    // validate if it's being called by the owner
    assert!(tx_context::sender(ctx) == raffle.owner, ERR_NOT_OWNER);

    draw_winner(raffle, random, ctx);
    settle(raffle, ctx);
}

// This method of generating random number is not recomended for production.
// Instead, use one of the methods shared on this paper: 
// https://arxiv.org/pdf/2310.12305
fun draw_winner(raffle: &mut Raffle, random: &Random, ctx: &mut TxContext) {
    let mut generator = new_generator(random, ctx);
    let winner = random::generate_u64_in_range(&mut generator, 0, raffle.sold);

    raffle.winner_ticket = option::some(winner)
}

fun settle(raffle: &mut Raffle, ctx: &mut TxContext) {
    // get the pot
    let pot_balance = balance::withdraw_all(&mut raffle.pot);
    let mut pot_coin = coin::from_balance(pot_balance, ctx);
    let pot_value = coin::value(&pot_coin);

    // split the owner fee
    let owner_fee_value = pot_value * 5 / 100;
    let owner_fee = coin::split(&mut pot_coin, owner_fee_value, ctx);

    // get the winner_address
    let winner_index = *option::borrow(&raffle.winner_ticket);
    let winner_address = *table::borrow(&raffle.tickets, winner_index);

    // send fee and prize
    transfer::public_transfer(owner_fee, raffle.owner);
    transfer::public_transfer(pot_coin, winner_address);
}
