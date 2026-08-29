// --- SHADER DE POST-PROCESAMIENTO PIXEL ART ---
// Este fragment shader se aplica a toda la escena para pixelarla.
THREE.PixelShader = {
    uniforms: {
        "tDiffuse": { value: null },
        "resolution": { value: new THREE.Vector2() },
        "pixelSize": { value: new 
THREE.Vector2(4, 4) } // Ajusta este valor para cambiar el tamaño del píxel (X, Y)
    },
    vertexShader: \`
        varying vec2 vUv;
        void main() {
            vUv = uv;
            gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
        }
    \`,
    fragmentShader: \`
        uniform sampler2D tDiffuse;
        uniform vec2 resolution;
        uniform vec2 pixelSize;
        varying vec2 vUv;
        void main() {
            vec2 dxy = pixelSize / resolution;
            vec2 coord = dxy * floor( vUv / dxy );
            gl_FragColor = texture2D( tDiffuse, coord );
        }
    \`
};
// --- FIN DEL SHADER ---

// --- CÓDIGO DE INTEGRACIÓN ---
// Esperamos a que el renderer esté disponible y lo modificamos
const intervalId = setInterval(() => {
    if (typeof renderer !== 'undefined') {
        clearInterval(intervalId);
        
        // Añadimos el ShaderPass al Composer
        const composer = new THREE.EffectComposer(renderer);
        const renderPass = new THREE.RenderPass(scene, camera);
        composer.addPass(renderPass);
        
        const pixelPass = new THREE.ShaderPass(THREE.PixelShader);
        composer.addPass(pixelPass);
        
        // --- SOBRESCRITURA DEL BUCLE DE ANIMACIÓN ---
        // Sobrescribimos la función animate() existente para usar el composer
        window.animate = function() {
            requestAnimationFrame(window.animate);
            composer.render();
        };
        // Llamamos a la nueva función una vez
        window.animate();
        console.log("¡Efecto Pixel Art aplicado con éxito!");

        // --- CAMBIO DE SUELO ---
        // Modificamos el suelo para que encaje mejor
        scene.remove(gridHelper); // Quitamos la rejilla antigua
        scene.remove(plane); // Quitamos el plano antiguo

        // Creamos una textura de suelo de rejilla pixel art (un data URI simple)
        const dataUrl = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAIGNIUk0AAHolAACAgwAA+f8AAIDoAAB1MAAA6mAAADqYAAAXb9bvUYQAAAANSURBVHicY2AUYPj/H0wGYAgwMjAwAADoFwXhH18xYQAAAABJRU5ErkJggg==";
        const textureLoader = new THREE.TextureLoader();
        textureLoader.load(dataUrl, function(texture) {
            texture.wrapS = THREE.RepeatWrapping;
            texture.wrapT = THREE.RepeatWrapping;
            texture.repeat.set(20, 20); // Repetimos la textura 20x20 veces
            
            const planeMaterial = new THREE.MeshBasicMaterial({ 
                map: texture, 
                color: 0x1b2838, // Color base oscuro
                side: THREE.DoubleSide 
            });
            const newPlane = new THREE.Mesh(planeGeometry, planeMaterial);
            newPlane.rotation.x = Math.PI / 2;
            scene.add(newPlane);
            console.log("¡Suelo de rejilla pixel art aplicado!");
        });

    }
}, 100);
