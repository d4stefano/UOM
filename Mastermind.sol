//https://en.wikipedia.org/wiki/Mastermind_(board_game)
pragma solidity ^0.4.24;

contract Mastermind
{
    
    struct attempts
    {
        uint[4] codebreakerAttempt;
        uint[4] result;
    }
    
    address codemaker;
    address codebreaker;
    uint256 stake;
    uint8 attemptsCount;
    uint[4] code;
    attempts[12] attemps;
    bool won = false;
    
    uint winnings;
    uint winningStake;
    
	  
    event comparing(uint refIndex, uint refVal, uint compareIndex, uint compareVal);
    event gameWon(uint attemptsCount);
    event gameLost();
    
    constructor(uint[4] secretCode, address opponent) public payable
    {
        require(msg.sender!=opponent, "The code maker cannot be the code breaker.");
        
        // 12 attempts max and 1 wei for transfers
        require(msg.value == 13 wei,"The code maker must deposit 13 wei to play the game.");
        
        codemaker = msg.sender;     
        codebreaker = opponent;
        stake = msg.value;
        code = secretCode;
        attemptsCount = 0;
        
        winnings = 0;
    }
    
    function getLastResultAttempts() public view returns(uint[4] lastResult){
        if (attemptsCount <=0 )
            return attemps[0].result;
        else
         return attemps[attemptsCount -1].result;
    }
    
    function getCodebreaker() public view returns(address){
        return codebreaker;
    }
    
    function getCodemaker() public view returns(address){
        return codemaker;
    }
    
    function getNumberfAttempts() public view returns(uint){
        return attemptsCount;
    }
    
    function isWon() public view returns(bool)
    {
         return won;
    }
    
    function attemptBreak(uint[4] attempt) public payable
    {
        require(codebreaker == msg.sender, "Only the code breaker can attempt to break the code.");
        require(msg.value == 1 wei, "Must deposit 1 wei to play for a turn.");
        require(!won,"Game ended already.");
        
        if (attemptsCount == 12)
        {
           won=true;
           emit gameLost();
           
           return;
        }
        
        attemps[attemptsCount].codebreakerAttempt = attempt;
        
        
        if (keccak256(abi.encode(code)) == keccak256(abi.encode(attempt)))
        {
            // Secret found;
            for (uint i=0; i<4;i++){
                attemps[attemptsCount].result[i] = 1;
            }
            winnings = (12 - (attemptsCount+1)); 
            winningStake = address(this).balance - winnings;
            
            won = true;
            emit gameWon(attemptsCount);
           
            return;
        }
        
        for (uint codeIndex=0; codeIndex<4;codeIndex++)
        {
            if (code[codeIndex] == attempt[codeIndex])
            {
                emit comparing(codeIndex, code[codeIndex],codeIndex, attempt[codeIndex]);
                attemps[attemptsCount].result[codeIndex] = 1;
            }
            else
            {
                for (uint attemptIndex=0; attemptIndex<4;attemptIndex++)
                {
                    emit comparing(codeIndex, code[codeIndex],attemptIndex, attempt[attemptIndex]);
                    
                    if (code[attemptIndex] == attempt[codeIndex])
                    {
                        attemps[attemptsCount].result[codeIndex] = 2;
                        break;
                    }
                }
                
            }
        }

        attemptsCount = attemptsCount + 1;
    }
    
     function withdrawWinnings() public {
         
        uint amountToTransfer = winnings;
         
        require(winnings != 0, "There is nothing to win as yet.");
        require(address(this).balance >= winnings, "There are not enough funds to transfer.");

        winnings = 0;

        msg.sender.transfer(amountToTransfer);
        selfdestruct(codebreaker);
    }
    
    function withdrawStake() public{
         uint amountToTransfer = winningStake;
       
         require(winningStake != 0, "There is nothing left.");
        require(address(this).balance >= winningStake, "There are not enough funds to transfer.");

        winningStake = 0;

        msg.sender.transfer(amountToTransfer);
    }
    
    function() public {
        revert("Please use the attemptBreak function");
    }
}