#import matlab.engine
import pygame

#eng = matlab.engine.connect_matlab()

SQUARE_SIZE = 50
GREEN = (0, 255, 0)

pygame.init()
dis = pygame.display.set_mode((10*SQUARE_SIZE, 10*SQUARE_SIZE))
clock = pygame.time.Clock()

pygame.draw.rect(dis, GREEN, [0, 0, 1*SQUARE_SIZE, 1*SQUARE_SIZE])
pygame.display.update()

clock.tick(1)