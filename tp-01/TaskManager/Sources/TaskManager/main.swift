import TaskManagerLib

let taskManager = createTaskManager()

// Les places
let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

// Les transitions
let create  = taskManager.transitions.first { $0.name == "create" }!
let success = taskManager.transitions.first { $0.name == "success" }!
let exec    = taskManager.transitions.first { $0.name == "exec" }!
let fail    = taskManager.transitions.first { $0.name == "fail" }!
let spawn   = taskManager.transitions.first { $0.name == "spawn" }!

// (Autre patern : cr sp ex sp ex su)
// Pour avoir un problème on met 1 jeton dans taskPool et 2 jetons dans
// processPool

print("\nPremier reseau avec le probleme des processus :\n")

let m1 = create.fire(from : [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)
// On a 1 jeton dans taskPool
let m2 = spawn.fire(from: m1!)
print(m2!)
let m3 = spawn.fire(from: m2!)
print(m3!)
// On a 2 jetons dans processPool
let m4 = exec.fire(from: m3!)
print(m4!)
let m5 = exec.fire(from: m4!)
print(m5!)
// On execute 2 fois
let m6 = success.fire(from: m5!)
print(m6!)
// On tire 1 fois success
print("\nPROBLEME: 1 processus en attente !\n")

// On remarque ainsi qu'un processus est bloqué en inProgress ce qui montre bien
// notre probleme. Les processus peuvent tourner dans "le vide" a ce stade

print("\nDeuxieme reseau avec le probleme des processus resolu :\n")

let correctTaskManager = createCorrectTaskManager()

// Les places
let taskPool2    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPool2 = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgress2  = correctTaskManager.places.first { $0.name == "inProgress" }!
// Avec la nouvelle place creee auparavant
let compt2       = correctTaskManager.places.first { $0.name == "compt" }!

// Les transitions
let create2  = correctTaskManager.transitions.first { $0.name == "create" }!
let success2 = correctTaskManager.transitions.first { $0.name == "success" }!
let exec2    = correctTaskManager.transitions.first { $0.name == "exec" }!
let fail2    = correctTaskManager.transitions.first { $0.name == "fail" }!
let spawn2   = correctTaskManager.transitions.first { $0.name == "spawn" }!

// L'etat initial comporte 1 jeton dans la nouvelle place
let m8  = create2.fire(from: [taskPool2:  0, processPool2: 0, inProgress2: 0, compt2: 1])
print(m8!)
let m9  = spawn2.fire(from: m8!)
print(m9!)
// On tire une deuxieme fois avec spawn2
let m10 = spawn2.fire(from: m9!)
print(m10!)
// On tire 1 fois exec2
let m11 = exec2.fire(from: m10!)
print(m11!)

//let m12 = exec2.fire(from: m11!)
//print(m12!)

// Puis si on veut retirer exec2, alors ceci donne une ERREUR

// Donc, si la transition n'est pas tirable, alors on revoie ce message
if (exec2.fire(from: m11!)) == nil{
  print("\nERREUR, TRANSITION NON FRANCHISSABLE !\n")
}
