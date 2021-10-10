.pragma library

// these control the game board
var rows = 40;
var cols = 40;

var boardSize = rows * cols;
var objects = Array(boardSize)

function createBlock(parentObject, size, objectIndex) {
    let component = Qt.createComponent("qrc:/Block.qml");
    let properties;
    properties = {x: 0, y: 0, width: size, height: size};
    objects[objectIndex] = component.createObject(parentObject, properties);
}

function clear() {
    for(let i = 0; i < boardSize; i++) {
        objects[i].state = "dead";
    }
}

function toggleState(objectIndex) {
    if(objects[objectIndex].state === "alive") {
        objects[objectIndex].state = "dead"
    }
    else {
        objects[objectIndex].state = "alive"
    }
}

function willLiveNextTurn(objectIndex) {
    let neighbours = [];
    neighbours = neighboursForIndex(objectIndex)
    //console.log(neighbours)
    let cnt = 0;
    var listSize = neighbours.length
    if(listSize !== "undefined") {
        for(let i = 0; i < listSize; i++) {
            let itemNo = neighbours[i];
            if(objects[itemNo].state === "alive") cnt++;
        }
    }

//    if(cnt > 0) console.log(objectIndex + " has " + cnt + " neighbour alive");

    if(objects[objectIndex].state === "alive" && cnt < 2) return false;
    if(objects[objectIndex].state === "alive" && (cnt === 2 || cnt === 3)) return true;
    if(objects[objectIndex].state === "alive" && cnt > 3) return false;
    if(objects[objectIndex].state === "dead" && cnt === 3) return true;

    return false;
}

function neighboursForIndex(objectIndex) {
    //TODO: test / fix this
    if(objectIndex === 0) {
        return [objectIndex + 1,
                objectIndex + cols,
                objectIndex + cols + 1];
    }
    else if(objectIndex < cols - 1) {
        return [objectIndex - 1,
                objectIndex + 1,
                objectIndex + cols - 1,
                objectIndex + cols,
                objectIndex + cols + 1];
    }
    else if(objectIndex === cols - 1) {
        return [objectIndex - 1,
                objectIndex + cols - 1,
                objectIndex + cols];
    }
    else if(objectIndex % cols === 0 && objectIndex !== cols * rows - cols) {
        return [objectIndex + 1,
                objectIndex + cols,
                objectIndex + cols + 1,
                objectIndex - cols,
                objectIndex - (cols - 1)];
    }
    else if(objectIndex < cols * rows - cols && objectIndex % cols !== (cols - 1)) {
        return [objectIndex - 1,
                objectIndex - (cols + 1),
                objectIndex - cols,
                objectIndex - (cols - 1),
                objectIndex + 1,
                objectIndex + (cols - 1),
                objectIndex + cols,
                objectIndex + (cols + 1)];
    }
    else if(objectIndex % cols === (cols - 1) && objectIndex !== (rows * cols - 1)) {
        return [objectIndex - cols,
                objectIndex - (cols + 1),
                objectIndex - 1,
                objectIndex + cols,
                objectIndex + (cols - 1)];
    }
    else if(objectIndex === cols * rows - cols) {
        return [objectIndex - cols,
                objectIndex + 1,
                objectIndex - (cols - 1)];
    }
    else if(objectIndex < (rows * cols - 1) && objectIndex > cols * rows - cols) {
        return [objectIndex - (cols + 1),
                objectIndex - cols,
                objectIndex - (cols - 1),
                objectIndex - 1,
                objectIndex + 1];
    }
    else if(objectIndex === (rows * cols - 1)) {
        return [objectIndex - (cols + 1),
                objectIndex - 10,
                objectIndex - 1];
    }
    else {
        return [];
    }
}

function isAlive(objectIndex) {
    let blockLives = objects[objectIndex].state === "alive";
    return blockLives;
}

function aliveCount() {
    let cnt = 0;
    for(let i = 0; i < boardSize; i++) {
        if(objects[i].state === "alive") cnt++;
    }

    return cnt;
}

function progress() {
//    console.log("alive objects before progressing: " + aliveCount())
    let tmpList = [];
    for(let i = 0; i < boardSize; i++) {
        let ret = willLiveNextTurn(i);
        if(ret) {
            tmpList.push("alive");
        }
        else {
            tmpList.push("dead");
        }
    }

    for(let j = 0; j < boardSize; j++) {
        objects[j].state = tmpList[j];
    }

//    console.log("alive objects after progressing: " + aliveCount())
}
