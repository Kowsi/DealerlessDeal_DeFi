pragma solidity ^0.5.0;

//import "https://github.com/kohshiba/ERC-X/blob/master/contracts/ERCX/Contract/ERCXFull.sol";


contract DealerlessRental {
    //constructor() ERCXFull("DealerlessRentals", "RENT") public {}
    address public owner;
    uint deposit;
    uint rent;
    address public tenant;
    string public house;
    struct LeasePeriod {
        uint fromTimestamp;
        uint toTimestamp;
    }
    
    enum State {Available, Created, Approved, Started, Terminated}
    State public state;
    LeasePeriod leasePeriod;
    
    modifier onlyTenant() {
        require (msg.sender != tenant, 'Not a Tenant!') ;
        _;
    }
    
    modifier inState(State _state) {
        require (state != _state, 'State is !');
        _;
    }
    
    constructor (address _owner, uint _rent, uint _deposit) public{
        owner = _owner;
        rent = _rent;
        deposit = _deposit;
        state = State.Available;
    }
    
    function isAvailable() inState(State.Available) view public returns(bool) {
        return true;
    }

    function createTenantRight(uint fromTimestamp, uint toTimestamp)  inState(State.Available) public {
        tenant = msg.sender;
        leasePeriod.toTimestamp = toTimestamp;
        leasePeriod.fromTimestamp = fromTimestamp;
        state = State.Created;
    }
    
    function setStatusApproved() public{
        require(owner != address(0x0), 'Property not available for rentals!');
        state = State.Created;
    }
    
    function confirmAgreement() inState(State.Created) onlyTenant public{
        state = State.Started;
    }

    function clearTenant() public{
        tenant = address(0x0);
    }
}