import argparse

from networkx.generators.random_graphs import gnm_random_graph
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
        self.sequence = sequence
        self.generator = EdgeSwitchingMarkovChain(self.sequence)
        self.graph = None

    def run(self):
        self.graph = self.generator.generate()

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
        self.sequence = sequence
        self.generator = HavelHakimiGenerator(self.sequence)
        self.graph = None

    def run(self):
        graph = self.generator.generate()

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
        self.n = n
        self.p = p
        self.generator = ErdosRenyiGenerator(n, p, directed = False, selfLoops=False)
        self.graph = None

    def run(self):
        #assert
        graph = self.generator.generate()

class GNM(AbstractGraphGenerator):
    """ Wrapper of Networkx gnm_random_graph
    Parameters:
    -----------
        n: int
            number of nodes
        m: int
            number of edges
        seed: int
            random seed
    """
    def __init(self, **kwargs):
        self.n = n
        self.m = m
        self.seed = seed if not None else None

    def run(self):
        self.graph = gnm_random_graph(n, m, seed=None, directed=False)
