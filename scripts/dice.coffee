# Commands:
#   <m>d<n> - ダイス振る ex. 3d6 + 1d10 + 3

jison = require 'jison'

dice = (text) ->
  matched = text.split('d')
  return 0 if matched[0] == '0' || matched[1] == '0'

  acc = 0
  for i in [0...matched[0]]
    acc += Math.floor(Math.random() * matched[1]) + 1
  acc

grammer = 
  "lex":
    "rules": [
      ["\\s+",                    "/* skip whitespace */"]
      ["0x[0-9a-fA-F]+\\b",       "return 'NUMBER';"]
      ["[0-9]{1,2}d[0-9]{1,3}",   "return 'DICE';"]
      ["[0-9]+(\\.[0-9]+)?([eE][\\+\\-]?[0-9]+)?\\b", "return 'NUMBER';"]
      ["\\/",                     "return '/';"]
      ["\\*",                     "return '*';"]
      ["-",                       "return '-';"]
      ["\\+",                     "return '+';"]
      ["\\%",                     "return '%';"]
      ["\\(",                     "return '(';"]
      ["\\)",                     "return ')';"]
      [">=",                      "return '>=';"]
      ["<=",                      "return '>=';"]
      ["==",                      "return '==';"]
      ["=",                       "return '=';"]
      [">",                       "return '>';"]
      ["<",                       "return '<';"]
      ["$",                       "return 'EOF';"]
    ]
  "operators": [
    ["left", ">=", "<=", ">", "<", "="]
    ["left", "+", "-"]
    ["left", "*", "/", "%"]
    ["left", "UMINUS"]
  ]
  "bnf":
    "expressions": [
      ["b EOF", "return $1;"]
      ["n EOF", "return $1;"]
    ]

    "b" : [
      ["n >= n",   "$$ = $1 >= $3;"]
      ["n <= n",   "$$ = $1 <= $3;"]
      ["n = n",    "$$ = $1 == $3;"]
      ["n > n",    "$$ = $1 > $3;"]
      ["n < n",    "$$ = $1 < $3;"]
      ["( b )",    "$$ = $2;"]
    ]
    "n" : [
      [ "n + n",   "$$ = $1 + $3;" ]
      [ "n - n",   "$$ = $1 - $3;" ]
      [ "n * n",   "$$ = $1 * $3;" ]
      [ "n / n",   "$$ = $1 / $3;" ]
      [ "n % n",   "$$ = $1 % $3;" ]
      [ "- n",     "$$ = -$2;", {"prec": "UMINUS"} ]
      [ "( n )",   "$$ = $2;" ]
      ["NUMBER",   "console.dir(Number(yytext)); $$ = Number(yytext);"]
      ["DICE",     "$$ = dice(yytext);"]
    ]
  "actionInclude": "dice = #{dice};"

parser = new jison.Parser(grammer)

module.exports = (robot) ->
  robot.hear /^([0-9a-fA-Fdx()+\-*\/%>=<\. \t]+)(\bin hex)?$/i, (msg) ->
    expr = msg.match[1]
    console.dir expr
    if msg.match[2] == 'in hex'
      base = 16
      prefix = '0x'
    else
      base = 10
      prefix = ''
    rolled = parser.parse(expr)
    msg.send prefix + rolled.toString(base) if expr.trim().toLowerCase() != prefix + rolled.toString(base).toLowerCase()
