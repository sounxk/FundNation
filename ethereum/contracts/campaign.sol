pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
        
    function createCampaign(uint minimum) public{
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]){
        return deployedCampaigns;
    }
}

contract Campaign {
    
    struct  Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    address public manager ;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    Request[] public requests;
    
    modifier restricted()  {
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address creator){
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) 
    public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }
    
    function approveRequest(uint requestIndex) public {
        Request storage theRequest = requests[requestIndex];
        require(approvers[msg.sender]);
        require(!theRequest.approvals[msg.sender]);
        theRequest.approvals[msg.sender] = true;
        theRequest.approvalCount++;
    }
    
    function finalizeRequest(uint requestIndex) public restricted {
        Request storage theRequest = requests[requestIndex];
        require(!theRequest.complete);
        require(theRequest.approvalCount > (approversCount / 2));
        theRequest.complete = true;
        theRequest.recipient.transfer(theRequest.value);
    }

    function getSummary() public view returns (
        uint,uint,uint,uint,address
    ) {
        return(
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}