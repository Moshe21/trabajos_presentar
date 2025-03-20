class PalabrasEspanol {
  static const List<String> palabras = [
    'cielo',
    'amigo',
    'familia',
    'felicidad',
    'amor',
    'casa',
    'libro',
    'música',
    'comida',
    'espejo',
    'hermano',
    'ciudad',
    'feliz',
    'estrella',
    'paz',
    'noche',
    'día',
    'sol',
    'luna',
    'flor',
  ];

  static List<String> favoritas = [];
  

   static List<String> obtenerPalabras() {
    return palabras;
   }
   static String obtenerPalabraAleatoria() {
    final randomIndex = (DateTime.now().millisecondsSinceEpoch % palabras.length);
    return palabras[randomIndex];
   }
}