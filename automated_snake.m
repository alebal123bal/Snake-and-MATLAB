snake_body = generate_body();
snake_body = apple(snake_body);
snake_length = body_len(snake_body);
snake_body_array = generate_body_array(snake_body);

[snake_head_x, snake_head_y] = snakeHeadCoord(snake_body);
[snake_tail_x, snake_tail_y] = snakeTailCoord(snake_body);

snake_direction = 1;
[s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11] = status(snake_body, snake_direction);
snake_status = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11];

print(snake_body, snake_body_array, snake_length, snake_direction, snake_status, [snake_head_x, snake_head_y], [snake_tail_x, snake_tail_y]);


%Predefined values
function body = generate_body()
    body = [-1 -1 -1 -1 -1 -1 -1 -1; 
    -1 0 0 0 0 0 0 -1;
    -1 0 0 2 1 0 0 -1;
    -1 0 0 3 0 0 0 -1;
    -1 0 5 4 0 0 0 -1;
    -1 0 0 0 0 0 0 -1;
    -1 0 0 0 0 0 0 -1;
    -1 -1 -1 -1 -1 -1 -1 -1];
end

%Get array of x and y coords of head
function [h_x, h_y] = snakeHeadCoord(my_matrix)
    [h_x, h_y] = ind2sub(size(my_matrix), find(my_matrix==1));
end

%Get array of x and y coords of tail
function [t_x, t_y] = snakeTailCoord(my_matrix)
    [t_x, t_y] = ind2sub(size(my_matrix), find(my_matrix==body_len(my_matrix)));
end

%Get index of the head inside snake_body_array
function i = bodyHeadIndex(my_matrix, my_array)
    [h_x, h_y] = snakeHeadCoord(my_matrix);
    [~, i] = ismember([h_x, h_y], my_array, 'rows');
end

%Get index of the tail inside snake_body_array
function i = bodyTailIndex(my_matrix, my_array)
    [t_x, t_y] = snakeTailCoord(my_matrix);
    [~, i] = ismember([t_x, t_y], my_array, 'rows');
end

%Get body length
function len = body_len(my_matrix)
    vct = find(my_matrix > 0);
    vct_size = size(vct);
    len = vct_size(1);%Attenzione che size resituisce un array
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
    disp("La testa che ho letto ?? ");
    disp([x, y]);
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

    disp("Left sensor " + readen_left);
    disp("Right sensor " + readen_right);
    disp("Front sensor " + readen_front);
end

%Perform movement

%Auxiliary function to calculate game over: if head lands on 6 or 9 it's
%over

%Apple is -2
function apple_added_matrix = apple(my_matrix)
    x = 1 + randi(6);
    y = 1 + randi(6);

    while (my_matrix(x, y) - 2 >= -1)
        x = 1 + randi(6);
        y = 1 + randi(6);
    end

    apple_added_matrix = my_matrix;
    apple_added_matrix(x, y) = apple_added_matrix(x, y) - 2;
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

%Print everything
function print(my_matrix, my_snake, length, direction, status, head, tail)
    disp("Direction is ");
    disp(direction);
    disp("Status is ");
    disp(status);
    disp("Snake is long ");
    disp(length);
    disp("Snake body is");
    disp(my_snake);
    disp("Head is ");
    disp(head);
    disp("Tail is ");
    disp(tail);
    disp("Snake is ");
    disp(my_matrix);
end

%pop() function
function arr = pop(my_array, i)
    arr = my_array;
    arr(i, :) = [];
end

%push() function
function arr = push(my_array, row)
    arr = [my_array; row];
end

%Sort array function: works only with snake_body_array
function arr = sort_array(my_array)
    arr = sortrows(my_array, 3);
end
