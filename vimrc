"" ============================================================
"" VIM configuration file
"" Last update: 25.03.2016 15:30
"" ============================================================
"" НАСТРОЙКИ ВНЕШНЕГО ВИДА И БАЗОВЫЕ НАСТРОЙКИ РЕДАКТОРА

colorscheme elflord
if has('gui_running')
    colorscheme darkblue
    "" отключить показ иконок в окне GUI (файл, сохранить и т.д.)
    set guioptions-=T
    if has('win32')
        set guifont=Liberation_Mono:h12:cRUSSIAN::
        set lines=50 columns=200
    else
        set guifont=Mono\ 12
        set lines=50 columns=188
        " Maximize gvim window
        "set lines=60 columns=200
        cd %:p:h
    endif
endif
set bg=dark
set t_Co=256 " использовать больше цветов в терминале set laststatus=2
set nocompatible " отключить режим совместимости с классическим Vi
"" Формат строки состояния
"" fileformat - формат файла (unix, dos); fileencoding - кодировка файла;
"" encoding - кодировка терминала; TYPE - тип файла, затем коды символа под курсором;
"" позиция курсора (строка, символ в строке); процент прочитанного в файле;
"" кол-во строк в файле;
"set statusline=%F%m%r%h%w\ [FF,FE,TE=%{&fileformat},%{&fileencoding},%{&encoding}\]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=%<%f%h%m%r%=FORMAT=%{&fileformat}\ ENCODING=%{&fenc}\ TYPE=%Y\ HEX=0x%B\ %l,%c%V\ %P
"set showmatch " показывать первую парную скобку после ввода второй
set noshowmatch
set wrap " (no)wrap - динамический (не)перенос длинных строк
set linebreak " переносить целые слова

"" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

"" НАСТРОЙКА ОТСТУПОВ
set tabstop=4 " ширина табуляции
set shiftwidth=4 " размер отступов (<< или >>)
"set smarttab
set autoindent " ai - включить автоотступы (копируется отступ предыдущей строки)
"set cindent " ci - отступы в стиле С
set expandtab " преобразовать табуляцию в пробелы
set smartindent " Умные отступы (например, автоотступ после {)
"" Для указанных типов файлов отключает замену табов пробелами и меняет ширину отступа
au FileType crontab,fstab,make setlocal noexpandtab tabstop=4 shiftwidth=4
au FileType lua setlocal tabstop=3 shiftwidth=3
au FileType javascript setlocal tabstop=4 shiftwidth=4

"" Подгрузить файл синтаксиса ts.vim из ~/.vim/syntax
au BufRead,BufNewFile *.ts set filetype=ts

syntax on
"let c_syntax_for_h=1 " необходимо установить для того, чтобы *.h файлам присваивался тип c, а не cpp
au BufRead,BufNewFile *.h set filetype=cpp

"if has('gui_running')
"    if has('win32')
"        set lines=50 columns=200
"    else
"        set lines=50 columns=188
"    endif
"endif

"" Подсвечивать табы и пробелы в конце строки
"set list " включить подсветку
"set listchars=tab:>-,trail:- " установить символы, которыми будет осуществляться подсветка


"autocmd FileType c set omnifunc=ccomplete#Complete " автодополнение ввода
"set completeopt=menu
set nu " нумерация строк
au BufWinLeave *.* silent mkview " при закрытии файла сохранить 'вид'
au BufWinEnter *.* silent loadview " при открытии - восстановить сохранённый
set clipboard=unnamed " во избежание лишней путаницы использовать системный буфер обмена вместо буфера Vim
set backup " включить сохранение резервных копий
"set nobackup
"set backupdir=$HOME/.vim/backup/

augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost * if &bin | %!xxd
    au BufReadPost * set ft=xxd | endif
    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif
    au BufWritePost * if &bin | %!xxd
    au BufWritePost * set nomod | endif
    augroup END

"" Сохранять умные резервные копии ежедневно
function! BackupDir()
	"" определим каталог для сохранения резервной копии
    if has('win32')
        let l:backupdir=$HOME.'/.vim/backup/'.
                \substitute(expand('%:p:h'), ':', '', '')
    else
        let l:backupdir=$HOME.'/.vim/backup/'.
                \substitute(expand('%:p:h'), '^'.$HOME, '~', '')
    endif


	"" если каталог не существует, создадим его рекурсивно
	if !isdirectory(l:backupdir)
		call mkdir(l:backupdir, 'p', 0700)
	endif

	"" переопределим каталог для резервных копий
	let &backupdir=l:backupdir

	"" переопределим расширение файла резервной копии
	let &backupext=strftime('~%Y-%m-%d~')
endfunction

"" выполним перед записью буффера на диск
autocmd! bufwritepre * call BackupDir()



"* НАСТРОЙКИ ПЕРЕМЕННЫХ ОКРУЖЕНИЯ
if has('win32')
    "let $VIMRUNTIME = $HOME.'\Programs\Vim\vim72'
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
else
    let $VIMRUNTIME = $HOME.'/.vim'
endif

"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      let cmd = '""' . $VIMRUNTIME . '\diff"'
"      let eq = '"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

"" НАСТРОЙКИ РАБОТЫ С ФАЙЛАМИ
"" Кодировка редактора (терминала) по умолчанию (при создании все файлы приводятся к этой кодировке)
"if has('win32')
   "set encoding=cp1251
"else
   set encoding=utf-8
   set termencoding=utf-8
"endif

if has('win32')
   " Отображение кириллицы во внутренних сообщениях программы
   lan mes ru_RU.UTF-8

   " Отображение кириллицы в меню
   source $VIMRUNTIME/delmenu.vim
   set langmenu=ru_RU.UTF-8
   source $VIMRUNTIME/menu.vim
endif

"" Формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке
set fileformat=unix

""Удалять пустые пробелы на концах строк при открытии файла
"autocmd BufEnter *.* :call RemoveTrailingSpaces()

"" Перед сохранением .vimrc обновлять дату последнего изменения
autocmd! bufwritepre $MYVIMRC call setline(3, '"" Last update: '.strftime("%d.%m.%Y %H:%M"))

"" НАСТРОЙКА ПОИСКА
set ignorecase "Игнорировать регистр символов при поиске
set smartcase " - если искомое выражения содержит символы в верхнем регистре - ищет с учётом регистра, иначе - без учёта
set hlsearch " (не)подсветка результатов поиска (после того, как поиск закончен и закрыт)
"set nohlsearch
set incsearch " поиск фрагмента по мере его набора

"Путь для поиска файлов командами gf, [f, ]f, ^Wf, :find, :sfind, :tabfind и т.д.
"поиск начинается от директории текущего открытого файла, ищет в ней же
"и в поддиректориях. Пути для поиска перечисляются через запятую, например:
"set path=.,,**
"let Grep_Cygwin_Find = 1

"" НАСТРОЙКИ СВОРАЧИВАНИЯ БЛОКОВ КОДА (фолдинг)
"set foldenable " включить фолдинг
"set foldmethod=syntax " определять блоки на основе синтаксиса файла
"set foldmethod=indent " определять блоки на основе отступов
"set foldcolumn=3 " показать полосу для управления сворачиванием
"set foldlevel=1 " Первый уровень вложенности открыт, остальные закрыты
"set foldopen=all " автоматическое открытие сверток при заходе в них
"set tags=tags\ $VIMRUNTIME/systags " искать теги в текущй директории и в указанной (теги генерируются ctags)

"set tags+=c:\SVNWork\firmware_globule_mini\tags
if has('win32')
   set tags+=.\tags
   set makeprg=c:\WinAVR-20100110\utils\bin\make.exe
   "if filereadable(".\.vimrc.local")
   "   source .\.vimrc.local
   "endif
endif

"" Обновление ctags
function! UpdateCtags()
   silent !ctags -R ./
endfunction

"" Индикация раскладки
set keymap=russian-jcukenwin " настраиваем переключение раскладок клавиатуры по <C-^>
set iminsert=0 " раскладка по умолчанию - английская
set imsearch=0 " аналогично для строки поиска и ввода команд
highlight lCursor guifg=NONE guibg=Cyan
function! MyKeyMapHighlight()
   if &iminsert == 0 " при английской раскладке статусная строка текущего окна будет серого цвета
      hi StatusLine ctermfg=White guifg=White
   else " а при русской - зеленого.
      hi StatusLine ctermfg=DarkRed guifg=DarkRed
   endif
endfunction
"call MyKeyMapHighlight() " при старте Vim устанавливать цвет статусной строки
"autocmd WinEnter * :call MyKeyMapHighlight() " при смене окна обновлять информацию о раскладках

"ВКЛЮЧЕНИЕ АВТОДОПЛНЕНИЯ ВВОДА (omnifunct)
autocmd FileType c set omnifunc=ccomplete#Complete
" Опции автодополнения - включаем только меню с доступными вариантами
" автодополнения (также, например, для omni completion может быть
" окно предварительного просмотра).
set completeopt=menu


" Pathogen
call pathogen#infect()
call pathogen#helptags()


"------------------------------------------------------------------
"                       НАСТРОЙКИ ГОРЯЧИХ КЛАВИШ
"------------------------------------------------------------------

" F2 - сохранить файл
nmap <F2> :w<cr>
vmap <F2> <esc>:w<cr>i
imap <F2> <esc>:w<cr>i

" F3 - рекурсивный поиск по файлам (плагин grep.vim)
nnoremap <silent> <F3> :Rgrep<cr>

" F7 - обозреватель файлов (:Ex для стандартного обозревателя,
" плагин NERDTree - дерево каталогов)
map <F7> :NERDTreeToggle<cr>
vmap <F7> <esc>:NERDTreeToggle<cr>i
imap <F7> <esc>:NERDTreeToggle<cr>i

" F9 - сохранение файла и запуск компиляции (make)
"nmap <F9> :wa<cr>:make<cr>
"vmap <F9> <esc>:wa<cr>:make<cr>i
"imap <F9> <esc>:wa<cr>:make<cr>i

nmap <F9> :wa<CR>:make<CR>:cw<CR>
vmap <F9> <esc>:wa<cr>:make<cr>:cw<cr>i
imap <F9> <esc>:wa<cr>:make<cr>:cw<cr>i

nmap <S-F9> :make clean<cr>
vmap <S-F9> <esc>:make clean<cr>i
imap <S-F9> <esc>:make clean<cr>i

nmap <C-S-F9> :wa<cr>:make clean<cr>:make<cr>:cw<cr>
vmap <C-S-F9> <esc>:wa<cr>:make clean<cr>:make<cr>:cw<cr>i
imap <C-S-F9> <esc>:wa<cr>:make clean<cr>:make<cr>:cw<cr>i

"" Замена слова под курсором
nmap <S-F12> :%s/\<<c-r>=expand("<cword>")<cr>\>/

"" Работа с буферами

" предыдущий буфер
nmap <C-Left> :bp<cr>
imap <C-Left> <esc>:bp<cr>i
vmap <C-Left> <esc>:bp<cr>i

" следующий буфер
nmap <C-Right> :bn<cr>
imap <C-Right> <esc>:bn<cr>i
vmap <C-Right> <esc>:bn<cr>i


"" Переключение табов (вкладок) (rxvt-style)
map <S-left> :tabprevious<cr>
nmap <S-left> :tabprevious<cr>
imap <S-left> <ESC>:tabprevious<cr>i
map <S-right> :tabnext<cr>
nmap <S-right> :tabnext<cr>
imap <S-right> <ESC>:tabnext<cr>i
"nmap <C-t> :tabnew<cr>:NERDTree<cr>
"imap <C-t> <ESC>:tabnew<cr>:NERDTree<cr>
"nmap <C-w> :tabclose<cr>
"imap <C-w> <ESC>:tabclose<cr>

nnoremap ,cd :cd %:p:h<cr>:pwd<cr>

"" Меню изменения кодировок чтения из файла (<F8>)
set wildmenu
set wcm=<Tab>
menu Encoding.Read.CP1251   :e ++enc=cp1251<CR>
menu Encoding.Read.CP866    :e ++enc=cp866<CR>
menu Encoding.Read.KOI8-U   :e ++enc=koi8-r<CR>
menu Encoding.Read.UTF-8    :e ++enc=utf-8<CR>
map <F8> :emenu Encoding.Read.<TAB>

""Меню изменения кодировки записи в файл (Ctrl-F8)
set wildmenu
set wcm=<Tab>
menu Encoding.Write.CP1251    :set fenc=cp1251<CR>
menu Encoding.Write.CP866     :set fenc=cp866<CR>
menu Encoding.Write.KOI8-R    :set fenc=koi8-r<CR>
menu Encoding.Write.UTF-8     :set fenc=utf-8<CR>
map <C-S-F8> :emenu Encoding.Write.<TAB>

""Меню изменения конца строки у файла (Shift-F8)>
set wildmenu
set wcm=<Tab>
menu File.Format.DOS    :set fileformat=dos<CR>
menu File.Format.MAC    :set fileformat=mac<CR>
menu File.Format.UNIX   :set fileformat=unix<CR>
map <S-F8> :emenu File.Format.<TAB>

"" Проверка орфографии
set spell spelllang=
set nospell
menu Spell.off :setlocal spell spelllang=<CR>:setlocal nospell<CR>
menu Spell.Russian+English :setlocal spell spelllang=ru,en_us<CR>
menu Spell.Russian :setlocal spell spelllang=ru<CR>
menu Spell.English :setlocal spell spelllang=en_us<CR>
menu Spell.-SpellControl- :
menu Spell.Word\ Suggest<Tab>z= z=
menu Spell.Add\ To\ Dictionary<Tab>zg zg
menu Spell.Add\ To\ TemporaryDictionary<Tab>zG zG
menu Spell.Remove\ From\ Dictionary<Tab>zw zw
menu Spell.Remove\ From\ Temporary\ Dictionary<Tab>zW zW
menu Spell.Previous\ Wrong\ Word<Tab>[s [s
menu Spell.Next\ Wrong\ Word<Tab>]s ]s
map <C-S-F7> :emenu Spell.<TAB>

let MyUpdateCtagsFunction = "UpdateCtags"
nmap <F4> :call {MyUpdateCtagsFunction}()<CR>
menu ctags.Update<Tab><F4> <F4>

"" Удалить пробелы в конце строк (frantsev)
function! RemoveTrailingSpaces()
   normal! mzHmy
   execute '%s:\s\+$::ge'
   normal! 'yzt`z
endfunction

