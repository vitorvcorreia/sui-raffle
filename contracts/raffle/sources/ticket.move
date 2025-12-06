module raffle::ticket;

public struct Ticket has key {
    id: UID,
    raffle_id: ID,
    owner: address
}

public fun create(ctx: &mut TxContext, raffle_id: ID, owner: address): Ticket {
    Ticket {
        id: object::new(ctx),
        raffle_id,
        owner
    }
}
