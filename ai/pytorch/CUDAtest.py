import torch
print(torch.cuda.is_available() )
x = torch.randn(1).cuda()
print(x)