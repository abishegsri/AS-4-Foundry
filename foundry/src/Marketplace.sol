pragma solidity ^0.8.14;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Marketplace is ERC1155,Ownable
{
    mapping (bytes32 => mapping (address=>bool)) public roles;
    uint256 public constant Tier1 = 1;
    uint256 public constant Tier2 = 2;
    uint256 public constant Tier3 = 3;
    uint256 public constant Tier4 = 4;
    uint256 public constant Tier5 = 5;
    uint public constant mintingLimit=20;
    bytes32 private constant MINTER = keccak256(abi.encode("MINTER")) ;
    constructor(string memory _apiEndPoint) public ERC1155(_apiEndPoint) 
    {
        setInitialPrice();
    }
    function grantMinterRole(address _add) public onlyOwner 
    {
        roles[MINTER][_add]=true;
    }
    mapping (uint=>uint) public tiertovalue;
    function setInitialPrice() private 
    {
        tiertovalue[1]=2e18;
        tiertovalue[2]=1e18;
        tiertovalue[3]=75e16;
        tiertovalue[4]=5e17;
        tiertovalue[5]=1e17;
    }
    function mintToken(uint _tierNumber,uint _nooftokens) public payable 
    {
        uint totalamount=tiertovalue[_tierNumber]*_nooftokens;
        require((balanceOf(msg.sender, _tierNumber)+_nooftokens)<=mintingLimit,"you have reached the minting Limit");
        require(roles[MINTER][msg.sender],"You are not the minter");
        require(msg.value==totalamount,"Required Amount is not paid");
        _mint(msg.sender, _tierNumber, _nooftokens, "");
    }
    function burnToken(uint _tierNumber,uint _nooftokens) public 
    {
        require(roles[MINTER][msg.sender],"You are not the minter");
        require(balanceOf(msg.sender, _tierNumber)>=_nooftokens,"You do not have enough tokens");
        (bool sent,)=payable (msg.sender).call{value:5e16*(_nooftokens)}("");
        _burn(msg.sender, _tierNumber, _nooftokens);
    }
    function updateTokenPrice(uint tier1price,uint tier2price,uint tier3price,uint tier4price,uint tier5price) public onlyOwner
    {
        tiertovalue[1]=tier1price;
        tiertovalue[2]=tier2price;
        tiertovalue[3]=tier3price;
        tiertovalue[4]=tier4price;
        tiertovalue[5]=tier5price;
    }
}
