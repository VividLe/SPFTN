#include <algorithm>
#include <cfloat>
#include <cmath>
#include <vector>

#include <iostream>

#include "caffe/layer.hpp"
#include "caffe/util/io.hpp"
#include "caffe/util/math_functions.hpp"
#include "caffe/vision_layers.hpp"

namespace caffe {

	template <typename Dtype>
	void HingeLossLayer<Dtype>::Forward_cpu(const vector<Blob<Dtype>*>& bottom,
		const vector<Blob<Dtype>*>& top) {
		const Dtype* bottom_data = bottom[0]->cpu_data();
		Dtype* bottom_diff = bottom[0]->mutable_cpu_diff();
		const Dtype* label = bottom[1]->cpu_data();
		//num=batchnum
		int num = bottom[0]->num();
		int count = bottom[0]->count();
		//dim total image num in an image，dim=channels*height*width;
		int dim = count / num;

		int channels = bottom[0]->channels();
		int height = bottom[0]->height();
		int width = bottom[0]->width();
		caffe_copy(count, bottom_data, bottom_diff);


		char slist[51000];
		char sname[40];
		FILE * inlist;
		FILE * inname;
		fopen_s(&inlist, "H:/yangle/txt/namelist.txt", "r");
		fopen_s(&inname, "H:/yangle/txt/name.txt", "r");
		fgets(slist, 51000, inlist);
		fgets(sname, 40, inname);
		fclose(inlist);
		fclose(inname);

		int listlen = strlen(slist);
		std::string strall = slist;
		std::string strc = sname;
		char strnext[40];
		int iPos = 0;
		iPos = strall.find(strc);
		int i;
		int tcount = 0;
		char c;
		for (i = iPos; tcount < 40; i++)
		{
			tcount++;
			c = strall[i];
			if (c != ' ')
			{
				continue;
			}
			else
			{
				if (i == listlen - 1)
				{
					int ccount;
					for (ccount = 0; ccount <= 40; ccount++)
					{
						if (strall[ccount] == ' ')
						{
							strnext[ccount] = 0;
							break;
						}
						strnext[ccount] = strall[ccount];
					}
					break;
				}
				for (tcount = 0; tcount <= 40; tcount++)
				{
					if (strall[i + tcount + 1] == ' ')
					{
						strnext[tcount] = 0;
						break;
					}
					strnext[tcount] = strall[i + tcount + 1];
				}
				break;
			}
		}

		FILE * outname;
		fopen_s(&outname, "H:/yangle/txt/name.txt", "w");
		fputs(strnext, outname);
		fclose(outname);

		char txtpath[100] = "H";
		char txtroot[] = ":/yangle/txt/weitxt/";
		strcat_s(txtpath, txtroot);
		char  strc2[40];
		strcpy_s(strc2, strc.c_str());
		strcat_s(txtpath, strc2);

		//get weight and write
		FILE * fwei;
		fopen_s(&fwei, txtpath, "r");
		//save weight
		int pixwei[3136] = { 0 };
		int order = 0;
		int pointplace = 0;
		for (order = 0; order < 6273; order++)
		{
			c = fgetc(fwei);
			if (c == '1')
			{
				pixwei[pointplace] = 1;
				pointplace++;
			}
			else if (c == '0')
			{
				pixwei[pointplace] = 0;
				pointplace++;
			}
			else if (feof(fwei))
			{
				break;
			}
		}
		fclose(fwei);

		if (channels > 1) {
			for (int i = 0; i < num; ++i) {
				bottom_diff[i * dim + static_cast<int>(label[i])] *= -1;
			}
			for (int i = 0; i < num; ++i) {
				for (int j = 0; j < dim; ++j) {
					bottom_diff[i * dim + j] = std::max(
						Dtype(0), 1 + bottom_diff[i * dim + j]);
				}
			}
		}
		else if (channels == 1){
			for (int i = 0; i < num; ++i) {
				for (int h = 0; h < height; ++h) {
					for (int w = 0; w < width; ++w) {
						if ((pixwei[i * dim + h*width + w] == 1) && (label[i * dim + h*width + w] == 1 || label[i * dim + h*width + w] == -1)){
							bottom_diff[i * dim + h*width + w] *= -1 * label[i * dim + h*width + w];
							bottom_diff[i * dim + h*width + w] = std::max(
								Dtype(0), 1 + bottom_diff[i * dim + h*width + w]);
						}
						else{
							bottom_diff[i * dim + h*width + w] = 0;
						}
					}
				}
			}
		}
		else LOG(FATAL) << "Invalid channels";


		Dtype* loss = top[0]->mutable_cpu_data();
		switch (this->layer_param_.hinge_loss_param().norm()) {
		case HingeLossParameter_Norm_L1:
			loss[0] = caffe_cpu_asum(count, bottom_diff) / num;
			break;
		case HingeLossParameter_Norm_L2:
			loss[0] = caffe_cpu_dot(count, bottom_diff, bottom_diff) / num;
			break;
		default:
			LOG(FATAL) << "Unknown Norm";
		}
	}

	template <typename Dtype>
	void HingeLossLayer<Dtype>::Backward_cpu(const vector<Blob<Dtype>*>& top,
		const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom) {
		if (propagate_down[1]) {
			LOG(FATAL) << this->type()
				<< " Layer cannot backpropagate to label inputs.";
		}
		if (propagate_down[0]) {
			Dtype* bottom_diff = bottom[0]->mutable_cpu_diff();
			const Dtype* label = bottom[1]->cpu_data();
			int num = bottom[0]->num();
			int count = bottom[0]->count();
			int dim = count / num;

			int channels = bottom[0]->channels();
			int height = bottom[0]->height();
			int width = bottom[0]->width();

			if (channels > 1) {
				for (int i = 0; i < num; ++i) {
					bottom_diff[i * dim + static_cast<int>(label[i])] *= -1;
				}
			}
			else if (channels == 1) {
				for (int i = 0; i < num; ++i) {
					for (int h = 0; h < height; ++h) {
						for (int w = 0; w < width; ++w) {
							bottom_diff[i * dim + h*width + w] *= -1 * label[i * dim + h*width + w];
						}
					}
				}
			}
			else LOG(FATAL) << "Invalid channels";


			const Dtype loss_weight = top[0]->cpu_diff()[0];
			switch (this->layer_param_.hinge_loss_param().norm()) {
			case HingeLossParameter_Norm_L1:
				caffe_cpu_sign(count, bottom_diff, bottom_diff);
				caffe_scal(count, loss_weight / num, bottom_diff);
				break;
			case HingeLossParameter_Norm_L2:
				caffe_scal(count, loss_weight * 2 / num, bottom_diff);
				break;
			default:
				LOG(FATAL) << "Unknown Norm";
			}
		}
	}

	INSTANTIATE_CLASS(HingeLossLayer);
	REGISTER_LAYER_CLASS(HingeLoss);

}  // namespace caffe
