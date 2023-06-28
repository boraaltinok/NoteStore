import 'dart:math';

class QuotesUtility{
  var quotes = [
    ["“The person who deserves most pity is a lonesome one on a rainy day who doesn’t know how to read.”", "Benjamin Franklin"],
    ["“There is more treasure in books than in all the pirate’s loot on Treasure Island.”", "Walt Disney"],
    ["“Books are a uniquely portable magic.”", "Stephen King"],
    ["“The more that you read, the more things you will know. The more that you learn, the more places you’ll go.”", "Dr. Seuss"],
    ["“I guess there are never enough books.”", "John Steinbeck"],
    ["“If you don’t like to read, you haven’t found the right book.”", "J.K. Rowling"],
  ];

  List selectRandomQuote(){
    var random = Random();
    var index = random.nextInt(quotes.length);

    return quotes[index];

  }
}
