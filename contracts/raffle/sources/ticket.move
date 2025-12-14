module raffle::ticket;

public struct Ticket has key, store {
    id: UID,
    raffle_id: ID
}

public fun create(ctx: &mut TxContext, raffle_id: ID): Ticket {
    Ticket {
        id: object::new(ctx),
        raffle_id
    }
}
