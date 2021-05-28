from FaceRecognitionEmployeeSure import faceVerification
from FaceRecognitionEmployeeSure import captureImages
from FaceRecognitionEmployeeSure import training


THRESHOLD_CONFIDENCE = 30


# Use este método para tirar as fotos de cadastro do usuário 
# ele cria uma pasta e salva as imagens dentro dela
#captureImages("Test")


# Use este método para treinar o modelo
# o parâmetro é a pasta onde estão todas as subpastas com os nomes dos usuários e dentro as fotos de cada um
# o modelo é salvo dentro uma pasta "model" e depois é lido durante a verificação, sem precisar retreiná-lo
#training('imagesTraining')


# Use este método para testar uma foto
# ele retorna o nome do usuário e o nível de confiança no cálculo
# pelos testes que fiz, o valor de 30 estava bom, mas podemos fazer mais testes
label, confidence = faceVerification('images/frame16.jpg')

if confidence >= THRESHOLD_CONFIDENCE:
    print(label)
    print(confidence)
else:
    print('Image Out of Standard')