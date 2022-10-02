// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Voting is ERC20 {

    struct Voters {
        address voter;
        bool hasToken;
        bool voted;
    }
    struct Proposal {
        uint id;
        uint voteCount;
    }

    //address public chairperson;

    mapping(address => Voters) private voters;

    Proposal[] public proposals;
    
     address private owner;
    //uint    total;
    address private holder;


    constructor() ERC20("GordonToken", "GTO") {
        owner =  msg.sender;
        holder = 0x0000000000000000000000000000000000000000;

        _mint(owner, 1000 * 10 ** 18);

        for(uint i = 1; i <=3 ;i++){
         proposals.push(Proposal({
                id: i,
                voteCount: 0
            }));
        } 

    }

    function newApplicant() public {
        require(holder == 0x0000000000000000000000000000000000000000, "processing still underway");
        require(holder != owner, "owner can't apply again");
        holder = msg.sender;
    }

    function seeApplicant() public view returns (address) {
        require(msg.sender == owner, "not autorized to use this function");
        return holder;

    }
    
    function autorize() public {
        address n;
        require (msg.sender == owner, "not autorized to use this function");
        require (holder != 0x0000000000000000000000000000000000000000, "no applicatant");
        n = holder;
        voters[n].voter = n;
        _transfer(owner, voters[n].voter, 100);
        //_transfer(owner, voters[voter2].voter, 100);
       // _transfer(owner, voters[voter3].voter, 100);
    }

    function reset() public  {
        require(msg.sender == owner, "not autorized to use this function");
        holder = 0x0000000000000000000000000000000000000000;
    }

     function vote(uint proposal) public {
        Voters storage sender = voters[msg.sender];
        require(balanceOf(sender.voter) != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += 1;
    }

    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }




}
