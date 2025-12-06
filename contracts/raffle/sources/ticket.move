module raffle::ticket;

public struct Ticket has key {
    id: UID,
    raffle_id: ID
}
