// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bank {

    /*///////////////////////////////////////////////////////////////
                    Global STATE
    //////////////////////////////////////////////////////////////*/
    
    address private admin;

    IERC20 public token;
    address private dusty = 0x686c626E48bfC5DC98a30a9992897766fed4Abd3;

    mapping (address => Action[])   public activities;
    mapping (address => uint256)    public staked;
    
    uint256 public totalStaked;
    uint256 public earlyRemoved;
    
    /*///////////////////////////////////////////////////////////////
                DATA STRUCTURES 
    //////////////////////////////////////////////////////////////*/

    enum   Actions { UNSTAKED, FARMING }
    struct Action  {
        address NFTAddress;
        uint256 NFTId;
        string hash;
        string name;
        uint256 timestamp;
        uint256 percent;
        uint256 reward; 
        uint256 amount;
        Actions action; 
    }

    /*///////////////////////////////////////////////////////////////
                    CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor()  {
        admin = msg.sender;
        token = IERC20(dusty);
    }



    /*///////////////////////////////////////////////////////////////
                    PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
 
    function stakebyHash(string memory hashx, string memory namex, address tokenAddress, uint256 tokenId, uint256 amount) external {

        require(amount <= token.balanceOf(msg.sender), "NE"); // MsgSender's balance must be larger than amount
        require(amount >= 10 * 10**18 && amount <= 1000 * 10**18, "IN"); //Amount must be in this range(10~1000)
        
        //////////////////// Calculate the percent and reward from the amount ////////////////////////
        uint256 reward;
        uint256 percent;

        if (amount >=  10 * 10**18  &&  amount <  20 * 10**18) { percent = 10; reward = amount * 110/100; }
        if (amount >=  20 * 10**18  &&  amount <  30 * 10**18) { percent = 12; reward = amount * 112/100; }
        if (amount >=  30 * 10**18  &&  amount <  50 * 10**18) { percent = 15; reward = amount * 115/100; }
        if (amount >=  50 * 10**18  &&  amount < 100 * 10**18) { percent = 20; reward = amount * 120/100; }
        if (amount >= 100 * 10**18  &&  amount < 500 * 10**18) { percent = 25; reward = amount * 125/100; }
        if (amount >= 500 * 10**18  &&  amount < 800 * 10**18) { percent = 35; reward = amount * 135/100; }
        if (amount >= 800 * 10**18  &&  amount <1000 * 10**18) { percent = 42; reward = amount * 142/100; }
        if (amount == 1000* 10**18 )                           { percent = 50; reward = amount * 150/100; }

         
        uint256 stakeTime = block.timestamp; //Set the staking start time to count 1 year(delay time)
        IERC721(tokenAddress).transferFrom(msg.sender, address(this), tokenId);// Send NFTs from Owner to this contract Address
        token.transferFrom(msg.sender, address(this), amount); // You have to pay the $Dusty token to stake the NFTs

        //Set the mapping activities[address][cid] to its own Action which has tokenAddress, tokenId, hash, staketime, reward, and action
        activities[msg.sender].push(Action({NFTAddress:tokenAddress, NFTId:tokenId, hash:hashx, name:namex, timestamp:stakeTime, percent:percent, reward:reward, amount:amount, action: Actions.FARMING}));
        
        staked[msg.sender]++; // Increase the number of Staked NFT for each user

        totalStaked++; // Increase the total staked NFTs

    }

    function autoClaim(address addr, uint256 cid) external {
        require(activities[addr][cid].timestamp + 365 days < block.timestamp, "NT"); //This NFT is automatically Claim by its Hash

        Action memory act = activities[addr][cid]; // Get the Action form the Address and Cid
        
        // To save the gas, we use new variables in this function
        address tokenAddress = act.NFTAddress;
        uint256 rwd = act.reward;
        uint256 tokenId = act.NFTId;

        IERC721(tokenAddress).transferFrom(address(this), addr, tokenId); // Resend the NFT to its owner
        token.transfer(addr, rwd); // Pay for the owner the reward

        //Set the mapping activities[address][cid] to its own Action which has tokenAddress, tokenId, hash, staketime, reward, and action
        activities[addr][cid] = Action({NFTAddress:tokenAddress, NFTId:tokenId, hash:"", name: "", timestamp:0, percent:0, reward:0, amount:0, action: Actions.UNSTAKED});
        
        totalStaked--;  // Decrease the total staked NFTs
    }

    function unStake(address addr, uint256 cid) external {

        Action memory act = activities[addr][cid];// Get the Action form the Hash
        
        // To save the gas, we use new variables in this function
        address tokenAddress = act.NFTAddress;
        uint256 tokenId = act.NFTId;

        IERC721(tokenAddress).transferFrom(address(this), addr, tokenId); //Only resend the NFT to its owner

        //Set the mapping activities[address][cid] to its own Action which has tokenAddress, tokenId, hash, staketime, reward, and action
        activities[addr][cid] = Action({NFTAddress:tokenAddress, NFTId:tokenId, hash:"", name:"", timestamp:0, percent:0, reward:0, amount:0, action: Actions.UNSTAKED});
        
        totalStaked--;  // Decrease the total staked NFTs
        
        earlyRemoved++; // Increase the number of early removed NFTs
    }

    ////////////////////////////////////////////
    //              WithDraw Mode             //
    ////////////////////////////////////////////
    modifier onlyAdmin{
        require(admin == msg.sender, "OA");
        _;
    }

    function setNewAdmin(address newAdd) external onlyAdmin{
        admin = newAdd;
    }

    function withdraw() external onlyAdmin{
        uint256 amount = token.balanceOf(address(this));
        token.transfer(msg.sender, amount);
    }

}
