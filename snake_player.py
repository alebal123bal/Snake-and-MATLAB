import matlab.engine

eng = matlab.engine.connect_matlab()

print(eng.sqrt(4.0))