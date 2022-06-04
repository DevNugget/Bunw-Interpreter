import strutils
import utils

var lineSeq = newSeq[string](0)
var isDone = false
var counter = 0
var fRetLine: int = 0
var memStk = newSeq[int](0)
var strMem = newSeq[string](0)
var floMem = newSeq[float](0)
var bolMem = newSeq[bool](0)
var fncIdx = newSeq[int](0)

for line in lines("program.kq"):
    lineSeq.add(line)

while not isDone:
    if lineSeq[counter].startsWith("push "):
        var sepSeq = lineSeq[counter].split(" ")
        try:
            memStk.add(parseInt($sepSeq[1]))
        except:
            makeLangError(
                "Error:      while pushing item to stack",
                "Suggestion: is item of type int?",
                counter
            )

    elif lineSeq[counter].startsWith("f"):
        try:
            fncIdx.add(counter)
            var y = 0
            for x in lineSeq[counter..^1]:
                if x.startsWith("endf"): break
                inc y
            counter = counter + y + 1
        except:
            makeLangError(
                "Error:      while creating function index",
                "Suggestion: is index label of type int?",
                counter
            )

    elif lineSeq[counter].startsWith("cf "):
        var sepSeq = lineSeq[counter].split(" ")
        try:
            fRetLine = counter
            counter = fncIdx[parseInt($sepSeq[1])]
        except:
            makeLangError(
                "Error:      while creating function index",
                "Suggestion: is index label of type int?",
                counter
            )

    elif lineSeq[counter].startsWith("addr"):
        var sepSeq = lineSeq[counter].split(" ")
        if sepSeq[1] == "prts":
            echo strMem[memStk[^1]]
            memStk.delete(memStk.len - 1)

    elif lineSeq[counter].startsWith("endf"):
        counter = fRetLine
        fRetLine = 0

    elif lineSeq[counter].startsWith("dstr"):
        var sepSeq = lineSeq[counter].splitArgs
        strMem.add(sepSeq[1])

    elif lineSeq[counter].startsWith("prts"):
        echo(strMem[^1])
        strMem.delete(strMem.len - 1)

    elif lineSeq[counter].startsWith("puts"):
        stdout.write(strMem[^1])
        memStk.delete(strMem.len - 1)

    elif lineSeq[counter].startsWith("puti"):
        stdout.write(memStk[^1])
        memStk.delete(memStk.len - 1)

    elif lineSeq[counter].startsWith("prti"):
        echo(memStk[^1])
        memStk.delete(memStk.len - 1)

    elif lineSeq[counter].startsWith("itl"):
        var sepSeq = lineSeq[counter].split(" ")
        if sepSeq[1] == "puts":
            echo memStk
        else:
            makeLangError(
                "Error:      while executing internal command",
                "Suggestion: check whether command is supplied or supplied command is valid",
                counter
            )

    elif lineSeq[counter].startsWith("end"):
        isDone = true

    inc counter
