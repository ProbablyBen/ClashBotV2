const Config = require('../conf/main.json');
var str = 'test fuck';
var prof = checkMessage(str);
console.log(prof);

function checkMessage(msg)
{
    msg = msg.replace(/[^0-9a-z]/gi, '');
    this.check = 0;
    this.d_word = ""
    var arr = [];

    for (var i = 0; i < Config.Blacklist.length; i++)
    {
      var bWord = Config.Blacklist[i];
      var regex = new RegExp(bWord, 'gi');
      var check = msg.match(regex);
      if (check !== null)
      {
          this.d_word = bWord;
          this.check = 1;
      }
  }

  return [this.check, this.d_word];
}

function checkProfanity(msg)
{
    var bad_word = false;
    var d_word = "";
    var s_word = msg.split(' ');

    for (var word in s_word)
    {
        var word_clean = s_word[word].toLowerCase();

        for (badword in Config.Blacklist)
        {
            if (word == badword)
            {
                bad_word = true;
                d_word = badword
            }
        }
    }

    console.log(bad_word);
    console.log(d_word);
}
