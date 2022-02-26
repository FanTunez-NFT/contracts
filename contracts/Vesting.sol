//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract VestingContract {
    using SafeERC20 for IERC20;

    IERC20 public immutable token;



    uint256 constant ONE_DAY = 1;
    uint256 constant ONE_MONTH = ONE_DAY*30;
    uint256 constant ONE_YEAR= ONE_MONTH*12;



    address public immutable gctGlobalWallet;
    address public immutable ecoSystemAndMarketingWallet;
    address public immutable operationWallet;
    address public immutable communityWallet;



    uint256 public totalGCTGlobalShare;
    uint256 public totalEcoSystemAndMarketingShare;
    uint256 public totalOperationShare;
    uint256 public totalCommunityShare;




    uint256 public gctGlobalClaimed;
    uint256 public ecoSystemAndMarketingClaimed;
    uint256 public operationClaimed;
    uint256 public communityClaimed;






    uint256 public gctGlobalNextClaim;
    uint256 public ecoSystemAndMarketingNextClaim;
    uint256 public operationNextClaim;
    uint256 public communityNextClaim;


    uint256 public totalTokensLocked;

    address public owner;

    bool public isInitialized;

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }



    constructor(
        IERC20 _token,
        address _gctGlobalWallet,
        address _ecoSystemAndMarketingWallet,
        address _operationWallet,
        address _communityWallet
    ) {
        token = _token;
        gctGlobalWallet = _gctGlobalWallet;
        ecoSystemAndMarketingWallet = _ecoSystemAndMarketingWallet;
        operationWallet = _operationWallet;
        communityWallet = _communityWallet;
        owner = msg.sender;
    }

    function initialize(uint256 _totalTokensLocked) public onlyOwner {
        require(!isInitialized, "Already Initialized");

        token.safeTransferFrom(msg.sender, address(this), _totalTokensLocked);
        totalTokensLocked = _totalTokensLocked;
        uint256 totalShare = 550;

        totalGCTGlobalShare = totalTokensLocked*250/totalShare;
        totalEcoSystemAndMarketingShare =totalTokensLocked*100/totalShare;
        totalOperationShare = totalTokensLocked*100/totalShare;
        totalCommunityShare = totalTokensLocked*100/totalShare;


        gctGlobalNextClaim = 0;

        ecoSystemAndMarketingNextClaim = 0;

        operationNextClaim=  0;
        communityNextClaim =0;



  

        isInitialized = true;
    }

    function currentlyLockedTokens() public view returns (uint256) {
        return token.balanceOf(address(this));
    }


    function claimGCTGlobalShare() public {
        require(msg.sender == gctGlobalWallet,"Not Authorized");
        require(totalGCTGlobalShare > gctGlobalClaimed ,"Claimed Full Share");
        require(gctGlobalNextClaim < block.timestamp ,"Vesting Period not passed");

        uint256 amount  = totalGCTGlobalShare/20;
        gctGlobalClaimed += amount;
        gctGlobalNextClaim = block.timestamp+ ONE_YEAR;
        token.safeTransfer(msg.sender, amount);

    }


    function claimEcoSystemAndMarketingShare() public {
        require(msg.sender == ecoSystemAndMarketingWallet,"Not Authorized");
        require(totalEcoSystemAndMarketingShare > ecoSystemAndMarketingClaimed ,"Claimed Full Share");
        require(ecoSystemAndMarketingNextClaim < block.timestamp ,"Vesting Period not passed");

        uint256 amount  = totalEcoSystemAndMarketingShare/60;
        ecoSystemAndMarketingClaimed += amount;
        ecoSystemAndMarketingNextClaim = block.timestamp+ ONE_MONTH;
        token.safeTransfer(msg.sender, amount);

    }


    function claimOperationShare() public {
        require(msg.sender == operationWallet,"Not Authorized");
        require(totalOperationShare > operationClaimed ,"Claimed Full Share");
        require(operationNextClaim < block.timestamp ,"Vesting Period not passed");

        uint256 amount  = totalOperationShare/60;
        operationClaimed += amount;
        operationNextClaim = block.timestamp+ ONE_MONTH;
        token.safeTransfer(msg.sender, amount);

    }


    function claimCommunityShare() public {
        require(msg.sender == communityWallet,"Not Authorized");
        require(totalCommunityShare > communityClaimed ,"Claimed Full Share");
        require(communityNextClaim < block.timestamp ,"Vesting Period not passed");

        uint256 amount  = totalCommunityShare/60;
        communityClaimed += amount;
        communityNextClaim = block.timestamp+ ONE_MONTH;
        token.safeTransfer(msg.sender, amount);

    }
}
