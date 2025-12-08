module raffle::raffle;

use sui::coin::Coin;
use sui::sui::SUI;

const ERR_RAFFLE_CLOSED: u64 = 1;
const ERR_INSUFFICIENT_FOUND: u64 = 2;
const ERR_EMPTY_POT: u64 = 3;

public struct Raffle has key, store {
    id: UID,
    owner: address,
    title: vector<u8>,
    ticket_price: u64,
    tickets: vector<ID>,
    winner_ticket: option::Option<ID>,
    pot: vector<Coin<SUI>>
}

public fun create(title: vector<u8>, ticket_price: u64, ctx: &mut TxContext) {
    let raffle = Raffle {
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        title,
        ticket_price,
        tickets: vector::empty(),
        winner_ticket: option::none<ID>(),
        pot: vector::empty<Coin<SUI>>()
    };

    transfer::public_transfer(raffle, tx_context::sender(ctx))
}

public fun buy_ticket(raffle: &mut Raffle, mut payment: Coin<SUI>, ctx: &mut TxContext) {
    // validate if the raffle is opened
    assert!(option::is_none(&raffle.winner_ticket), ERR_RAFFLE_CLOSED);

    // validate if the payment is sufficient
    assert!(sui::coin::value(&payment) >= raffle.ticket_price, ERR_INSUFFICIENT_FOUND);

    let sender_address = tx_context::sender(ctx);

    // add the ticket payment to the pot
    let ticket_payment = sui::coin::split(&mut payment, raffle.ticket_price, ctx);
    vector::push_back(&mut raffle.pot, ticket_payment);

    // refund user if sent more than ticket_price
    transfer::public_transfer(payment, sender_address);

    let ticket = raffle::ticket::create(ctx, object::id(raffle), sender_address);
    
    vector::push_back(&mut raffle.tickets, object::id(&ticket));
    transfer::public_transfer(ticket, sender_address);
}
