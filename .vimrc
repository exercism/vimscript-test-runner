filetype off
set runtimepath+=/opt/test-runner/vader.vim
filetype plugin on
syntax enable

" TODO: figure out how to capture the output within the try/catch instead of running the tests twice
try | execute 'source' $implementation_file | catch | echo v:exception | cq | endtry | execute 'source' $implementation_file
