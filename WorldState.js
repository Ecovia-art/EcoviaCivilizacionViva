import { WorldState } from './WorldState.js';

const world = new WorldState();
const TIME_STEP = 999990;

// Referencias a los elementos de la interfaz
const popEl = document.getElementById('pop-val');
const resEl = document.getElementById('res-val');
const polEl = document.getElementById('pol-val');
const stabEl = document.getElementById('stab-val');

function updateUI() {
    popEl.textContent = Math.floor(world.population);
    resEl.textContent = Math.floor(world.naturalResources);
    polEl.textContent = Math.floor(world.pollution);
    stabEl.textContent = Math.floor(world.stability);
}

// Acciones del usuario via botones
document.getElementById('btn-plant').addEventListener('click', () => {
    world.pollution = Math.max(0, world.pollution - 5); // Reduce contaminación
    world.naturalResources += 20; // Aumenta ligeramente los recursos
    updateUI();
    console.log("¡Árbol plantado! Baja la contaminación.");
});

document.getElementById('btn-factory').addEventListener('click', () => {
    world.pollution += 10; // Aumenta la contaminación
    world.population += 10; // Aumenta la población
    updateUI();
    console.log("¡Fábrica construida! Sube la población y la contaminación.");
});

// Bucle de juego principal
function gameLoop() {
    world.update();
    updateUI();

    if (world.stability <= 0) {
        console.warn("¡La civilización ha colapsado!");
        return;
    }

    setTimeout(gameLoop, TIME_STEP);
}

// Iniciar simulación e interfaz
updateUI();
setTimeout(gameLoop, TIME_STEP);