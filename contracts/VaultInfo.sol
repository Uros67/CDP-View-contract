/**
 *Submitted for verification at Etherscan.io on 2020-11-03
*/

/**
 *Submitted for verification at Etherscan.io on 2019-12-25
*/

pragma solidity ^0.6.0;

import "hardhat/console.sol";

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }
    
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

contract Vat {
    struct Urn {
        uint256 ink;   
        uint256 art;   
    }

    struct Ilk {
        uint256 Art;   
        uint256 rate;  
        uint256 spot;  
        uint256 line;  
        uint256 dust;  
    }

    mapping (bytes32 => mapping (address => Urn )) public urns;
    mapping (bytes32 => Ilk)                       public ilks;
}

abstract contract Manager {
    function ilks(uint) public virtual view returns (bytes32);
    function owns(uint) public virtual view returns (address);
    function urns(uint) public virtual view returns (address);
}

abstract contract DSProxy {
    function owner() public virtual view returns (address);
}

contract VaultInfo is DSMath {
    Manager manager = Manager(0x5ef30b9986345249bc32d8928B7ee64DE9435E39);
    Vat vat = Vat(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
    
    function _getProxyOwner(address owner) external view returns (address userAddr) {
        DSProxy proxy = DSProxy(owner);
        userAddr = proxy.owner();
    }
    
    function getCdpInfo(uint _cdpId) external view
        returns (address urn, address owner, address userAddr, bytes32 ilk, uint collateral, uint debt, uint debtWithInterest) {
        
        ilk = manager.ilks(_cdpId);
        console.log("Ilks is:");
        console.logBytes32( ilk);
        urn = manager.urns(_cdpId);
        owner = manager.owns(_cdpId);
        userAddr = address(0);
        
        (, uint256 rate, , ,) = vat.ilks(ilk);


        try this._getProxyOwner(owner) returns (address user) {
            userAddr = user;
        } catch {}

        (collateral, debt) = vat.urns(ilk, urn);


        debtWithInterest= mul(debt, rate);
    }
}