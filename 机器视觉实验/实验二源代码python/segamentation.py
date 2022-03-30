import numpy as np
import random

def loss_function(present_center, pre_center):

    present_center = np.array(present_center)
    pre_center = np.array(pre_center)
    return np.sum((present_center - pre_center)**2) # 计算差值的平方 （保证为正数）


def classifer(intput_signal, center):

    input_row, input_col= intput_signal.shape # 输入图像的尺寸

    pixls_labels = np.zeros((input_row, input_col))  # 储存所有像素标签

    pixl_distance_t = []  # 单个元素与所有聚类中心的距离

    for i in range(input_row):
        for j in range(input_col):
            # 计算每个像素与所有聚类中心的差平方
            for k in range(len(center)):
                distance_t = np.sum(abs((intput_signal[i, j]).astype(int) - center[k].astype(int))**2)
                pixl_distance_t.append(distance_t)
            # 差异最小则为该类
            pixls_labels[i, j] = int(pixl_distance_t.index(min(pixl_distance_t)))
            # 清空该list，为下一个像素点做准备
            pixl_distance_t = []
    return pixls_labels


def k_means(input_signal, center_num, threshold):

    input_signal_cp = np.copy(input_signal) # 输入信号的副本
    input_row, input_col = input_signal_cp.shape # 输入图像的尺寸
    pixls_labels = np.zeros((input_row, input_col))  # 储存所有像素标签

    # 随机初始聚类中心行标与列标
    initial_center_row_num = [i for i in range(input_row)]
    random.shuffle(initial_center_row_num)
    initial_center_row_num = initial_center_row_num[:center_num]

    initial_center_col_num = [i for i in range(input_col)]
    random.shuffle(initial_center_col_num)
    initial_center_col_num = initial_center_col_num[:center_num]

    # 当前的聚类中心
    present_center = []
    for i in range(center_num):
        present_center.append(input_signal_cp[initial_center_row_num[i], initial_center_row_num[i]])
    pixls_labels = classifer(input_signal_cp, present_center)

    num = 0  # 用于记录迭代次数
    while True:
        pre_centet = present_center.copy() # 储存前一次的聚类中心
        # 计算当前聚类中心
        for n in range(center_num):
            temp = np.where(pixls_labels == n)
            present_center[n] = sum(input_signal_cp[temp].astype(int)) / len(input_signal_cp[temp])
        # 根据当前聚类中心分类
        pixls_labels = classifer(input_signal_cp, present_center)
        # 计算上一次聚类中心与当前聚类中心的差异
        loss = loss_function(present_center, pre_centet)
        num = num + 1
        print("Step:"+ str(num) + "   Loss:" + str(loss))
        # 当损失小于迭代阈值时，结束迭代
        if loss <= threshold:
            break
    return pixls_labels
