import torch
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
import torch.nn as nn
import torch.nn.functional as F
import matplotlib.pyplot as plt
import torchvision
import numpy as np
from torch.autograd import Variable
from torchviz import make_dot
import coremltools as ct

PATH = './cifar_net.pth'

class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(-1, 16 * 5 * 5)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x


def imshow(img):
    img = img / 2 + 0.5     # unnormalize
    npimg = img.numpy()
    plt.imshow(np.transpose(npimg, (1, 2, 0)))
    plt.show()

def load_set():
    transform = transforms.Compose([transforms.ToTensor(),
     transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])
    trainset = torchvision.datasets.CIFAR10(root='./data', train=True,
                                        download=True, transform=transform)
    trainloader = torch.utils.data.DataLoader(trainset, batch_size=4,
                                          shuffle=True, num_workers=2)
    testset = torchvision.datasets.CIFAR10(root='./data', train=False,
                                       download=True, transform=transform)
    testloader = torch.utils.data.DataLoader(testset, batch_size=4,
                                         shuffle=False, num_workers=2)
    return trainset, trainloader, testset, testloader

def showTrainData():
    trainset, trainloader, testset, testloader=load_set()
    # get some random training images
    dataiter = iter(trainloader)
    images, labels = dataiter.next()
    # show images
    imshow(torchvision.utils.make_grid(images))
    # print labels
    print(' '.join('%5s' % classes[labels[j]] for j in range(4)))

def showTestData():
    trainset, trainloader, testset, testloader=load_set()
    dataiter = iter(testloader)
    images, labels = dataiter.next()
    net = Net()
    net.load_state_dict(torch.load(PATH))
    outputs = net(images)
    _, predicted = torch.max(outputs, 1)
    print('Predicted: ', ' '.join('%5s' % classes[predicted[j]]
                                for j in range(4)))

def train():
    net = Net()
    trainset, trainloader, testset, testloader=load_set()
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(net.parameters(), lr=0.001, momentum=0.9)
    for epoch in range(2):  # loop over the dataset multiple times
        running_loss = 0.0
        for i, data in enumerate(trainloader, 0):
            # get the inputs; data is a list of [inputs, labels]
            inputs, labels = data
            # zero the parameter gradients
            optimizer.zero_grad()
            # forward + backward + optimize
            outputs = net(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            # print statistics
            running_loss += loss.item()
            if i % 2000 == 1999:    # print every 2000 mini-batches
                print('[%d, %5d] loss: %.3f' %
                    (epoch + 1, i + 1, running_loss / 2000))
                running_loss = 0.0
    print('Finished Training')
    torch.save(net.state_dict(), PATH)

def test():
    trainset, trainloader, testset, testloader=load_set()
    net = Net()
    net.load_state_dict(torch.load(PATH))
    correct = 0
    total = 0
    with torch.no_grad():
        for data in testloader:
            images, labels = data
            outputs = net(images)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    print('Accuracy of the network on the 10000 test images: %d %%' % (
    100 * correct / total))

def toOnnx():
    net = Net()
    net.load_state_dict(torch.load(PATH))
    dummy_input = torch.rand(1,3,32,32)
    input_names = ['image']
    output_names = ['classLabelProbs']
    torch.onnx.export(net,
                    dummy_input,
                    './my_net.onnx',
                    verbose=True,
                    input_names = input_names,
                    output_names = output_names)

def toCoreml():
    class_labels = ['air plane', 'automobile', 'bird', 'cat', 'deer', 'dog',
'frog','horse','ship','truck']
    model = ct.converters.onnx.convert(
        "./my_net.onnx",
        mode="classifier",
        minimum_ios_deployment_target="13",
        image_input_names=["image"],
        predicted_feature_name="classLabel",
        class_labels=class_labels
    )
    model.save("./my_net.mlmodel")


if __name__=='__main__':
    train()
    test()
    toOnnx()
    toCoreml()