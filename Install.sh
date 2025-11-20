[TOC]

# EasyAmplicon 2 Software and Database Installation Tutorial
# EasyAmplicon 2 软件与数据库安装教程

    # Author: Yong-xin Liu (刘永鑫) et al.
    # Update: 2025-07-24
    # Version: 2.01
    # If used this script, please cited:
    # Hao Luo, et al. 2025. EasyAmplicon 2: Expanding PacBio and Nanopore Long Amplicon Sequencing Analysis Pipeline for Microbiome. Advanced Science 12: https://doi.org/https://doi.org/10.1002/advs.202512447
    # Salsabeel Yousuf, et al. 2024. Unveiling microbial communities with EasyAmplicon: A user-centric guide to perform amplicon sequencing data analysis. iMetaOmics 1: e42. https://doi.org/10.1002/imo2.42
    # Yong-Xin Liu, et al. 2023. EasyAmplicon: An easy-to-use, open-source, reproducible, and community-based pipeline for amplicon data analysis in microbiome research. iMeta 2: e83. https://doi.org/10.1002/imt2.83


---

## Initialization (一、初始化环境)

    # In the Linux environment (Linux环境下)

```bash
# Software installation directory (conda is recommended) (软件安装目录（推荐conda）)
soft=~/miniconda3
# Database storage location (数据库保存位置)
db=~/db

mkdir -p ${soft} ${db}
export PATH=${soft}/bin:${soft}/condabin:${PATH}
echo $PATH
```

---

## Conda Installation (二、安装 Conda 和常用工具包)

```bash
# Download the latest version of miniconda3 v24.9.2, installation date 2024/11/12, 141.47 Mb
# 下载最新版miniconda3 v24.9.2 , 安装日期2024/11/12, 141.47 Mb
    wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    
    # Install, -b for batch, -f for no prompt, -p for directory, type yes for license agreement
    # 安装，-b批量，-f无提示，-p目录，许可协议打yes
    bash Miniconda3-latest-Linux-x86_64.sh -b -f 
    # Activate, then close and reopen the terminal, success if (base) appears before the prompt
    # 激活，然后关闭终端重开，提示符前出现(base)即成功
    ~/miniconda3/condabin/conda init
    source ~/.bashrc
    # Check version, conda 25.5.1, python 3.13.5 (查看版本，conda 25.5.1, python 3.13.5)
    conda -V  # 25.5.1
    python --version  # 3.13.5
    # Add frequently used channels (添加常用频道)
    conda config --add channels bioconda # Bioconda for bioinformatics software (生物软件)
    conda config --add channels conda-forge # Conda-forge has the highest priority (最高优先级)
    
    # The default conda configuration file is ~/.condarc. Check the configuration file location.
    # conda默认配置文件为 ~/.condarc 查看配置文件位置
    # You are using a new version of Conda (≥24), which requires users to manually accept the Terms of Service (ToS) for each source, otherwise the corresponding channel cannot be used.
    # 你使用的是新版本 Conda（≥24），它要求用户必须手动接受各个源的服务条款（ToS），否则不能使用对应的频道。
    # conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    # conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    # mamba is a CLI tool for managing environments. Compared to conda, mamba rewrites some of conda's functions in C++, significantly improving operational efficiency. It can perform parallel downloads and uses libsolv from the rpm package management tool to resolve environment dependencies faster.
    # mamba是用于管理环境的 CLI 工具。相比于 conda，mamba 是用 c++重写了 conda 的部分功能，运行效率显著提高，可以进行并行的下载，使用 rpm 包管理工具中的 libsolv，可以更快的解决环境依赖问题。
    conda install mamba -y
    mamba install pandas -y
    mamba install conda-pack -y
    
    # Set strict channel priority (better not to use) (设置严格的仓库优先级（最好不要使用）)
    #conda config --set channel_priority strict
    # Disable channel priority (禁用仓库优先级)
    #conda config --set channel_priority flexible
    
    conda config --show-sources
    # List conda environments (查看虚拟环境列表)
    conda env list

For more Chinese tutorials on conda installation and use, please refer to: [Nature Method: Bioconda solves the trouble of biological software installation](https://mp.weixin.qq.com/s/SzJswztVB9rHVh3Ak7jpfA)
更多conda中文安装使用教程参考：[Nature Method：Bioconda解决生物软件安装的烦恼](https://mp.weixin.qq.com/s/SzJswztVB9rHVh3Ak7jpfA)
[Mastering Conda Software Installation in One Article: Virtual Environments, Software Channels, Accelerating Solving, and Cross-Server Migration](https://mp.weixin.qq.com/s/tKAU09_w7Cu7khA9M2EGEQ)
[一文掌握Conda软件安装：虚拟环境、软件通道、加速solving、跨服务器迁移](https://mp.weixin.qq.com/s/tKAU09_w7Cu7khA9M2EGEQ)
```

---

## Software Installation (三、软件工具安装)

### 1. Install Git, R, RStudio (1. 安装 Git、R、RStudio)
```bash
Please install the dependency software according to your system (Win/Mac/Linux).

# R 4.x.x is recommended for running R scripts
https://www.r-project.org/. It is also recommended that Rtools be installed for source code packages.
RStudio 2025.xx.x is a integrated development environment for R https://posit.co/download/rstudio-desktop/

# Git (Windows users need to install it separately) (Git（仅Windows用户需单独安装）)
Git for Windows 2.xx.x (Windows only) http://gitforwindows.org/

# R packages quick install
The statistics and visualization may require > 500 R packages. Installation is time-consuming and may also rely on other compilation tools. 
You can download all needed R packages in https://pan.baidu.com/s/1Ikd_47HHODOqC3Rcx6eJ6Q?pwd=0315 db/win/4.x.zip or db/mac/R4.2_mac_libraryX86_64.zip, then unzip and take the `4.x` folder in C:\Users\[$UserName]\AppData\Local\R\win-library\
    # Note: If an R package is missing, you can install it separately using the following methods
    # 注意：如显示缺少某个R包，可以通过以下方法单独安装
    # For example, the DADA2 package is hosted on Bioconductor and needs to be installed via BiocManager.
    # 例如DADA2包托管在Bioconductor上，需要通过BiocManager来安装。
    # Please open your R or Rstudio, and enter and execute the following commands in the Console:
    # 请打开您的R或Rstudio，在控制台(Console)中输入并执行以下命令：
    # First, install BiocManager's core management tool, BiocManager
    # 首先，安装Biocductor的核心管理工具 BiocManager
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    # Then, install DADA2 via BiocManager (然后，通过 BiocManager 安装 DADA2)
    BiocManager::install("dada2")
    # In addition, some R packages can be installed in the conventional way. For example, if you need the argparse package to parse command line arguments, you can use:
    # 此外，一些R包可以通过常规方式安装，比如需要 argparse 包来解析命令行参数，就可以使用：
    install.packages("argparse")
    # When installing various R packages, a large amount of compilation and installation information may appear in the console. Please wait patiently for it to complete. If you encounter problems, please check your R language environment or network connection according to the prompt.
    # 安装各类R包时，控制台可能会出现大量的编译和安装信息，请耐心等待其完成。如果遇到问题，请根据提示信息检查您的R语言环境或网络连接。
```


### 2. Install EasyAmplicon2 (2. 安装 EasyAmplicon2)
```bash
cd ${db}
git clone https://github.com/YongxinLiu/EasyAmplicon
cd EasyAmplicon2
chmod +x *.sh
```
### 3. Install EasyMicrobiome (3. 安装 EasyMicrobiome)
```bash
# EasyAmplicon 2 depends on EasyMicrobiome, which includes a collection of many scripts, software and databases. Website: https://github.com/YongxinLiu/EasyMicrobiome
# EasyAmplicon 2 依赖EasyMicrobiome，其包括众多脚本、软件和数据库的集合，网址：https://github.com/YongxinLiu/EasyMicrobiome
    
    # Method 1. Download from the webpage (方法1. 网页中下载)
    # In https://github.com/YongxinLiu/EasyMicrobiome, click Code -> Download ZIP to download the compressed package, upload it to the server, and unzip it.
    # https://github.com/YongxinLiu/EasyMicrobiome 中Code Download ZIP下载压缩包，上传至服务器，并解压
    unzip EasyMicrobiome-master.zip
    mv EasyMicrobiome-master EasyMicrobiome
    
    # Method 2. Download from an alternative link (方法2. 备用链接下载)
    wget -c ftp://download.nmdc.cn/tools/soft/EasyMicrobiome.tar.gz
    tar -xvzf EasyMicrobiome.tar.gz
    
    # Method 3. Download with git, git needs to be installed, pay attention to network issues
    # 方法3. git下载，需安装git，注意网络问题
    git clone https://github.com/YongxinLiu/EasyMicrobiome
    # Update old version (旧版更新)
    cd EasyMicrobiome && git pull && cd ../
    
    # Software installation (软件安装)
    # Add executable permission to linux commands (添加linux命令可执行权限)
    chmod +x `pwd`/EasyMicrobiome/linux/* `pwd`/EasyMicrobiome/script/*
    # Add environment variables (添加环境变量)
    echo "export PATH=\"$PATH:`pwd`/EasyMicrobiome/linux:`pwd`/EasyMicrobiome/script\"" >> ~/.bashrc
    source ~/.bashrc
    echo $PATH
```
### 4. Create environment and install core tools (4. 创建环境并安装核心工具)
```bash
# Create, install and activate the easyamplicon2 environment (easyamplicon2的创建安装及环境激活)
**Note: Choose one of the two options: direct installation or download and unzip for installation. If one method fails, try the other.**
**注：直接安装、下载解压安装，二选一。一种方法不成功，尝试另一种。**
cd EasyAmplicon2
## Method 1. Direct installation (方法1.直接安装)
conda env create -f EasyAmplicon2.yaml
conda activate easyamplicon2

## Method 2. Download and install (recommended) (方法2.下载安装(推荐))
### Specify conda file name (指定conda文件名)
s=easyamplicon2
soft=~/miniconda3
### Download and install (下载安装)
Baidu Net Disk: https://pan.baidu.com/s/1Ikd_47HHODOqC3Rcx6eJ6Q?pwd=0315 (百度网盘下载链接)
File path: db/amplicon/easyamplicon2.tar.gz (文件路径)
### Specify installation directory (指定安装目录)
mkdir -p ${soft}/envs/${s}
tar -xvzf ${s}.tar.gz -C ${soft}/envs/${s}
### Activate the environment (启动环境)
conda activate ${s}
### Initialize the environment (初始化环境)
### The easyamplicon2 environment contains most of the analysis software (easyamplicon2环境包含了大部分分析软件)
conda unpack

## Method 3. Download and run with Singularity (recommended) (方法3.下载singularity)

### Download Singularity image (下载Singularity镜像)
Baidu Net Disk: https://pan.baidu.com/s/1Ikd_47HHODOqC3Rcx6eJ6Q?pwd=0315 (百度网盘下载链接)
File path: db/amplicon/easyamplicon2.sif (文件路径)

### Specify storage directory (指定存放目录)
mkdir -p ~/singularity/easyamplicon2
mv easyamplicon2.sif ~/singularity/easyamplicon2/

### Run the environment (运行环境)
singularity exec ~/singularity/easyamplicon2/easyamplicon2.sif bash

### Initialize the environment (初始化环境)
# The Singularity image contains all core dependencies and requires no additional installation
# Singularity镜像已包含所有核心依赖，无需额外安装

```


## Database Installation (四、数据库下载（需进行格式转换）)
```bash
**Note: Choose one of two options: direct installation or download and unzip for installation. If one method fails, try the other.**
**注：直接下载转换好格式的数据库、下载原始数据库，二选一。一种方法不成功，尝试另一种。**
```
### Download the pre-formatted database (下载转换好格式的数据库)
```bash
Baidu Net Disk: https://pan.baidu.com/s/1Ikd_47HHODOqC3Rcx6eJ6Q?pwd=0315 (数据库百度网盘下载链接)

File path (文件路径):
- db/amplicon/silva/SILVA_modified.fasta  
- db/amplicon/silva/silva_nr99_v138.1_train_DADA2.fa.gz  
- db/amplicon/usearch/gtdb_sintax_database.fasta.gz  
- db/amplicon/usearch/sintax_defalut_emu_database.fasta.gz  
- db/amplicon/usearch/sintax_ncbi_database.fasta.gz  
- db/amplicon/GTDB
- db/amplicon/silva/Silva_Emu

```
### Download the original reference databases (manual conversion required) (下载原始参考数据库（需手动转换）)
```bash
Silva: https://www.arb-silva.de/current-release/Exports
  - SILVA_138.2_SSURef_NR99_tax_silva.fasta.gz  
 

GTDB: https://data.gtdb.aau.ecogenomic.org/releases/release226/226.0/  
  - bac120_taxonomy_r226.tsv; bac120_ssu_reps_r226.fna.gz ; ssu_all_r226.fna.gz

NCBI: https://ftp.ncbi.nlm.nih.gov/blast/db/  
  - 16S_ribosomal_RNA.tar.gz  

Emu: https://osf.io/56uf7/files/osfstorage  
  - emu_default.tar.gz  
```

## V. Add environment variables (optional) (五、添加环境变量（可选）)
```bash
echo "export PATH=\"$PATH:${db}/EasyAmplicon2\"" >> ~/.bashrc
echo "export PATH=\"$PATH:${soft}/bin\"" >> ~/.bashrc
source ~/.bashrc
```

---


## VI. Software packaging (optional) (六、软件打包（可选）)
```bash
mkdir -p ~/project/EasyAmplicon2/package
cd ~/project/EasyAmplicon2/package
conda activate easyamplicon2
conda pack -f -n easyamplicon2 -o easyamplicon2.tar.gz
```

---

## Reference (七、参考链接)

* [EasyAmplicon2 GitHub](https://github\.com/YongxinLiu/EasyAmplicon)
* [QIIME2 Official Tutorial / 官方教程](https://docs.qiime2.org/)
* [PICRUSt2 Documentation / 文档](https://github.com/picrust/picrust2/wiki)
* [SILVA Database / 数据库](https://www.arb-silva.de/)
* [UNITE Fungal Database / 真菌数据库](https://unite.ut.ee/)
* [GTDB Official Website / 官网](https://gtdb.ecogenomic.org/)
* [RDP Classifier](https://sourceforge.net/projects/rdp-classifier/)

---
