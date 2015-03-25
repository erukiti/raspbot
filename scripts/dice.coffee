# Commands:
#   <m>d<n> - ダイス振る ex. 3d6 + 1d10 + 3

jison = require 'jison'

grammer = 
  "lex":
    "rules": [
      ["\\s+",                    "/* skip whitespace */"]
      ["0x[0-9a-fA-F]+\\b",       "return 'NUMBER';"]
      ["[0-9]{1,2}d[0-9]{1,3}",   "return 'DICE';"]
      ["[0-9]+(\\.[0-9]+)?\\b",   "return 'NUMBER';"]
      ["\\/",                     "return '/';"]
      ["\\*",                     "return '*';"]
      ["-",                       "return '-';"]
      ["\\+",                     "return '+';"]
      ["\\%",                     "return '%';"]
      ["\\(",                     "return '(';"]
      ["\\)",                     "return ')';"]
      ["$",                       "return 'EOF';"]
    ]
  "operators": [
    ["left", "+", "-"]
    ["left", "*", "/", "%"]
    ["left", "UMINUS"]
  ]
  "bnf":
    "expressions": [["e EOF", "return $1;"]]

    "e" : [
      [ "e + e",   "$$ = $1 + $3;" ]
      [ "e - e",   "$$ = $1 - $3;" ]
      [ "e * e",   "$$ = $1 * $3;" ]
      [ "e / e",   "$$ = $1 / $3;" ]
      [ "e % e",   "$$ = $1 % $3;" ]
      [ "- e",     "$$ = -$2;", {"prec": "UMINUS"} ]
      [ "( e )",   "$$ = $2;" ]
      ["NUMBER",   "$$ = Number(yytext);"]
      ["DICE",     "matched = $1.match(/^([0-9]+)d([0-9]+)$/)\n" +
                   "var acc = 0;\n" + 
                   "for (var i = 0; i < matched[1]; i++) {\n" +
                   "  acc += Math.floor(Math.random() * matched[2]) + 1;\n" +
                   "}\n" + 
                   "$$ = acc;\n"]
    ]

parser = new jison.Parser(grammer)

module.exports = (robot) ->
  robot.hear /^([0-9a-fA-Fdx()+\-*\/%\. \t]+)(\bin hex)?$/i, (msg) ->
    expr = msg.match[1]
    if msg.match[2] == 'in hex'
      base = 16
      prefix = '0x'
    else
      base = 10
      prefix = ''
    console.dir base
    rolled = parser.parse(expr)
    msg.send prefix + rolled.toString(base) if Number(expr) != rolled
