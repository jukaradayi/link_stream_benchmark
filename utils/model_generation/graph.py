import argparse

from networkit.generators import EdgeSwitchingMarkovChainGenerator, HavelHakimiGenerator, ErdosRenyiGenerator

class AbstractGraphGenerator():
    """ Abstract Class for graph Generators
        Generate a random graph, picked uniformely, given a number of nodes,
        a number of edges, and a degree sequence.
        Attributes:
        -----------
        n : int
            the number of nodes 
        m : int
            the number of edges
        seq : list of int
            the degree sequence

    """
    def __init__(self, **kwargs):
        self.n = None
        self.m = None
        self.seq = None

    def is_realisable():
        raise NotImplementedError

    def run(self):
        raise NotImplementedError


class EdgeSwitchingMarkovChain(AbstractGraphGenerator):
    """ Wrapper of Networkit EdgeSwitchingMarkovChainGenerator
        TODO
        Parameters:
        -----------
        degreeSequence : vector[count]
            The degree sequence that shall be generated
        ignoreIfRealizable : bool, optional
            If true, generate the graph even if the degree sequence is not realizable. Some nodes may get lower degrees than requested in the sequence.
    """

    def __init__(self, **kwargs):
        pass

    def run(self):
        assert
        assert
        EdgeSwitchingMarkovChainGenerator.fit()

class HavelHakimi(AbstractGraphGenerator):
    """ Wrapper of Networkit HavelHakimi
        TODO
        Parameters:
        -----------
        sequence : vector
            Degree sequence to realize. Must be non-increasing.
        ignoreIfRealizable : bool, optional
            If true, generate the graph even if the degree sequence is not realizable. Some nodes may get lower degrees than requested in the sequence.
    """

    def __init__(self, **kwargs):
        pass

    def run(self):
        assert
        assert
        HavelHakimiGenerator.fit()

class ErdosRenyi(AbstractGraphGenerator):
    """ Wrapper of Networkit ErdosRenyiGenerator
        TODO
        Parameters:
           -----------
           nNodes : count
               Number of nodes n in the graph.
           prob : double
               Probability of existence for each edge p.
           directed : bool
               Generates a directed
           selfLoops : bool
               Allows self-loops to be generated (only for directed graphs)
    """   
    def __init__(self, **kwargs):
        pass

    def run(self):
        assert
        assert
        ErdosRenyiGenerator.fit()

