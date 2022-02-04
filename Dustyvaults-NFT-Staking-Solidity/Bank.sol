// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}


interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Bank {

    /*///////////////////////////////////////////////////////////////
                    Global STATE
    //////////////////////////////////////////////////////////////*/
    
    address private admin;

    IERC20 public token;
    address private dusty = 0xc6f82B6922Ad6484c69BBE5f0c52751cE7F15EF2;

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
        
        //staked[msg.sender]--; // Decrease the number of Staked NFT for each user    
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
        
        //staked[msg.sender]--; // Decrease the number of Staked NFT for each user    
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
