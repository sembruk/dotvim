set filetype=xml
"syn spell toplevel
"syn region xmlString contained start=+<source>+ end=+</source>+ contains=xmlEntity,@NoSpell display
syn region  xmlString contained start=+"+ end=+"+ contains=xmlEntity,@NoSpell display
syn region  xmlString contained start=+'+ end=+'+ contains=xmlEntity,@NoSpell display
"syn region  xmlString contained start=+\(<translation>\)+ end=+\(</translation>\)+ contains=xmlEntity,@Spell display
"syn region  xmlTranslation contained start=+>+ end=+<+ contains=xmlEntity,@Spell display
"syn region  xmlString
"    \ matchgroup=xmlString start=+>+
"    \ matchgroup=xmlString end=+<+
"    \ contained
"    \ contains=xmlEntity,@Spell
"    \ display
"syn match   xmlTagName
"    \ +[<]\@<=[^ /!?<>"']\++
"    \ contained
"    \ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook,@Spell
"    \ display
"syn match xmlTranslation +translation+ contained contains=xmlAttribPunchi,@xmlTagHook,@Spell display
"syn region xmlTranslation matchgroup=xmlTranslation matchgroup=xmlTranslation start=+<translation>+ end=+</translation>+ contained contains=xmlStartTag,xmlEndTag,xmlEntity,xmlString,@Spell display
"syn cluster xmlRegionHook add=xmlTranslation
syn region   xmlRegion1
    \ start=+<translation+
    \ end=+</translation>+
    \ matchgroup=xmlEndTag end=+/>+
    \ fold
    \ contains=xmlTag,xmlEndTag,xmlCdata,xmlRegion,xmlComment,xmlEntity,xmlProcessing,@xmlRegionHook,@Spell
    \ display
    \ keepend
    \ extend

