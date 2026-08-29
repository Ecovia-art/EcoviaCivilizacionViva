// Carga del script de Pixel Art
import { PixelShader } from "./pixel_art_shader.js";
import { EffectComposer } from "https://unpkg.com/three@0.150.0/examples/jsm/postprocessing/EffectComposer.js";
import { RenderPass } from "https://unpkg.com/three@0.150.0/examples/jsm/postprocessing/RenderPass.js";
import { ShaderPass } from "https://unpkg.com/three@0.150.0/examples/jsm/postprocessing/ShaderPass.js";
// --- CONFIGURACIÓN BÁSICA DE THREE.JS ---
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x0f141d);
scene.fog = new THREE.FogExp2(0x0f141d, 0.025);

const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.set(0, 12, 22);
camera.lookAt(0, 1, 0);

const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

// --- ILUMINACIÓN ---
const ambientLight = new THREE.AmbientLight(0xffffff, 0.7);
scene.add(ambientLight);

const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
directionalLight.position.set(10, 20, 15);
scene.add(directionalLight);

// --- SUELO / CUADRÍCULA ---
const gridHelper = new THREE.GridHelper(20, 20, 0x00ffcc, 0x444444);
scene.add(gridHelper);

const planeGeometry = new THREE.PlaneGeometry(20, 20);
const planeMaterial = new THREE.MeshBasicMaterial({ color: 0x1b2838, side: THREE.DoubleSide });
const plane = new THREE.Mesh(planeGeometry, planeMaterial);
plane.rotation.x = Math.PI / 2;
scene.add(plane);

// --- CARGADOR DE MODELOS 3D (GLTF) ---
const loader = new THREE.GLTFLoader();

// Cargamos tu modelo eólico directamente desde la carpeta images
loader.load(
    './images/heolico.glb', 
    function (gltf) {
        const eolico = gltf.scene;
        eolico.position.set(0, 0, 0); // Lo colocamos en el centro de prueba
        eolico.scale.set(1, 1, 1);    // Escala del modelo
        scene.add(eolico);
        console.log("¡Eólico cargado con éxito en la escena!");
    },
    undefined,
    function (error) {
        console.error('Error al cargar el modelo 3D:', error);
    }
);

// --- BUCLE DE ANIMACIÓN ---
function animate() {
    requestAnimationFrame(animate);
    renderer.render(scene, camera);
}
animate();

// --- ADAPTABILIDAD A LA PANTALLA ---
window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});localStorage.setItem('credits', '50000');
localStorage.setItem('credits', '99999');
