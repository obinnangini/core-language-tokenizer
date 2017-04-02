# BNF for Core Language

1. `<prog>`	     ::= program `<decl seq>`*begin*`<stmt seq>` end
1. `<decl seq>`  ::= `<decl>` | `<decl>` `<decl seq>`
1. `<stmt seq>`  ::= `<stmt>` | `<stmt>` `<stmt seq>`
1. `<decl>`      ::=*int*`<id list>`;
1. `<id list>`	 ::=`<id>` | `<id>`, `<id list>`
1. `<stmt>`      ::=`<assign>`|`<if>`|`<loop>`|`<in>`|`<out>`
1. `<assign>`    ::=`<id>` = `<exp>`;
1. `<if>`        ::=*if*`<cond>`*then*`<stmt seq>` end;|*if*`<cond>`*then*`<stmt seq>`*else*`<stmt seq>`*end*;
1. `<loop>`      ::=*while*`<cond>`*loop*`<stmt seq>`*end*;
1. `<in>`        ::=*read*`<id list>`;
1. `<out>`       ::=*write*`<id list>`;
1. `<cond>`	     ::=`<comp>`|!`<cond>`| [`<cond>` && `<cond>`] | [`<cond>` or `<cond>`]
1. `<comp>`	     ::= (`<op>` `<comp op>` `<op>`)
1. `<exp>`       ::= `<fac>`|`<fac>`+`<exp>`|`<fac>`-`<exp>`
1. `<fac>`       ::= `<op>` | `<op>` * `<fac>`
1. `<op>`        ::= `<int>` | `<id>` | (`<exp>`)
1. `<comp op>`   ::= `!=` | `==` | `< | >` | `<=` | `>=`
1. `<id>`        ::= `<let>` | `<let> <id>` | `<let> <int>`
1. `<let>`       ::= A | B | C | ... | X | Y | Z	
1. `<int>`       ::= `<digit>` | `<digit> <int>`
1. `<digit>`     ::=0 | 1 | 2 | 3 | ... | 9	

#### Notes:
1. Problem with `<exp>`: consider 9-5+4; fix?
1. -5 is not a legal `<no>`; fix?
1. Productions (18)-(21) have no *semantic* significance;
