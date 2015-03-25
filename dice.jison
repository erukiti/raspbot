%lex
%%

\s+                   /* skip whitespace */
"0x"[0-9a-fA-F]+\b    return 'NUMBER'
[0-9]{1,2}d[0-9]{1,3} return 'DICE'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"%"                   return '%'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%start expressions

%% /* language grammar */

expressions
    : e EOF { return $1; }
    ;

e
    : e '+' e            {$$ = $1 + $3;}
    | e '-' e            {$$ = $1 - $3;}
    | e '*' e            {$$ = $1 * $3;}
    | e '/' e            {$$ = $1 / $3;}
    | e '%' e            {$$ = $1 % $3;}
    | '-' e %prec UMINUS {$$ = -$2;}
    | '(' e ')'          {$$ = $2;}
    | NUMBER             {$$ = Number($1);}
    | DICE               {{
                            matched = $1.match(/^([0-9]+)d([0-9]+)$/)
                            var acc = 0;
                            for (var i = 0; i < matched[1]; i++) {
                                acc += Math.floor(Math.random() * matched[2]) + 1;
                            }
                            $$ = acc;
                         }}
    ;
