import numpy as np
import csv
import cv2
import os
import time
import boto3
from django.conf import settings

if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
    PATH_MODEL = 'media/model/trainnedModel.yml'
    PATH_MODEL_LABELS = 'media/model/labels.csv'
else:
    PATH_MODEL = os.path.join(settings.MEDIA_ROOT,'model/trainnedModel.yml')
    PATH_MODEL_LABELS = os.path.join(settings.MEDIA_ROOT,'model/labels.csv')

def training(trainingFolder):
    faces, label_ids = faceExtraction(trainingFolder)
    trainClassifier(faces, label_ids)

def faceDetection(image):
    scale = 1.35    # how much the image size is reduced at each image scale
    minNg = 4       # how many neighbors each candidate rectangle should have to retain it

    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
    faces_detected = face_cascade.detectMultiScale(gray_image,
                                                   scaleFactor = scale,
                                                   minNeighbors = minNg)
    return faces_detected, gray_image

def faceExtraction(imgTrainingPath):
    labels = {}
    current_id = 0
    label_ids = []
    faces = []

    if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
        s3 = boto3.resource('s3')
        my_bucket = s3.Bucket('empsure-static-media')
        listImages = []
        for object_summary in my_bucket.objects.filter(Prefix="media/baseline/"):
            listImages.append(object_summary.key)
            print("object_summary.key {}".format(object_summary.key))
    else:
        listImages = os.listdir(imgTrainingPath)

    for filename in listImages:
        print("filename {}".format(filename))
        if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
            s3_client = boto3.client('s3')
            tempname = filename.split("/")[-1]
            s3_client.download_file('empsure-static-media',filename,tempname)
            image = cv2.imread(tempname)
        else:
            image = cv2.imread(os.path.join(imgTrainingPath,filename))
        label = int(filename.split("_")[1])

        # print(image)
        # print(os.path.join(imgTrainingPath,filename))
        print("filename {}".format(filename))
        print("label {}".format(label))

        if not label in labels:
            labels[label] = current_id
            current_id += 1

        print("processing image: ", f'{filename}')
        faces_detected_obj, gray_image = faceDetection(image)
        # print(type(faces_detected_obj))
        if type(faces_detected_obj) is np.ndarray:
            faces_detected = faces_detected_obj[0]
            if faces_detected.any() and gray_image.any():
                (x, y, w, h) = faces_detected
                faces_detail = gray_image[y:y+w, x:x+h]
                faces.append(faces_detail)
                label_ids.append(label)
            else:
                print("face not detected")
        else:
            print("face not detected")

    if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
        with open("temp_labels.csv",'w') as file:
            for k, v in labels.items():
                line = str(k) + ',' + str(v)
                file.write(line)
                file.write('\n')
        file.close()
        s3_client = boto3.client('s3')
        s3_client.upload_file('temp_labels.csv','empsure-static-media',PATH_MODEL_LABELS)
    else:
        with open(PATH_MODEL_LABELS,'w') as file:
            for k, v in labels.items():
                line = str(k) + ',' + str(v)
                file.write(line)
                file.write('\n')
        file.close()

    print(label_ids)
    return faces, label_ids

def trainClassifier(faces, label_ids):
    face_recognizer = cv2.face.LBPHFaceRecognizer_create()
    print(label_ids)
    # print(np.array(label_ids))
    # print(type(label_ids))
    if label_ids:
        if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
            face_recognizer.train(faces, np.array(label_ids))
            face_recognizer.write("trainnedModel_temp.yml")

            s3_client = boto3.client('s3')
            s3_client.upload_file('trainnedModel_temp.yml','empsure-static-media',PATH_MODEL)
        else:
            face_recognizer.train(faces, np.array(label_ids))
            face_recognizer.write(PATH_MODEL)
        return
    print("No images to be trainned")

def faceVerification(imagePath):
    imgTest = cv2.imread(imagePath)
    face_detected, gray_img = faceDetection(imgTest)

    if len(face_detected) != 1:
        # return 'no label', -1
        return -1, -1
    else:
        # labels = {}

        # file = open(PATH_MODEL_LABELS)
        # reader = csv.reader(file)
        #
        # for row in reader:
        #     key = int(row[1])
        #     if key in labels:
        #         pass
        #     labels[key] = row[0]
        #
        # file.close()

        face_recognizer=cv2.face.LBPHFaceRecognizer_create()

        if hasattr(settings,'AWS_STORAGE_BUCKET_NAME'):
            s3_client = boto3.client('s3')
            s3_client.download_file('empsure-static-media', PATH_MODEL, "trainnedModel_temp.yml")
            face_recognizer.read("trainnedModel_temp.yml")
        else:
            face_recognizer.read(PATH_MODEL)

        (x, y, w, h) = face_detected[0]
        roi_gray = gray_img[y:y+h, x:x+h]
        label, confidence = face_recognizer.predict(roi_gray)

        print(label)
        print(confidence)

        return label, confidence
