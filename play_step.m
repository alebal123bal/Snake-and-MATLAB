


nn_weights_first = readmatrix('best1.dat');
nn_weights_second = readmatrix('best2.dat');
nn_biases_hidden = readmatrix('best3.dat');
nn_biases_out = readmatrix('best4.dat');

[i1, i2, i3, i4, i5] = reset_init();

snake_body = i1;
snake_body_array = i2;
snake_status = i3;
snake_direction = i4;
snake_score = i5;


%disp("Posizione iniziale")
disp(snake_body)
%disp("Status iniziale")
%disp(snake_status)

highscore = snake_score;

i = 1;
steps_taken = 0;

%Main loop
while i<=20
    chosen_direction = feedForward(snake_status, nn_weights_first, nn_weights_second, nn_biases_hidden, nn_biases_out);
    %disp("Voglio muovermi a " + chosen_direction)

    [image, vector, stat, dir, score] = move(snake_body, snake_body_array, snake_status, chosen_direction, snake_score);
    snake_body = image;
    snake_body_array = vector;
    snake_status = stat;
    snake_direction = dir;
    snake_score = score;
    
    disp(snake_body)

    if snake_score > highscore
        highscore = snake_score;
        disp("New highscore! (" + highscore + ")")
    end

    %disp(i)
    i = i + 1;
    steps_taken = steps_taken + 1;
    if steps_taken > 100
        %disp("Looping: Resetting")
        [i1, i2, i3, i4, i5, inn1, inn2, inn3, inn4] = reset_init();
        
        snake_body = i1;
        snake_body_array = i2;
        snake_status = i3;
        snake_direction = i4;
        snake_score = i5;

        steps_taken = 0;
    end
end

%RESET function
function [snake_body, snake_body_array, snake_status, snake_direction, snake_score] = reset_init()
    snake_body = generate_body();
    snake_body = apple(snake_body);
    snake_body_array = generate_body_array(snake_body);
    snake_direction = 1;
    [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11] = status(snake_body, snake_direction);
    snake_status = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11];
    snake_score = body_len(snake_body);
end



%Predefined values
function body = generate_body()
    body = [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1; 
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 2 1 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 0 0 -1;
    -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
end

%Get array of x and y coords of head
function [h_x, h_y] = snakeHeadCoord(my_matrix)
    [h_x, h_y] = ind2sub(size(my_matrix), find(my_matrix==1));
end

%Get array of x and y coords of tail
function [t_x, t_y] = snakeTailCoord(my_matrix)
    [t_x, t_y] = ind2sub(size(my_matrix), find(my_matrix==body_len(my_matrix)));
end

%Get body length
function len = body_len(my_matrix)
    vct = find(my_matrix > 0);
    vct_size = size(vct);
    len = vct_size(1);  %Attenzione che size resituisce un array
end

%Get array of all body coordinates of snake
function body_array = generate_body_array(my_matrix)
    len = body_len(my_matrix);
    body_array = zeros(len, 3);
    vct = find(my_matrix > 0);
    for i = 1:len
        [a, b] = ind2sub(size(my_matrix), vct(i));
        body_array(i, 1) = a;
        body_array(i, 2) = b;
        body_array(i, 3) = my_matrix(vct(i));
    end

    body_array = sort_array(body_array);
end

%Function to read snake sensors
function [readen_front, readen_left, readen_right]= snakeReadSensors(matrix, curr_direction)
    [x, y] = snakeHeadCoord(matrix);
    head = [x, y];
    if curr_direction == 1   %right
        front_sensor = [head(1), head(2)+1];
        left_sensor = [head(1)-1, head(2)];
        right_sensor = [head(1)+1, head(2)];
    end
    if curr_direction == 2   %down
        front_sensor = [head(1)+1, head(2)];
        left_sensor = [head(1), head(2)+1];
        right_sensor = [head(1), head(2)-1];
    end
    if curr_direction == 3   %left
        front_sensor = [head(1), head(2)-1];
        left_sensor = [head(1)+1, head(2)];
        right_sensor = [head(1)-1, head(2)];
    end
    if curr_direction == 4   %up
        front_sensor = [head(1)-1, head(2)];
        left_sensor = [head(1), head(2)-1];
        right_sensor = [head(1), head(2)+1];
    end
    readen_front = matrix(front_sensor(1), front_sensor(2)) - 3;
    readen_left = matrix(left_sensor(1), left_sensor(2)) - 3;
    readen_right = matrix(right_sensor(1), right_sensor(2)) - 3;
end

function legal = legalMove(stat, new_dir)
    one_hot_dir = [stat(1), stat(2), stat(3), stat(4)];
    i = find(one_hot_dir==1);

    if(abs(new_dir - i) == 2)  %Then illegal move: keep current direction
        legal = i;
    else
        legal = new_dir;
    end
end

%Perform movement: returns the game matrix updated
function [final_matrix, final_array, final_status, final_direction, final_score] = move(my_matrix, my_array, my_status, my_direction, my_len)   %status is used to see if it's a legal move
    legal_direction = legalMove(my_status, my_direction);
    [next_h_x, next_h_y] = nextHeadCoord(my_matrix, legal_direction);   %Provide already legal direction
    final_score = my_len;

    if(my_matrix(next_h_x, next_h_y) == -1)
        [i1, i2, i3, i4, i5] = reset_init();

        final_matrix = i1;
        final_array = i2;
        final_status = i3;
        final_direction = i4;
        final_score = i5;

    elseif (my_matrix(next_h_x, next_h_y) > 0)
        [i1, i2, i3, i4, i5] = reset_init();

        final_matrix = i1;
        final_array = i2;
        final_status = i3;
        final_direction = i4;
        final_score = i5;
    else
        %Do mov
        [clear_x, clear_y] = snakeTailCoord(my_matrix);
        final_array = push(my_array, [next_h_x, next_h_y, 0]);
        final_matrix = fromArrayToMatrix(my_matrix, final_array);
        %Have you eaten apple?
        if(my_matrix(next_h_x, next_h_y) == -2)
            %If yes, no necessity to pop tail
            final_score = final_score + 1;
            final_matrix = apple(final_matrix);
        else
            final_array = pop(final_array);
            final_matrix(clear_x, clear_y) = 0;
        end
        [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11] = status(final_matrix, legal_direction);
        final_status = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11];
        final_direction = legal_direction;
    end
end

%Print snake_array_body into snake_body
function mat = fromArrayToMatrix(my_matrix, my_array)
    mat = my_matrix;
    last = size(my_array);
    for i = 1:last(1)
        mat(my_array(i, 1), my_array(i, 2)) = my_array(i, 3);
    end
end

%Get next head position function; similar to readSensor switch case
function [next_h_x, next_h_y] = nextHeadCoord(my_matrix, next_dir)
    [h_x, h_y] = snakeHeadCoord(my_matrix);
    %next_dir is already provided legal
    if next_dir == 1   %right
        next_h_x = h_x;
        next_h_y = h_y + 1;
    elseif next_dir == 2   %down
        next_h_x = h_x + 1;
        next_h_y = h_y;
    elseif next_dir == 3   %left
        next_h_x = h_x;
        next_h_y = h_y -1;
    else   %up
        next_h_x = h_x - 1;
        next_h_y = h_y;
    end
end


%Apple is -2
function apple_added_matrix = apple(my_matrix)
    x = 1 + randi(8);
    y = 1 + randi(8);

    while (my_matrix(x, y) - 2 >= -1)
        x = 1 + randi(8);
        y = 1 + randi(8);
    end

    apple_added_matrix = my_matrix;
    apple_added_matrix(x, y) = -2;
end

%Function to get apple position
function [apple_x, apple_y] = appleCoord(my_matrix)
    [apple_x, apple_y] = ind2sub(size(my_matrix), find(my_matrix == -2));
end

%Function to see where is the apple
function [is_right, is_down, is_left, is_up] = applePosition(my_matrix)
    [head_x, head_y] = snakeHeadCoord(my_matrix);
    [apple_x, apple_y] = appleCoord(my_matrix);

    is_right = 0;
    is_down = 0;
    is_left = 0;
    is_up = 0;

    if apple_x > head_x
        is_down = 1;
    end
    if apple_x < head_x
        is_up = 1;
    end
    if apple_y > head_y
        is_right = 1;
    end
    if apple_y < head_y
        is_left = 1;
    end
end

%Function to return current status
function [dir_r, dir_d, dir_l, dir_u, food_r, food_d, food_l, food_u, dan_ah, dan_l, dan_r] = status(my_matrix, direction)
    dan_ah = 0;
    dan_l = 0;
    dan_r = 0;

    [read_ah, read_l, read_r] = snakeReadSensors(my_matrix, direction);
    if (read_ah~=-3 && read_ah~=-5)%See specifiche_regole_snake.md
        dan_ah = 1;
    end
    if (read_l~=-3 && read_l~=-5)
        dan_l = 1;
    end
    if (read_r~=-3 && read_r~=-5)
        dan_r = 1;
    end
    
    dir_r = 0;
    dir_d = 0;
    dir_l = 0;
    dir_u = 0;

    if direction==1
        dir_r = 1;
    elseif direction==2
        dir_d = 1;
    elseif direction==3
        dir_l = 1;
    else
        dir_u = 1;
    end

    [apple_r, apple_d, apple_l, apple_u] = applePosition(my_matrix);

    food_r = apple_r;
    food_d = apple_d;
    food_l = apple_l;
    food_u = apple_u;
end

%Utilities

%pop() function
function arr = pop(my_array)
    arr = my_array;
    arr_size = size(arr);
    arr(arr_size(1), :) = [];
    arr = sortrows(arr, 3);
end

%push() function specific of snake
function arr = push(my_array, row)
    arr = [row; my_array];
    arr(:, 3) = arr(:, 3) + 1;
    arr = sortrows(arr, 3);
end

%Sort array function: works only with snake_body_array
function arr = sort_array(my_array)
    arr = sortrows(my_array, 3);
end

%Neural Network
function final_move = feedForward(my_status, wei_f, wei_s, bia_f, bia_s)
    activation_vct_first = wei_f*(my_status.');
    in_second_vct = activation_vct_first > bia_f.';

    activation_vct_second = wei_s*in_second_vct;
    
    out_vct = activation_vct_second > bia_s.';
    max_vct = out_vct.*activation_vct_second;
    [~, b] = max(max_vct);
    final_move = b;
end


