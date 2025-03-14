module StableCoin::StableCoin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::balance::Balance;

    /// StableCoin metadata
    const SYMBOL: &str = "USDM";
    const NAME: &str = "USD Move Stablecoin";
    const DECIMALS: u8 = 6;

    /// Struct representing the stablecoin.
    struct USDM has store, drop {}

    /// Initialize the StableCoin and mint initial supply
    public entry fun init(
        initial_supply: u64,
        ctx: &mut TxContext
    ): (TreasuryCap<USDM>, Coin<USDM>) {
        coin::initialize<USDM>(NAME, SYMBOL, DECIMALS, ctx);
        coin::mint<USDM>(initial_supply, ctx)
    }

    /// Mint new stablecoins (requires TreasuryCap)
    public entry fun mint(
        cap: &TreasuryCap<USDM>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let new_coins = coin::mint_with_cap<USDM>(cap, amount, ctx);
        transfer::transfer(new_coins, recipient);
    }

    /// Burn stablecoins to reduce circulating supply
    public entry fun burn(
        coins: Coin<USDM>,
        ctx: &mut TxContext
    ) {
        coin::burn(coins, ctx);
    }

    /// Transfer stablecoins between users
    public entry fun transfer(
        coins: Coin<USDM>,
        recipient: address,
        ctx: &mut TxContext
    ) {
        transfer::transfer(coins, recipient);
    }

    /// Check the balance of stablecoins
    public fun balance(
        coins: &Coin<USDM>
    ): u64 {
        coin::value(coins)
    }
}
