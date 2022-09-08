import PySimpleGUI as sg
import numpy as np


# \\  -------- PYSIMPLEGUI INIT -------- //

sg.theme('LightBrown11')
layout = [[sg.Graph(canvas_size=(600, 600),
                    graph_bottom_left=(-20, -20),
                    graph_top_right=(110, 110),
                    background_color='#F1D7AB',
                    key='graph')]]

window = sg.Window('LinearPlot', layout,
                   grab_anywhere=True,
                   finalize=True)
graph = window['graph']


# \\  -------- MAKE SYNTH DATA -------- //

# VARS:
dataSize = 40
dataRangeMin = 0
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
    prev_x = prev_y = None
    for i, xCoord in enumerate(yData):
        yCoord = xData[i]
        if prev_x is not None:
            graph.draw_line((prev_x, prev_y), (xCoord, yCoord),
                            color='#595959', width=1.8)
        prev_x, prev_y = xCoord, yCoord


# CALL METHODS:
drawAxis()
drawTicks(20)
drawPlot()

# PysimpleGUI loop:
event, values = window.read()