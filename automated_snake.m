snake = [1 5 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

[head_x, head_y] = snakeHeadCoord(snake);

snake_sensors = zeros(6, 6);
snake_sensors(head_x , head_y + 1) = 13;

disp(snake);
disp(snake_head);
disp([head_x, head_y]);
disp(snake_sensors);

function [h_x, h_y] = snakeHeadCoord(snake_matrix)
    [h_x, h_y] = ind2sub(size(snake_matrix), find(snake_matrix==5));
end

function snake_sensors_mat = snakeSensors(snake_matrix)
    snake_sensors_mat = zeros(6, 6);
    [h_x, h_y] = snakeHeadCoord(snake_matrix);
end

funtion 