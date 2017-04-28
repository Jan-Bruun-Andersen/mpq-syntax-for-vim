" Vim syntax file
" Language:	Microsoft Power Query for Excel
" Definition:	http://download.microsoft.com/download/8/1/A/81A62C9B-04D5-4B6D-B162-D28E4D848552/
"		  Power%20Query%20Formula%20Language%20Specification%20(October%202016).pdf
" Maintainer:	Jan Bruun Andersen <jan_bruun_andersen AT jabba DOT dk>
" URL:		http://github.com/jan_bruun_andersen/mpdotvim
" Revision:	2017-04-24
" Change log:	xxx

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" TODO: Is MPQ case-sensitive?
syntax case ignore

" Comments (section 12.1.2)
syntax keyword	mpq_comment_todo contained TODO FIXME XXX DEBUG NOTE
syntax match	mpq_comment "//.*$"               contains=mpq_comment_todo
syntax region	mpq_comment start="/\*" end="\*/" contains=mpq_comment_todo

" Literals (section 12.1.5)
" TODO: Match octal numbers. Hex numbers too?
syntax match	mpq_number "\d\+\.\d\+[eE][-+]\?\d\+"
syntax match	mpq_number     "\.\d\+[eE][-+]\?\d\+"
syntax match	mpq_number       "\d\+[eE][-+]\?\d\+"
syntax match	mpq_number                     "\d\+"
syntax region	mpq_string start=/"/hs=s+1 skip=/\\|\"/ end=/"/he=e-1

" Identifier (section 1.2.6)
syntax match	mpq_ident "\w\+"
syntax region	mpq_ident start=/#"/ end=/"/

" Keywords (section 12.1.7)
syntax keyword	mpq_keywords AND AS EACH ELSE ERROR FALSE IF IN IS LET META NOT
syntax keyword	mpq_keywords OTHERWISE OR SECTION SHARED THEN TRUE TRY TYPE
syntax keyword	mpq_keywords #BINARY #DATE #DATETIME #DATETIMEZONE #DURATION
syntax keyword	mpq_keywords #INFINITY #NAN #SECTIONS #SHARED #TABLE #TIME

" Operators (section 12.1.8)
syntax match	mpq_oper "[-,;=<>]"
syntax match	mpq_oper "<="
syntax match	mpq_oper ">="
syntax match	mpq_oper "<>"
syntax match	mpq_oper "[-+*/]"
syntax match	mpq_oper "[&()@?]"
syntax match	mpq_oper "[[\]{}]"
syntax match	mpq_oper "=>"
syntax match	mpq_oper "\.\{2,3\}"

" Lists (section 12.2.3.17)
syntax region	mpq_list start="{" end="}"	contains=ALL

" Records (section 12.2.3.18)
syntax region	mpq_record start="\[" end="\]"	contains=ALL

" Type expression (section 12.2.3.25)
" OBS: Using 'syntax keyword' does not work very well because 'list', 'record', and
"      possibly other keyswords overlaps with standard library objects like List and
"      Record. And 'syntax keyword' has a higher priority than 'syntax match'.
syntax match	mpq_ptype '\<\(any\|anynonnull\|binary\|date\|datetime\|datetimezone\|duration\|function\)\>'
syntax match	mpq_ptype '\<\(list\|logical\|none\|null\|number\|record\|table\|text\|type\)\>'

" Treat standard library objects and functions (File.Contents, List.First, List.Select, etc) as keywords.
" TODO: Match all library objects and functions.
syntax match	mpq_library  "Excel\.\w\+"
syntax match	mpq_library  "File\.\w\+"
syntax match	mpq_library  "List\.\w\+"
syntax match	mpq_library  "Record\.\w\+"
syntax match	mpq_library  "Replacer\.\w\+"
syntax match	mpq_library  "Table\.\w\+"
syntax match	mpq_library  "Text\.\w\+"

" Catch errors caused by wrong parenthesis. Copied from awk.vim v. 2012-05-18.
" FIXME: Disabled for now since I do not understand what it is doing and if it is
"        applicable to MPQ.
if 0
  syntax region	mpq_paren	transparent start="(" end=")" contains=ALLBUT,mpq_paren_error,mpq_spec_char,mpq_list,mpt_record,mpq_comment_todo,mpq_regex,mpq_brackets,mpq_char_class
  syntax match	mpq_paren_error	display ")"
  syntax match	mpq_in_paren	display contained "[{}]"

  syntax region	mqp_brackets	contained start="\[\^\]\="ms=s+2 start="\[[^\^]"ms=s+1 end="\]"me=e-1 contains=mqp_brkt_regxxp,mqp_char_class

  syntax match	mqp_char_class	contained "\[:[^:\]]*:\]"
  syntax match	mqp_brkt_regex	contained "\\.\|.\-[^]]"
  syntax match	mqp_regex	contained "/\^"ms=s+1
  syntax match	mqp_regex	contained "\$/"me=e-1
  syntax match	mqp_regex	contained "[?.*{}|+]"
  syntax match	mpq_spec_char	contained '\.'
endif

" Define the default highlighting.
" For version 5.7 and earlier: Only when not already done.
" For version 5.8 and later:   Only when an item does not have highlighting yet.

if version >= 508 || !exists("did_mpq_syntax_inits")
" if exists("HiLink") | delcommand HiLink | endif
  if version < 508
    let did_mpq_syntax_inits = 1
    command -nargs=+ HiLink highlight         link <args>
  else
    command -nargs=+ HiLink highlight default link <args>
  end

  HiLink mpq_comment_todo	ToDo
  HiLink mpq_comment		Comment
  HiLink mpq_string		Constant
  HiLink mpq_number		Number
  HiLink mpq_ident		Identifier
  HiLink mpq_oper		Operator
  HiLink mpq_keywords		Keyword
  HiLink mpq_library		Keyword
  HiLink mpq_ptype		Keyword
  HiLink mpq_list		Structure
  HiLink mpq_record		Structure

  delcommand HiLink
endif

let b:current_syntax = "mpq"

" vim: tabstop=8 shiftwidth=2 autoindent number:
