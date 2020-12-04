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
        self.duration = kwargs['duration']

    def run(self):
        raise NotImplementedError

class FromDataset(AbstractTSGenerator):
    """ Extract parameters from real dataset
        Can be plugged in with other models
        
        Attributes:
        -----------
        dataset: str
            path to the input timeserie, stored as a text files with the following format
                t1 val1
                t2 val2
                t3 val3
                .
                .
                .

            where ti is the ith timestamps, and vali is the time series value at time ti.
    """
    def __init__(self, **kwargs):
        self.dataset = kwargs['dataset']
        self.timeserie = []

    def read_input(self):
        with open(self.dataset, 'r') as fin: ## put other option to read gz
            data = fin.readlines()
            for line in data:
                t, v = line.strip().split()
                self.timeserie.append((float(t), float(v)))

    @parameter
    def duration(self):
         """ assuming timeserie well ordered... """
         return self.timeserie[-1][0] - self.timeserie[0][0]

    @parameter
    def value_distribution(self):
        return [val for t, val in self.timeserie]

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
