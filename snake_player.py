import matlab.engine
import numpy
import threading
import os
#import pygame

eng = matlab.engine.start_matlab()

#Matlab function must have same name as matlab file
eng.cd(r'C:\Users\Principale\Desktop\microcontroller\python\MATLAB_snake', nargout = 0)
eng.play_step(nargout = 0)

#print(numpy.asarray(eng.play_step()).astype(int))

#print(numpy.asarray(eng.readmatrix('move.dat')).astype(int))


#SQUARE_SIZE = 50
#RED = (255, 0, 0)
#GREEN = (0, 255, 0)
#pygame.init()

#dis = pygame.display.set_mode((10*SQUARE_SIZE, 10*SQUARE_SIZE))
#clock = pygame.time.Clock()

#pygame.draw.rect(dis, GREEN, [0, 0, 1*SQUARE_SIZE, 1*SQUARE_SIZE])
#pygame.display.update()

#clock.tick(1)
