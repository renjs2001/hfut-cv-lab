from skimage import data
from skimage import io
from matplotlib import pyplot as plt
import segamentation

if __name__ == '__main__':
    image = io.imread('Cameraman.tif', as_gray=True)
    k = 3  # 聚类中心点个数
    threshold = 1  # 阈值大小
    labels = segamentation.k_means(image, k, threshold)
    # 显示结果
    plt.subplot(1, 2, 1)
    plt.title("Source Image")
    plt.imshow(image, cmap="gray")
    plt.subplot(1, 2, 2)
    plt.title("Segamenting Image with k-means\n" + "k=" + str(k) + "  threshold=" + str(threshold))
    plt.imshow(labels / 3)
    plt.show()
