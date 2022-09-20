snake_body = generate_body();
snake_body = apple(snake_body);
snake_length = body_len(snake_body);
snake_body_array = generate_body_array(snake_body);

[snake_head_x, snake_head_y] = snakeHeadCoord(snake_body);
snake_head = [snake_head_x, snake_head_y];

snake_direction = 1;
snake_status = [0 0 0 0 0 0 0 0 0 0 0];


%Predefined values
function body = generate_body()
    body = [4 4 4 4 4 4 4 4; 
    4 1 5 0 0 0 0 4;
    4 0 0 0 0 0 0 4;
    4 0 0 0 0 0 0 4;
    4 0 0 0 0 0 0 4;
    4 0 0 0 0 0 0 4;
    4 0 0 0 0 0 0 4;
    4 4 4 4 4 4 4 4];
end

%Get array of x and y coords of head
function [h_x, h_y] = snakeHeadCoord(my_matrix)
    [h_x, h_y] = ind2sub(size(my_matrix), find(my_matrix==5));
end

%Get body length
function len = body_len(my_matrix)
    vct = find(my_matrix==1|my_matrix==5);
    vct_size = size(vct);
    len = vct_size(1);%Attenzione che size resituisce un array
end

%Get array of all body coordinates of snake
function body_array = generate_body_array(my_matrix)
    vct = find(my_matrix==1|my_matrix==5);
    body_array = ind2sub(size(my_matrix), vct);
    disp(body_array(1));
end

%To call AFTER performing the move
function [readen_front, readen_left, readen_right]= snakeReadSensors(matrix, curr_direction, status)
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
    readen_front = matrix(front_sensor(1), front_sensor(2)) + 13;
    readen_left = matrix(left_sensor(1), left_sensor(2)) + 13;
    readen_right = matrix(right_sensor(1), right_sensor(2)) + 13;

    disp("Left sensor " + readen_left);
    disp("Right sensor " + readen_right);
    disp("Front sensor " + readen_front);
end

%Perform movement
function after_move_matrix = move(my_matrix, curr_direction, new_direction, status)
    if(abs(curr_direction-new_direction)~=2)
        return
    end
end

%Auxiliary function to calculate game over: if head lands on 6 or 9 its
%over
function over = game_over(my_matrix)
    return
end

function apple_added_matrix = apple(my_matrix)
    x = 1 + randi(6);
    y = 1 + randi(6);

    while (my_matrix(x, y) + 17 == 18 || my_matrix(x, y) + 17 == 22)
        x = 1 + randi(6);
        y = 1 + randi(6);
    end

    apple_added_matrix = my_matrix;
    apple_added_matrix(x, y) = apple_added_matrix(x, y) + 17;
end

%TODO
function print(matrix, direction, status)
    return
end
