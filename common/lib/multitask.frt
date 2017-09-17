\ lib/multitask.frt
\ -------------------------------------------------------------------
\ Cooperative Multitasker based on 
\ Message-ID: <1187362648.046634.262200@o80g2000hse.googlegroups.com>
\ From:  Brad Eckert <nospaambrad1@tinyboot.com>
\ Newsgroups: comp.lang.forth
\ Subject: Re: Tiny OS based on byte-code interpreter
\ Date: Fri, 17 Aug 2007 07:57:28 -0700

\ TCB (task control block) structure, identical to user area
\ Offs_| _Name___ | __Description__________________________ |
\   0  | status   | xt of word that resumes this task       | <-- UP
\   2  | follower | address of the next task's status       |
\   4  | RP0      | initial return stack pointer            |
\   6  | SP0      | initial data stack pointer              |
\   8  | sp       | -> top of stack                         |
\  10  | handler  | catch/throw handler                     |
\ ... more user variables (mostly IO related)

\ The TIB (task information block) is a flash (dictionary)
\ area that holds the vital task definitions. The task-init
\ uses data from it to initialize the runtime environment.
\ Offs_| __Description___________________ |
\  0   | address of the TCB area          | <-- UP
\  2   | rp0 address inside the TCB area  |
\  4   | sp0 address inside the TCB area  |
\
\
\ please note that with amforth rp@ @ accesses another location 
\ than r@ due to hardware characteristics.

\ marker _multitask_
\ #require builds.frt

#0 user status
#2 user follower
#8 user sp

:noname ( 'status1 -- 'status2 ) cell+ @ dup @ i-cell+ >r ; constant pass
:noname ( 'status1 -- )          up! sp @ sp! rp! ;         constant wake

\ switch to the next task in the list
: multitaskpause   ( -- ) rp@ sp@ sp ! follower @ dup @ i-cell+ >r ;
: stop         ( -- )     pass status ! pause ; \ sleep current task
: task-sleep   ( tcb -- ) pass swap ! ;         \ sleep another task
: task-awake   ( tcb -- ) wake swap ! ;         \ wake another task

: cell- negate cell+ negate ;

\ continue the code as a task in a predefined tcb
: activate ( tcb -- )
   dup    #6 + @ cell-
   over   #4 + @ cell- ( -- tcb sp rp )     \ point to RP0 SP0
   r> over i-cell+ !   ( save entry at rp of the stack and EXIT activate. )
      over  !          (  save rp at sp )
   over #8 + !         ( save sp in tos )
   task-awake 
;

\ task:     allocates stack space and creates the task control block
\ alsotask  appends the tcb to the (circular, existing) list of TCB

: task: ( C: dstacksize rstacksize add.usersize "name" -- )
        ( R: -- task-information-block )
  <builds
    here ,                      \ store address of TCB
    [ s" /user" environment search-wordlist drop execute ] literal
    ( add.usersize ) + allot \ default user area size
                                \ allocate stacks
    ( rstacksize ) allot here , \ store rp0
    ( dstacksize ) allot here , \ store sp0 

    1 allot                   \ keep here away, amforth specific
  does>
                              \ leave flash addr on stack
;

: tib>tcb  ( tib -- tcb )                  @i ;
: tib>rp0  ( tib -- rp0 )  i-cell+         @i ;
: tib>sp0  ( tib -- sp0 )  i-cell+ i-cell+ @i ;
: tib>size ( tib -- size )
  dup tib>tcb swap tib>sp0 1+ swap -
;
: task-init ( tib -- )
  dup tib>tcb over tib>size  0 fill \ clear RAM for tcb and stacks
  dup tib>sp0 over tib>tcb #6 + !       \ store sp0    in tcb[6]
  dup tib>sp0 cell- over tib>tcb #8 + ! \ store sp0--  in tcb[8], tos
  dup tib>rp0 over tib>tcb #4 + !       \ store rp0    in tcb[4]
      tib>tcb task-sleep                \ store 'pass' in tcb[0]
;

\ stop multitasking
: single ( -- ) \ initialize the multitasker with the serial terminal
    ['] noop ['] pause defer!
;

\ start multitasking
: multi ( -- )
    ['] multitaskpause ['] pause defer!
;


\ initialize the multitasker with the current task only
: onlytask ( -- ) 
    wake status !   \ own status is running
    up@  follower ! \ point to myself
;


\ insert new task structure into task list
: alsotask      ( tcb -- )
   ['] pause defer@ >r \ stop multitasking
   single
   follower @   ( -- tcb f) 
   over         ( -- tcb f tcb )
   follower !   ( -- tcb f )
   swap cell+   ( -- f tcb-f )
   !
   r> ['] pause defer! \ restore multitasking
;

\ print all tasks with their id and status
: tasks ( -- )
    status ( -- tcb ) \ starting value
    dup
    begin    ( -- tcb1 ctcb )
      dup u. ( -- tcb1 ctcb )
      dup @  ( -- tcb1 ctcb status )
      dup wake = if ."   running" drop else
          pass = if ."  sleeping" else
          -1 abort"   unknown" then
      then
\     dup #4 + @ ."   rp0=" dup u. cell- @ ."  TOR=" u.
\     dup #6 + @ ."   sp0=" dup u. cell- @ ."  TOS=" u.
\     dup #8 + @ ."    sp=" u.
      cr
      cell+ @ ( -- tcb1 next-tcb )
      2dup =     ( -- f flag)
    until
    2drop
    ." Multitasker is " 
    ['] pause defer@ ['] noop = if ." not " then
    ." running"
;
