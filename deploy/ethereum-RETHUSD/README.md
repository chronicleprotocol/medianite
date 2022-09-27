# Median - rETH (RocketPool)

## Mainnet deploy

[0xf86360f0127f8a441cfca332c75992d1c692b3d1](https://etherscan.io/address/0xf86360f0127f8a441cfca332c75992d1c692b3d1)

`Circuit` [0xa3105dee5ec73a7003482b1a8968dc88666f3589](https://etherscan.io/address/0xa3105dee5ec73a7003482b1a8968dc88666f3589#code)

## Goerli deploy

[0x7eEE7e44055B6ddB65c6C970B061EC03365FADB3](https://goerli.etherscan.io/address/0x7eEE7e44055B6ddB65c6C970B061EC03365FADB3#code)

`Circuit` [0x1830b6f64f9b7d21e419bf3806d5fbe9f5476e42](https://goerli.etherscan.io/address/0x1830b6f64f9b7d21e419bf3806d5fbe9f5476e42#code)


## Notes

The `Circuit` contract is a simple DSValue used to check whether the value returned from the RocketPool contract is within a range (percent) of the market value of `rETH`. The value is set initially to [10%](https://etherscan.io/tx/0xad235a9414652c0d4d7baad1f3395564968dda769ba18591fc99a07f23790e6d).

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
