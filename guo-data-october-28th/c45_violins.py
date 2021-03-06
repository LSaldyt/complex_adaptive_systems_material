#!/usr/bin/env python3
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib
import pandas
import math
import sys

sns.set_style('darkgrid')

def main(args):
    # Colony 45
    experiment = pandas.read_csv('C45Active1C.csv')
    control    = pandas.read_csv('C45Control1C.csv')
    # Colony 71
    # experiment = pandas.read_csv('C71Active1C.csv')
    # control    = pandas.read_csv('C71Control1C.csv')

    #plot_original(experiment, control)

    experiment['type'] = 'experiment'
    control['type']    = 'control'
    data = pandas.concat([experiment, control])
    data['second'] = data['frames'] // 30 # Convert frames to seconds
    data['period'] = data['second'] // 20 # Define a period as thirty seconds
    print(data)
    #data = data.groupby('period')

    #data['speed'] = data['speed (px/s)'].apply(lambda x :  0 if x < 1e-7 else max(0, math.log(x, 10)))
    data['speed'] = data['speed (px/s)'].apply(lambda x : max(0, min(x, 5)))
    sns.violinplot(x='period', y='speed', hue='type', data=data, palette='muted', split=True)
    plt.xlabel('Period (20 seconds)')
    plt.ylabel('Distribution of speeds in pixels/second')
    plt.title('Changes in the distribution of speeds over time for colony 45')
    #plt.yticks(ticks=[0.5, 1.0, 1.5, 2.0], labels=['0.5', '1.0', '1.5', '2.0+'])
    fig = matplotlib.pyplot.gcf()
    fig.set_size_inches(8, 5)
    fig.savefig('c45_violins', dpi=300)
    #plt.savefig('violin.png')
    plt.show()

def plot_original(experiment, control):
    print(experiment.columns.values)
    print(control.columns.values)

    experiment_means = experiment.groupby('frames').mean()
    control_means    = control.groupby('frames').mean()

    experiment_frames = experiment[experiment.id == 1]['frames'][1:]
    experiment_speeds = experiment_means['speed (px/s)'][1:]
    control_frames    = control[control.id == 1]['frames'][1:]
    control_speeds    = control_means['speed (px/s)'][1:]

    plt.plot(experiment_frames, experiment_speeds, color='orange')
    plt.plot(control_frames, control_speeds, color='black')
    plt.xlabel('Frames (30hz)')
    plt.ylabel('Average speed (px/s)')
    plt.title('Comparison between alarmed and control for colony 45 setting 1')
    plt.savefig('test.png')
    plt.show()

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
