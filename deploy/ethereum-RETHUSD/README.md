# Median - rETH (RocketPool)

## Mainnet deploy

TBD

## Goerli deploy

[0x7eEE7e44055B6ddB65c6C970B061EC03365FADB3](https://goerli.etherscan.io/address/0x7eEE7e44055B6ddB65c6C970B061EC03365FADB3#code)

The `Circuit` contract

[0x1830b6f64f9b7d21e419bf3806d5fbe9f5476e42](https://goerli.etherscan.io/address/0x1830b6f64f9b7d21e419bf3806d5fbe9f5476e42#code)

which is a simple DSValue used to check whether the value returned from the RocketPool contract is within a range (percent) of the market value of `rETH`. The value is set initially to [10%](https://goerli.etherscan.io/tx/0x284a34725fcb466dd7ac64585163f48aab95ff08dfc45772f05f3b73b36b3a77).

NOTE the contract above allows for 5 decimal places of precision. E.g. 

```       
10000/(10^5)  = 0.10000
99999/(10^5)  = 0.99999
100000/(10^5) = 1.00000
```

To compute a percentage (10%) from the contract you could do some Bash like:

```
cast send $CONTRACT 'poke(bytes32)' $(cast --to-uint256 10000) && \
val=$(cast --to-dec $(cast call $CONTRACT 'read()')) && \
div=$(cast --to-dec $(cast call $CONTRACT 'divisor()')) && \
echo "scale=5; $val / $div" | bc -l

.10000
```
