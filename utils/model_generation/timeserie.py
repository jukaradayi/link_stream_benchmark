"""
TODO DEFINE INPUT PARAMETERS
"""

import os
import sys
import numpy as np

class AbstractTSGenerator():
    """ Abstract Class for timeseries Generators
        Generate a random timeserie, picked uniformely, given ...? TODO

        Attributes:
        -----------
        duration: int,
            number of values to be generated
        TODO

    """
    def __init__(self, **kwargs):
        self.duration = duration

    def run(self):
        raise NotImplementedError

class IidNoise(AbstractTSGenerator):
    """ Generate IID noise

        Attributes:
        ----------
        duration: int
        TODO
    """
    #def __init__(self, duration, bound_up, bound_down):
    def __init__(self, **kwargs):
        self.duration = kwargs['duration']
        self.bound_up = kwargs['bound_up']
        self.bound_down = kwargs['bound_down']

    def write_TS(self):
        print(self.time_serie)

    def run(self):
        self.time_serie = ((self.bound_up - self.bound_down) 
                * np.random.random_sample(size=(self.duration,)) 
                + self.bound_down)
        

class RandomWalk(AbstractTSGenerator):
    """ Generate Random Walk

        Attributes:
        ----------
        duration: int
    """
    def __init__(self, **kwargs, ):
        # Probability to move up or down 
        self.prob = kwargs['prob']
        self.duration = kwargs['duration']

    def write_TS(self):
        print(self.time_serie)

    def run(self):
          
        # statically defining the starting position 
        #start = 0 
        self.time_serie = [0] 
          
        # creating the random points 
        random_pick = np.random.random(self.duration) 
        down_pos = random_pick < self.prob[0] 
        up_pos = random_pick > self.prob[1] 
          
        for idown_pos, iup_pos in zip(down_pos, up_pos): 
            down = idown_pos # and positions[-1] > 1
            up = iup_pos # and positions[-1] < 4
            self.time_serie.append(self.time_serie[-1] - down + up) 

#def main(value_sequence, model_type ):
    

if __name__ == "__main__":
    main()
