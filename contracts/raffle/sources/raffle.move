module raffle::raffle;

use std::string::String;

public struct Raffle has key, store {
    id: UID,
    owner: address,
    title: String,
    ticket_price: u128, // Price as MIST
    winner_ticket: option::Option<ID>
}

public fun create(ctx: &mut TxContext, title: String, ticket_price: u128): Raffle {
    let raffle = Raffle {
        id: object::new(ctx),
        owner: tx_context::sender(ctx),
        title,
        ticket_price,
        winner_ticket: option::none<ID>()
    };

    return raffle
}
