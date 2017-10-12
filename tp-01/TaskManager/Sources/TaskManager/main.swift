// SARDINHA Patrick
import TaskManagerLib

let taskManager = createTaskManager()

// Declaration des places
let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

// Declaration des transitions
let create  = taskManager.transitions.first { $0.name == "create" }!
let success = taskManager.transitions.first { $0.name == "success" }!
let exec    = taskManager.transitions.first { $0.name == "exec" }!
let fail    = taskManager.transitions.first { $0.name == "fail" }!
let spawn   = taskManager.transitions.first { $0.name == "spawn" }!

// (Autre patern : cr sp ex sp ex su)

// Pour avoir un exemple d'execution qui conduirait au problème de la figure
// donnee on commence par mettre 1 jeton dans taskPool et 2 jetons dans
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
// Puis, on execute 2 fois

let m6 = success.fire(from: m5!)
print(m6!)
// On tire 1 fois success

print("\nPROBLEME: 1 processus en attente !\n")
// On remarque ainsi qu'un processus est bloqué dans inProgress ce qui défini
// notre probleme. En effet, nous n'avons plus de tache dans le taskPool mais
// un processus en attente
// Ainsi, nous avons un probleme si nous essayons de retirer success


print("\nDeuxieme reseau avec le probleme des processus resolu :\n")
// Afin de corriger le probleme du dessus, nous devons faire en sorte que la
// place inProgress ne puisse posseder qu'un seul jeton en meme temps.
// Nous creons donc une nouvelle place afin de limiter le nombre d'execution des
// processus

let correctTaskManager = createCorrectTaskManager()

// Declaration des places
let taskPool2    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPool2 = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgress2  = correctTaskManager.places.first { $0.name == "inProgress" }!
// Declaration de la nouvelle place creee dans le fichier TaskManagerLib
let compt2       = correctTaskManager.places.first { $0.name == "compt" }!

// Declaration des transitions
let create2  = correctTaskManager.transitions.first { $0.name == "create" }!
let success2 = correctTaskManager.transitions.first { $0.name == "success" }!
let exec2    = correctTaskManager.transitions.first { $0.name == "exec" }!
let fail2    = correctTaskManager.transitions.first { $0.name == "fail" }!
let spawn2   = correctTaskManager.transitions.first { $0.name == "spawn" }!

// L'etat initial comporte 1 jeton dans la nouvelle place
let m8  = create2.fire(from: [taskPool2:  0, processPool2: 0, inProgress2: 0, compt2: 1])
print(m8!)
// On a 1 jeton dans taskPool

let m9  = spawn2.fire(from: m8!)
print(m9!)
let m10 = spawn2.fire(from: m9!)
print(m10!)
// On a 2 jetons dans processPool

let m11 = exec2.fire(from: m10!)
print(m11!)
// On tire 1 fois exec2

//let m12 = exec2.fire(from: m11!)
//print(m12!)

// Puis si on veut retirer exec2, alors ceci donne une ERREUR car la transition
// n'est plus tirable grace a la nouvelle place

// Donc, si la transition n'est pas tirable, alors on revoie ce message
if (exec2.fire(from: m11!)) == nil{
  print("\nERREUR, TRANSITION NON FRANCHISSABLE !\n")

// Ainsi le probleme est corrige pour la meme sequence de transitions
}
