//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./FanTuneZArtist.sol";

contract FanTuneZArtistFactory is Ownable {
    uint256 public totalArtists;
    event ArtistCreated(address artist, uint256 index);
 
    function createArtist(
             string memory _name,
        string memory _symbol,
        string memory _artistURI
    )  public onlyOwner{
   
        FanTuneZArtist artist = new FanTuneZArtist(_name,_symbol,_artistURI);
        artist.transferOwnership(msg.sender);
        emit ArtistCreated(address(artist),totalArtists);
        totalArtists = totalArtists+1;

    }
  
}
