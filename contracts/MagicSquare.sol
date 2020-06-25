pragma solidity >=0.5.6;

pragma experimental ABIEncoderV2;

library SquareLib {
  struct MagicSquare {
    uint256[][] rows;
    uint256 n;
  }

  function initialize(uint256 n)
    external
    pure
    returns (MagicSquare memory square)
  {
    uint256 i;

    square = MagicSquare({
      rows: new uint256[][](n),
      n: n
    });

    for (i = 0; i < n; i++) {
      square.rows[i] = new uint256[](n);
    }
  }

  function step(
    MagicSquare memory square,
    uint256 x,
    uint256 y,
    uint256 i
  )
    internal
    pure
    returns (
      uint256 newX,
      uint256 newY,
      uint256 lastI
    )
  {
    if (square.rows[x][y] != 0) {
      newX = (x + 2) % square.n;
      newY = (square.n + y - 1) % square.n;
      lastI = i - 1;
      return (newX, newY, lastI);
    }

    square.rows[x][y] = i;
    newX = (square.n + x - 1) % square.n;
    newY = (y + 1) % square.n;
    lastI = i;
    return (newX, newY, lastI);
  }
}



contract MagicSquare {
  using SquareLib for SquareLib.MagicSquare;

  SquareLib.MagicSquare storedSquare;
  string storedGreeting;

  function generateMagicSquare(uint n)
    public
  {
    string memory greeting;
    SquareLib.MagicSquare memory square;
    uint256 x;
    uint256 y;
    uint256 i;

    greeting = "let us construct a magic square:";
    square = SquareLib.initialize(n);

    x = 0;
    y = n / 2;
    for (i = 1; i <= n * n; i++) {
      (x, y, i) = square.step(x, y, i);
    }

    this.save(square);
    storedGreeting = "finally, a decentralized magic square service!";
  }

  function getSquare()
    public
    view
    returns (SquareLib.MagicSquare memory square)
  {
    return storedSquare;
  }

  function save(SquareLib.MagicSquare memory square)
    public
  {
    uint256 x;
    uint256 y;

    storedSquare.n = square.n;
    storedSquare.rows.length = square.n;

    for (x = 0; x < square.n; x++) {
      storedSquare.rows[x].length = square.n;

      for (y = 0; y < square.n; y++) {
        storedSquare.rows[x][y] = square.rows[x][y];
      }
    }
  }
}
