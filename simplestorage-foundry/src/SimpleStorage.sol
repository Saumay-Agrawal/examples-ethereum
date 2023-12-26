// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract SimpleStorage {

    uint256 public favoriteNumber;
    uint256[] public listFavoriteNumber;
    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    Person public saumay = Person("Saumay", 99);

    Person[] public people;

    mapping(string => uint256) public peoplemap;


    function store(uint256 _favoriteNumber) public virtual  {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve () public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson (string memory _name, uint256 _favoriteNumber ) public {
        people.push(Person(_name, _favoriteNumber));
        peoplemap[_name] = _favoriteNumber;
    }

}




