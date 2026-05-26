from scipy.optimize import differential_evolution
import numpy as np
from io import StringIO

# raw data copied from the excel file
agent_count = 1
raw = """10630.75	653.75
6522	337
4758	208
#N/A	#N/A
3076.25	58.25
#N/A	#N/A
1965.75	178.75
1594.75	48.75

"""
raw = raw.replace("#N/A", "nan")
raw = raw.replace("#DIV/0!", "nan")
data = np.genfromtxt(StringIO(raw), delimiter=None, skip_header=0) # load into numpy array, with #N/A and #DIV/0! treated as NaN

cores = np.array([0, 4, 8, 12, 16, 24, 32, 64])
agents = np.array([0,1,4,8])
measured = data[:, 0]
deviation = data[:, 1]
mask = ~np.isnan(measured) # Load data and mask nan values

def core_objective(params):
    A, B, C = params
    predicted = A + B / (agent_count * cores[mask] + C)
    error = np.sum((measured[mask] - predicted)**2)
    lower_bound = measured[mask] - deviation[mask]
    penalty= np.sum(np.maximum(0, lower_bound - predicted)**2) * 1e6 # constraint applied through extreme penalty
    return error + penalty

def agent_objective(params):
    A, B, C = params
    predicted = A + B / (agents[mask] + C)
    error = np.sum((measured[mask] - predicted)**2)
    lower_bound = measured[mask] - deviation[mask]
    penalty= np.sum(np.maximum(0, lower_bound - predicted)**2) * 1e6
    return error + penalty

result = differential_evolution(core_objective, bounds=[(0, 2000), (0, 100000), (0.01, 20)], seed=1, maxiter=100000, tol=1e-9, popsize=100) # perform evolution with specified bounds and parameters
print(f"Optimal parameters: A={result.x[0]:.2f}, B={result.x[1]:.2f}, C={result.x[2]:.2f}, Error^2={result.fun:.2f}") # print results
