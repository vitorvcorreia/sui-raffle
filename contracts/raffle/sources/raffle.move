module raffle::raffle;

use sui::coin::Coin;
use sui::sui::SUI;
use raffle::ticket::Ticket;

const ERR_RAFFLE_CLOSED: u64 = 1;
const ERR_INSUFFICIENT_FOUND: u64 = 2;

public struct Raffle has key, store {
    id: UID,
    owner: address,
    title: vector<u8>,
    ticket_price: u64, // Price as MIST
    winner_ticket: option::Option<ID>,
    pot: vector<Coin<SUI>>
}

public fun create(title: vector<u8>, ticket_price: u64, ctx: &mut TxContext): Raffle {
    let raffle = Raffle {
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        title,
        ticket_price,
        winner_ticket: option::none<ID>(),
        pot: vector::empty<Coin<SUI>>()
    };

    return raffle
}

public fun buy_ticket(raffle: &mut Raffle, mut payment: Coin<SUI>, ctx: &mut TxContext): Ticket {
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
    return ticket
}
