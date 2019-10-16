if !exists(':Unite')
    finish
endif

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file_rec', 'ignore_globs', split(&wildignore, ','))
