with recursive rnd_move(move) as (
        select *, random() rnd from generate_series(1, 9) move
), winning_positions(a, b, c) as (
    values (1, 2, 3), (4, 5, 6), (7, 8, 9), -- rows
           (1, 4, 7), (2, 5, 8), (3, 6, 9), -- cols
           (1, 5, 9), (3, 5, 7)             -- diagonals
), game as (
    select 'O' as who_next, ARRAY['.', '.', '.', '.', '.', '.', '.', '.', '.'] as board
    union 
    (
        select case when who_next = 'X' then 'O' else 'X' end as who_next,
               board[:move-1] || who_next || board[move+1:]
        from game, rnd_move where board[move] = '.' order by rnd limit 1
    )
), game_with_winner as (
    select *, lag(a is not null) over () as finished, lag(who_next) over () as who
    from game left join winning_positions on
        board[a] != '.' and board[a] = board[b] and board[a] = board[c]
)
select array_to_string(board[1:3] || chr(10) || board[4:6] || chr(10) || board[7:9] || chr(10), '') board,
       case when a is not null then who || ' wins' end as winner
from game_with_winner where not finished;