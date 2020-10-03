from pixellib.semantic import semantic_segmentation
from pixellib.instance import instance_segmentation
from flask import Flask, request
from flask_restful import Resource, Api
from PIL import Image
import base64
from io import BytesIO


SEMANTIC_MODEL = "./models/deeplabv3_xception_tf_dim_ordering_tf_kernels.h5"
INSTANCE_MODEL = "./models/mask_rcnn_coco.h5"

INPUT_IMAGE = "./images/input.jpg"
OUTPUT_IMAGE = "./output_images/output.jpg"


app = Flask(__name__)
api = Api(app)


class SemanticSegmentation(Resource):

    def post(self):
        if request.json:
            image = request.json['image']
            image_string = base64.b64decode(image)
            image_data = BytesIO(image_string)
            img = Image.open(image_data)
            img.save(INPUT_IMAGE)
            semantic_segment_image = semantic_segmentation()
            semantic_segment_image.load_pascalvoc_model(SEMANTIC_MODEL)
            semantic_segment_image.segmentAsPascalvoc(INPUT_IMAGE, output_image_name=OUTPUT_IMAGE)

            with open(OUTPUT_IMAGE, "rb") as img_file:
                my_string = base64.b64encode(img_file.read())
                final_base64_image_string = my_string.decode('utf-8')
            return {"output_image":  final_base64_image_string}


class InstanceSegmentation(Resource):

    def post(self):
        if request.json:
            image = request.json['image']
            image_string = base64.b64decode(image)
            image_data = BytesIO(image_string)
            img = Image.open(image_data)
            img.save(INPUT_IMAGE)
            instance_segment_image = instance_segmentation()
            instance_segment_image.load_model(INSTANCE_MODEL)
            instance_segment_image.segmentImage(INPUT_IMAGE, output_image_name=OUTPUT_IMAGE, show_bboxes=True)

            with open(OUTPUT_IMAGE, "rb") as img_file:
                my_string = base64.b64encode(img_file.read())
                final_base64_image_string = my_string.decode('utf-8')
            return {"output_image":  final_base64_image_string}


api.add_resource(SemanticSegmentation, '/semantic')
api.add_resource(InstanceSegmentation, '/instance')

if __name__ == '__main__':
    app.run(debug=True)
