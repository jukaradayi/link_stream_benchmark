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
    def __init__(self, duration):
        self.duration = duration
        self.bound_up = bound_up
        self.bound_down = bound_down

    def run():
        return ((self.bound_up - self.bound_down) 
                * np.random.random_sample(size=(self.duration,)) 
                + self.bound_down)

class RandomWalk(AbstractTSGenerator):
    """ Generate Random Walk

        Attributes:
        ----------
        duration: int
    """
    def __init__(self, duration, prob=[0.05, 0.95]):
        # Probability to move up or down 
        self.prob = prob
        self.duration = duration

    def run():
          
        # statically defining the starting position 
        #start = 0 
        positions = [0] 
          
        # creating the random points 
        random_pick = np.random.random(self.duration) 
        down_pos = random_pick < prob[0] 
        up_pos = random_pick > prob[1] 
          
        for idownp, iupp in zip(down_pos, up_pos): 
            down = idown_pos # and positions[-1] > 1
            up = iup_pos # and positions[-1] < 4
            positions.append(positions[-1] - down + up) 
        return positions

def main(value_sequence, model_type ):
    

if __name__ == "__main__":
    main()
