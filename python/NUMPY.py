
import numpy as np
import sys, time, math

def Py_Brain():
    ############################
    # pybrain
    ############################
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    from matplotlib.colors import ListedColormap
    import itertools
    from scipy import linalg

    from pybrain.rl.environments.mazes import Maze, MDPMazeTask
    from pybrain.rl.learners.valuebased import ActionValueTable
    from pybrain.rl.agents import LearningAgent
    from pybrain.rl.learners import Q, SARSA
    from pybrain.rl.experiments import Experiment
    from pybrain.rl.environments import Task

    import pylab
    #pylab.gray()
    #pylab.ion()

    '''
    structure = np.array([[1, 1, 1, 1, 1, 1, 1, 1, 1],
                          [1, 0, 0, 1, 0, 0, 0, 0, 1],
                          [1, 0, 0, 1, 0, 0, 1, 0, 1],
                          [1, 0, 0, 1, 0, 0, 1, 0, 1],
                          [1, 0, 0, 1, 0, 1, 1, 0, 1],
                          [1, 0, 0, 0, 0, 0, 1, 0, 1],
                          [1, 1, 1, 1, 1, 1, 1, 0, 1],
                          [1, 0, 0, 0, 0, 0, 0, 0, 1],
                          [1, 1, 1, 1, 1, 1, 1, 1, 1]])
    '''
    structure = np.array([[1, 1, 1, 1, 1],
                          [1, 1, 0, 0, 1],
                          [1, 1, 0, 1, 1],
                          [1, 0, 0, 1, 1],
                          [1, 1, 1, 1, 1]])

    num_states = int(structure.shape[0]*structure.shape[1])
    SQRT = int(math.sqrt(num_states))
    #print structure.item((1, 3))
    #environment = Maze(structure, (7, 7)) #second parameter is goal field tuple
    environment = Maze(structure, (1, 3)) #second parameter is goal field tuple
    print type(environment)
    print environment
    # Standard maze environment comes with the following 4 actions:
    # North, South, East, West
    controller = ActionValueTable(num_states, 4) #[N, S, E, W] 
    controller.initialize(1)

    learner = Q()
    agent = LearningAgent(controller, learner)
    np.not_equal(agent.lastobs, None)
    task = MDPMazeTask(environment)
    experiment = Experiment(task, agent)

    #while True:
    for x in range(4):
        print x
        experiment.doInteractions(10)
        agent.learn()
        agent.reset()

        pylab.pcolor(controller.params.reshape(num_states,4).max(1).reshape(SQRT,SQRT))
        pylab.draw()
        #pylab.show()
        name='MAZE'
        plt.savefig(str(name)+'_PLOT.png')
    plt.close()


def Check_Grid_Idx(grid, idx):
    is_valid = True

    try:
        grid[idx]
        if idx[0] < 0 or idx[1] < 0:
            is_valid = False
            #print '1 here', idx, grid[idx]
        elif np.isnan(grid[idx]):
            is_valid = False
        else:
            is_valid = True
            #print 'TRUE'
    except:
        is_valid = False
        #print '2 here', idx, grid[idx]

    return is_valid

def NUMPY():
    #############################
    # mdptoolbox
    #############################
    import mdptoolbox
    import mdptoolbox.example

    x = np.arange(27, dtype=np.float).reshape((3, 3, 3))
    np.array_split(x, 3)
    #x = np.indices((3,3))

    print x.shape, x.dtype, x[1,0]
    print x
    #x[:,:,1] = 0    #Middle Col
    #x[:,:1] = 1     #Top Row

    x = np.zeros((2,10,10))
    x = np.zeros((2,4,5))
    x = np.full((2,4,5), 0.01)
    print 'DTYPE', x.dtype

    term_state = []
    for i in range(int(x.shape[0])):
        x[i,0,0]                         = -10.0
        term_state.append( (i,0,0) )

        x[i, 0, x.shape[2]-1]            =  10.0
        term_state.append( (i, 0, int(x.shape[2]-1)) )

        x[i, x.shape[1]-1, 0]            =  10.0
        term_state.append( (i, int(x.shape[1]-1), 0) )

        x[i, x.shape[1]-1, x.shape[2]-1] = -10.0
        term_state.append( (i, int(x.shape[1]-1), int(x.shape[2]-1)) )

        x[i, x.shape[1]/2-1 : x.shape[1]/2+1,
             x.shape[2]/2-1 : x.shape[2]/2+1] = np.NaN
    print '\n================'
    print x
    print term_state
    print x.shape
    for idx, val in np.ndenumerate(x):
        pass
        #start_state = idx
        #print 'HERE', start_state, start_state[1], '--', x.shape[0], x.shape[1], x.shape[2]
        #print ((x.shape[2]*start_state[1]) + start_state[2] + start_state[0]) +\
        #      ((x.shape[1]*x.shape[2]*start_state[0]) - start_state[0])

    print '\n================'
    a = np.random.randint(0,5,(3,3))
    ua, uind = np.unique(a,return_inverse=True)
    count = np.bincount(uind)
    print a
    print '\n', ua, count


#############################
def main():
    #Py_Brain()
    NUMPY()

if __name__ == '__main__':
    main()
#############################
