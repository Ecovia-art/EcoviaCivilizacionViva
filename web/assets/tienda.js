// Función para iniciar la compra de un producto en la tienda de Amazon
function comprarProductoAmazon(skuProducto) {
    console.log("Iniciando solicitud de compra para el SKU:", skuProducto);
    
    if (typeof amazon !== 'undefined' && amazon.inAppPurchasing) {
        amazon.inAppPurchasing.purchaseResponse(skuProducto, function (response) {
            if (response.purchaseStatus === "SUCCESSFUL") {
                console.log("¡Compra exitosa! Otorgando beneficio al usuario:", skuProducto);
                otorgarRecompensa(skuProducto);
            } else if (response.purchaseStatus === "ALREADY_ENTITLED") {
                console.log("El usuario ya posee este producto.");
                otorgarRecompensa(skuProducto);
            } else {
                console.log("La compra no se pudo completar o fue cancelada:", response.purchaseStatus);
            }
        });
    } else {
        console.warn("Entorno de Amazon IAP no detectado. Simulando compra en entorno de prueba.");
        simularCompraLocal(skuProducto);
    }
}

function otorgarRecompensa(sku) {
    switch(sku) {
        case 'ecovia.pack.starter':
            console.log("Añadido: Paquete de Arranque (Gemas + Recursos)");
            break;
        case 'ecovia.boost.autoenergy':
            console.log("Activado: Suministro automático de energía");
            break;
        case 'ecovia.skin.biomes':
            console.log("Desbloqueado: Pase de Diseñador de Biomas");
            break;
        default:
            console.log("Producto desconocido.");
    }
}

function simularCompraLocal(sku) {
    setTimeout(function() {
        otorgarRecompensa(sku);
        alert("¡Compra simulada con éxito para: " + sku + "!");
    }, 500);
}
