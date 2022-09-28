import PySimpleGUI as sg
import numpy as np

# See Also:
# https://github.com/PySimpleGUI/PySimpleGUI/blob/master/DemoPrograms/Demo_Graph_Element.py


# \\  -------- PYSIMPLEGUI INIT -------- //

sg.theme('LightBrown11')
layout = [[sg.Graph(canvas_size=(600, 600),
                    graph_bottom_left=(-105, -105),
                    graph_top_right=(105, 105),
                    background_color='#FCF2EA',
                    key='graph')]]

window = sg.Window('RandomSample', layout,
                   grab_anywhere=True,
                   finalize=True)
graph = window['graph']


# \\  -------- MAKE SYNTH DATA -------- //

# VARS:
dataSize = 100
dataRangeMin = -100
dataRangeMax = 100

xData = np.random.randint(dataRangeMin, dataRangeMax, size=dataSize)
yData = np.linspace(dataRangeMin, dataRangeMax, num=dataSize, dtype=int)


# METHODS

def drawAxis():
    graph.DrawLine((dataRangeMin, 0), (dataRangeMax, 0))
    graph.DrawLine((0, dataRangeMin), (0, dataRangeMax))


def drawTicks(step):
    for x in range(dataRangeMin, dataRangeMax+1, step):
        graph.DrawLine((x, -3), (x, 3))
        if x != 0:
            graph.DrawText(x, (x, -10), color='black')
    for y in range(dataRangeMin, dataRangeMax+1, step):
        graph.DrawLine((-3, y), (3, y))
        if y != 0:
            graph.DrawText(y, (-10, y), color='black')


def drawPlot():
    for i, y in enumerate(yData):
        yCoord = y
        xCoord = xData[i]
        graph.DrawCircle((xCoord, yCoord),
                         1, line_color='#F1948A', fill_color='#F1948A')


# CALL METHODS:
drawAxis()
drawTicks(20)
drawPlot()

# PysimpleGUI loop:
event, values = window.read()