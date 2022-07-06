/// value.sol - a value is a simple thing, it can be get and set

// Copyright (C) 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.4.23;

import 'ds-thing/thing.sol';

contract DSValue is DSThing {
    bool    has;
    bytes32 val;

    function peek() public view returns (bytes32, bool) {
        return (val,has);
    }
    function read() public view returns (bytes32) {
        bytes32 wut; bool haz;
        (wut, haz) = peek();
        require(haz, "haz-not");
        return wut;
    }
    function poke(bytes32 wut) public note auth {
        val = wut;
        has = true;
    }
    function void() public note auth {  // unset the value
        has = false;
    }
}

contract Circuit is DSValue {
    /*
       Allows for 5 decimal places of precision. E.g. 
            10000/(10^5)  = 0.10000
            99999/(10^5)  = 0.99999
            100000/(10^5) = 1.00000

       To compute a percentage (10%) from the contract you could do some Bash like:

            cast send $CONTRACT 'poke(bytes32)' $(cast --to-uint256 10000) && \
            val=$(cast --to-dec $(cast call $CONTRACT 'read()')) && \
            div=$(cast --to-dec $(cast call $CONTRACT 'divisor()')) && \
            echo "scale=5; $val / $div" | bc -l

            .10000
    */
    uint256 public constant divisor = 10 ** 5;
}
