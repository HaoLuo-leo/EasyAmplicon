# EasyAmplicon2 (易扩增子2)

    # Author: Yong-xin Liu (刘永鑫) et al.
    # Update: 2025-07-24
    # Version: 2.01
    # If used this script, please cited:
    # Hao Luo, et al. 2025. EasyAmplicon 2: Expanding PacBio and Nanopore Long Amplicon Sequencing Analysis Pipeline for Microbiome. Advanced Science 12: https://doi.org/https://doi.org/10.1002/advs.202512447
    # Salsabeel Yousuf, et al. 2024. Unveiling microbial communities with EasyAmplicon: A user-centric guide to perform amplicon sequencing data analysis. iMetaOmics 1: e42. https://doi.org/10.1002/imo2.42
    # Yong-Xin Liu, et al. 2023. EasyAmplicon: An easy-to-use, open-source, reproducible, and community-based pipeline for amplicon data analysis in microbiome research. iMeta 2: e83. https://doi.org/10.1002/imt2.83

    # Set the working directory (wd) and the software/database directory (db) (设置工作(work directory, wd)和软件数据库(database, db)目录)
    # Most of the pipeline runs in Git Bash. A note will be made when it is necessary to switch to Linux Bash. (流程大部分在Git bash下运行，需要转换linux bash时会注明)

    # Add environmental variables and enter the working directory (添加环境变量，并进入工作目录)
    # **The following 4 lines must be run every time you open RStudio**, you can optionally replace ${db} with your EasyMicrobiome installation location (**每次打开Rstudio必须运行下面4行 Run it**，可选替换${db}为EasyMicrobiome安装位置)
    wd=/c/EasyAmplicon2
    db=/c/EasyMicrobiome
    PATH=$PATH:${db}/win
    cd ${wd}


# Analysis of diversity and species composition in R (R语言多样性和物种组成分析)

## 1. Alpha diversity (Alpha多样性)

### 1.1 Alpha diversity boxplot (Alpha多样性箱线图)
    
```
    # Illumina data
    # View help, this method can be used to view help information for all subsequent R code (查看帮助,后续所有R代码均可用此方法查看帮助信息)
    Rscript ${db}/script/alpha_div_box.R -h
    # Full parameters, diversity index can be richness, chao1, ACE, shannon, simpson, invsimpson (完整参数，多样性指数可选richness chao1 ACE shannon simpson invsimpson)
    Rscript ${db}/script/alpha_div_box.R --input result/alpha/vegan.txt \
    --metadata result/metadata.txt \
    --alpha_index richness,chao1,ACE,shannon,simpson,invsimpson \
    --group Group \
    --out_prefix result/alpha/vegan
    # --alpha_index controls the type of diversity index to be plotted, a single one can be plotted (--alpha_index控制绘制多样性指数类型，可绘制单个)
```

### 1.2 Rarefaction curve (稀释曲线)

```
    # Illumina data
    cd ..
    Rscript ${db}/script/alpha_rare_curve.R \
      --input result/alpha/alpha_rare.txt --design result/metadata.txt \
      --group Group --output result/alpha/ \
      --width 120 --height 78
```

### 1.3 Diversity Venn diagram (多样性维恩图)

```
    # Illumina data
    cd ..
    Rscript ${db}/script/venn.R \
      --input result/alpha/otu_group_exist.txt \
      --groups All,KO,OE,WT \
      --output result/alpha/venn.pdf
```

## 2. Beta diversity (Beta多样性)

### 2.1 Distance matrix heatmap pheatmap (距离矩阵热图pheatmap)
    
```
    # Illumina data
    cd ..
    # Take bray_curtis as an example, -f input file, -h whether to cluster TRUE/FALSE, -u/v for width and height in inches (以bray_curtis为例，-f输入文件,-h是否聚类TRUE/FALSE,-u/v为宽高英寸)
    bash ${db}/script/sp_pheatmap.sh \
      -f result/beta/bray_curtis.txt \
      -H 'TRUE' -u 6 -v 5
    # Add group annotation, such as genotype and location in columns 2 and 4 (添加分组注释，如2，4列的基因型和地点)
    cut -f 1-2 result/metadata.txt > temp/group.txt
    # -P to add row annotation file, -Q to add column annotation (-P添加行注释文件，-Q添加列注释)
    bash ${db}/script/sp_pheatmap.sh \
      -f result/beta/bray_curtis.txt \
      -H 'TRUE' -u 6.9 -v 5.6 \
      -P temp/group.txt -Q temp/group.txt
```


### 2.2 Principal Coordinate Analysis (PCoA) (主坐标分析PCoA)

```
    # Illumina data
    cd ..
    # Input file, select group, output file (输入文件，选择分组，输出文件)
    Rscript ${db}/script/beta_PCoA.R \
      --input result/otutab.txt \
      --metadata result/metadata.txt \
      --group Group \
      --output result/beta/PCoa2.pdf
```

### 2.3 Constrained Principal Coordinate Analysis (CPCoA) (限制性主坐标分析CPCoA)

```
    # Illumina data
    cd ..
    Rscript ${db}/script/beta_cpcoa.R \
      --input result/beta/bray_curtis.txt --design result/metadata.txt \
      --group Group --output result/beta/bray_curtis.cpcoa.pdf \
      --width 89 --height 59
    # Add sample labels --label TRUE (添加样本标签 --label TRUE)
    Rscript ${db}/script/beta_cpcoa.R \
      --input result/beta/bray_curtis.txt --design result/metadata.txt \
      --group Group --label TRUE --width 89 --height 59 \
      --output result/beta/bray_curtis.cpcoa.label.pdf
```

## 3. Taxonomy composition (物种组成Taxonomy)

### 3.1 Stacked bar plot (堆叠柱状图Stackplot)

```
    # Illumina data
    cd ..
    # Take phylum (p) level as an example, the results include two files: output.sample/group.pdf (以门(p)水平为例，结果包括output.sample/group.pdf两个文件)
    Rscript ${db}/script/tax_stackplot.R \
      --input result/tax/sum_p.txt --design result/metadata.txt \
      --group Group -t 10 --color manual1 --legend 7 --width 89 --height 59 \
      --output result/tax/sum_p.stackplot
    # Supplement -t to filter top abundance species and -s for x-axis arrangement position -s "feces,plaque,saliva" (补充-t 筛选丰度前多少物种及-s x轴排列位置-s "feces,plaque,saliva") 
    # Modify color --color ggplot, manual1(30), Paired(12) or Set3(12) (修改颜色--color ggplot, manual1(30), Paired(12) or Set3(12))

    # Batch plot input includes 5 levels: p/c/o/f/g (批量绘制输入包括p/c/o/f/g共5级)
    for i in p c o f g; do
    Rscript ${db}/script/tax_stackplot.R \
      --input result/tax/sum_${i}.txt --design result/metadata.txt \
      --group Group -t 10 --output result/tax/sum_${i}.stackplot \
      --legend 8 --width 89 --height 59; done
      
    # Between-group comparison stacked bar plot (组间比较堆叠柱状图)
    Rscript ${db}/script/tax_stack_compare.R \
      --input result/tax/data_illumina_pacbio2.txt \
      --compare Illumina-PacBio \
      --output result/tax/
      
    # Alluvial plot (连线堆叠柱状图)
    Rscript ${db}/script/microeco_alluvial.R \
      --otu result/otutab2.txt \
      --metadata result/metadata3.txt \
      --taxonomy result/taxonomy3.txt \
      --output result/tax/
```

### 3.2 Chord/Circle diagram (circlize) (弦/圈图circlize)

```
    # Illumina data
    cd ..
    # Take class (c) as an example, plot the top 5 groups (以纲(class,c)为例，绘制前5组)
    i=c
    Rscript ${db}/script/tax_circlize.R \
      --input result/tax/sum_${i}.txt --design result/metadata.txt \
      --group Group --legend 5
    # The results are located in the current directory: circlize.pdf (random colors), circlize_legend.pdf (specified colors + legend) (结果位于当前目录circlize.pdf(随机颜色)，circlize_legend.pdf(指定颜色+图例))
    # Move and rename to be consistent with the taxonomic level (移动并改名与分类级一致)
    mv circlize.pdf result/tax/sum_${i}.circlize.pdf
    mv circlize_legend.pdf result/tax/sum_${i}.circlize_legend.pdf
```

### 3.3 Bubble plot (气泡图)

```
    # Illumina data
    cd ..
    # Take genus (g) as an example, plot the bubble chart of the top 15 genera by abundance; input species abundance table and sample metadata file, output grouped species abundance bubble chart (以属为例（genus，g），绘制丰度前15的属水平丰度气泡图；输入物种丰度表和样本metadata文件，输出分组物种丰度气泡图)
    i=g
    Rscript ${db}/script/tax_bubble.R \
    -i result/tax/sum_${i}.txt \
    -g result/metadata.txt \
    -c Group -w 7 -e 4 -s 15 -n 15 \
    -o result/tax/sum_g.bubble3.pdf
```

### 3.4 Donut and Radar plot to show relative abundance composition (甜甜圈图(Donut)和雷达图(Ladar plot)展示相对丰度组成)

```
    # Illumina data
    cd ..
    Rscript ${db}/script/Donut_plot.R \
      --otu_table result/otutab.txt \
      --metadata result/metadata.txt \
      --taxonomy result/taxonomy.txt \
      --output_dir result/tax/
```

### 3.5 Core microbiome (present in at least 80% of samples) (核心微生物(至少在80%样本中存在))

```
    # Illumina data
    cd ..
    Rscript ${db}/script/core_ASVS_and_other.R \
      --otu_table result/otutab.txt \
      --metadata result/metadata.txt \
      --taxonomy result/taxonomy.txt \
      --output_dir result/tax/
      
    # Core microbiome scatter plot (核心微生物散点图)
    Rscript ${db}/script/Core_Abundance_ScatterPlot.R \
      --otu_table result/otutab.txt \
      --metadata result/metadata.txt \
      --output result/tax/
```


# 4. Differential comparison (差异比较)

## 1. Differential analysis in R (R语言差异分析)

### 1.1 Differential comparison (差异比较)

```
    # Illumina data
    cd ..
    mkdir -p result/compare/
    # Input feature table, metadata; specify group column name, comparison group and abundance (输入特征表、元数据；指定分组列名、比较组和丰度)
    # Select method wilcox/t.test/edgeR, pvalue and fdr and output directory (选择方法 wilcox/t.test/edgeR、pvalue和fdr和输出目录)
    # Select the default wilcox here (这里选择默认的wilcox)
    #compare="saliva-plaque"
    compare="KO-OE"
    Rscript ${db}/script/compare.R \
      --input result/otutab.txt --design result/metadata.txt \
      --group Group --compare ${compare} --threshold 0.01 \
      --pvalue 0.05 --fdr 0.2 \
      --output result/compare/
    # And filter the top 20% ASVs by abundance (--threshold 0.05) to draw a heatmap (并筛选丰度为前20%的ASV（--threshold 0.05 ）用来画热图)
    #compare="feces-saliva"
    compare="KO-OE"
    Rscript ${db}/script/compare.R \
      --input result/otutab.txt --design result/metadata.txt \
      --group Group --compare ${compare} --threshold 0.2 \
      --pvalue 0.05 --fdr 0.2 \
      --output result/compare/
    # Common error: Error in file(file, ifelse(append, "a", "w")) : cannot open the connection Calls: write.table -> file (常见错误：Error in file(file, ifelse(append, "a", "w")) : 无法打开链结 Calls: write.table -> file)
    # Solution: The output directory does not exist, create the directory (解决方法：输出目录不存在，创建目录即可)
```

### 1.2 Volcano plot (火山图)
    
``` 
    # Illumina data
    cd ..
    Rscript ${db}/script/volcano2.R \
      --input result/compare/saliva_plaque2.txt \
      --group saliva-plaque \
      --output result/compare/
      
    # Multi-group comparison volcano plot (多组比较火山图)
    Rscript ${db}/script/multigroup_compare_volcano.R \
      --input result/otutab2.txt \
      --metadata result/metadata2.txt \
      --output result/compare/
```

### 1.3 Heatmap (热图)

```
    # Illumina data
    cd ..
    # Input the result of compare.R, filter the number of columns, specify metadata and grouping, species annotation, figure size in inches and font size (输入compare.R的结果，筛选列数，指定元数据和分组、物种注释，图大小英寸和字号)
    #compare="saliva_plaque2"
    compare="KO-OE"
    bash ${db}/script/compare_heatmap.sh \
       -i result/compare/${compare}.txt -l 7 \
       -d result/metadata.txt -A Group \
       -t result/taxonomy.txt \
       -w 12 -h 20 -s 14 \
       -o result/compare/${compare}
      
    # Multi-sample group comparison heatmap (多样本分组比较热图)
    Rscript ${db}/script/multisample_compare_heatmap.R \
      --input result/compare/data5.txt \
      --output result/compare/
```

### 1.4 Ternary plot (三元图)

```
    # Illumina data
    cd ..
    Rscript ${db}/script/Ternary_plot.R   \
    --input result/tax/sum_p2.txt   \
    --metadata result/metadata2.txt  \
    --group Group   \
    --taxlevel Phylum \
    --output result/compare/ternary_p.pdf   \
    --topn 10
    
    # Error: package or namespace load failed for ‘ggtern’: .onLoad failed in loadNamespace() for 'ggtern', details: call: NULL error: <ggplot2::element_line> object properties are invalid: - @lineend must be <character> or <NULL>, not S3<arrow>
    # The above error is because the ggplot2 and ggtern packages do not match, you need to match ggplot2 and ggtern to the correct version (遇到以上报错是因为ggplot2和ggtern软件包不匹配，需要将ggplot2和ggtern匹配到正确的版本)
    # remove.packages("ggplot2")
    # install.packages("https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.4.4.tar.gz", repos = NULL, type = "source")
    # library(ggplot2)
    # remove.packages("ggtern")
    # install.packages("https://cran.r-project.org/src/contrib/Archive/ggtern/ggtern_3.4.2.tar.gz",repos = NULL, type = "source")
    # library(ggtern)
```


## 1.5. STAMP differential analysis plot (STAMP差异分析图)

```
### 1.5.1 Generate input file (optional) (生成输入文件(备选))

    # Illumina data
    cd ..
    Rscript ${db}/script/format2stamp.R -h
    mkdir -p result_illumina/stamp
    Rscript ${db}/script/format2stamp.R --input result/otutab.txt \
      --taxonomy result/taxonomy.txt --threshold 0.01 \
      --output result/stamp/tax
    # Optional Rmd document see result/format2stamp.Rmd (可选Rmd文档见result/format2stamp.Rmd)
    
    
### 1.5.2 Plot STAMP graph in R (R语言绘制STAMP图)

    # There is still a problem with the statistics here, wilcox.test should be used instead of t.test, and the code needs to be adjusted later (此处对统计还有问题，应该用wilcox.test，不能用t.test，还需要后续调整代码)

    # Illumina data
    cd ..
    # compare="feces-plaque"
    # Rscript ${db}/compare_stamp3.R \
    #   --input result/tax/sum_g2.txt --metadata result/metadata2.txt \
    #   --group Group --compare ${compare} --threshold 0.1 \
    #   --method "t.test" --pvalue 0.2 --fdr "none" \
    #   --width 80 --height 30 \
    #   --output result/tax/stamp_${compare}
    
    compare="feces-plaque"  
    Rscript ${db}/script/compare_stamp3.R \
      --input result/tax/sum_g2.txt --metadata result/metadata2.txt \
      --group Group --compare ${compare} --threshold 0.1 \
      --method "wilcox" --pvalue 0.2 --fdr "none" \
      --width 80 --height 30 \
      --output result/tax/stamp_${compare}
      
    # Rscript ${db}/script/compare_stamp4.R \
    #   --input result/tax/sum_g2.txt --metadata result/metadata2.txt \
    #   --group Group --compare feces-plaque --threshold 0.1 \
    #   --method "wilcox" --pvalue 0.2 --fdr "none" \
    #   --width 80 --height 30 \
    #   --output result/tax/stamp_feces-plaque
    #   
    # compare="feces-plaque"
    # Rscript compare_stamp4.R \
    #   --input result/tax/sum_g2.txt --metadata result/metadata2.txt \
    #   --group Group --compare ${compare} --threshold 0.1 \
    #   --method "wilcox" --pvalue 0.2 --fdr "none" \
    #   --width 80 --height 30 \
    #   --output result/tax/stamp_${compare}
```

### Lefse analysis and inter-group comparison bar chart (Lefse分析及组间比较柱状图)

    Lefse analysis online website: (Lefse分析在线网站：)https://www.bioincloud.tech/standalone-task-ui/lefse
    Reference: Gao, Yunyun, Guoxing Zhang, Shunyao Jiang, and Yong‐Xin Liu. 2024. “
    Wekemo Bioincloud: A User‐friendly Platform for Meta‐omics Data Analyses.” i
    Meta e175. https://doi.org/10.1002/imt2.17
 
 
### 2. Environmental factor correlation analysis (环境因子关联分析)
 
```
### Mantel test correlation analysis heatmap (Mantel检验相关性分析热图)
 
    # PacBio data
    cd ../PacBio
    Rscript ${db}/script/env_mantel_heatmap.R \
      --input result/tax/otutab2.txt \
      --env result/tax/env_amplicon.txt \
      --output result/tax/

```

```
### Redundancy analysis (RDA) (冗余分析)

    # PacBio data
    # Software installation may take some time (软件按照可能需要一些时间)
    Rscript ${db}/script/RDA_microeco.R \
      --input result/tax/otutab.txt \
      --metadata result/tax/metadata.txt \
      --tax result/tax/taxonomy.txt \
      --phylo result/tax/otus.tree \
      --output result/tax/

``` 

### 3. Phylogenetic tree (系统发育树)

```
### 3.1 Phylogenetic tree without evolutionary distance (无进化距离系统发育树)

    # PacBio data
    Rscript ${db}/script/phylogenetic_tree01.R \
      --input result/tax/otus.nwk \
      --anno result/tax/annotation2.txt \
      --output result/tax/
      
### 3.2 Phylogenetic tree with evolutionary distance (有进化距离系统发育树)
    # PacBio data
    Rscript ${db}/script/phylogenetic_tree02.R \
      --input result/tax/otus.nwk \
      --anno result/tax/annotation3.txt \
      --output result/tax/
    
```


### 4. Network analysis (网络分析)

```
### 4.1 Multi-group Spearman correlation network comparison analysis (Multi-group Spearman correlation network) (多组Spearman相关性网络比较分析 (Multi-group Spearman correlation network))
    
    # PacBio data
    Rscript ${db}/script/Spearman_network01.R \
      --input result/tax/otutab_amplicon.txt \
      --group result/tax/sample_amplicon.txt \
      --tax result/tax/taxonomy_amplicon.txt \
      --output result/tax/

```

### 5. Random forest model (随机森林模型)

```
### 5.1 Run random forest model (运行随机森林模型)

    # PacBio data
    # Note: This is the first version of the random forest model. Some of the parameters are built into the code and need to be adjusted according to the specific sample situation (注意：这是第一版本的随机森林模型，其中的一些参数之间内置在代码中，使用时需要根据具体样本情况进行调整)
    Rscript ${db}/script/random_forest01.R \
      --input result/tax/PacBio_data.txt \
      --group result/tax/PacBio_metadata.txt \
      --output result/tax/RF_model/
      
### 5.2 Plot bar chart (绘制柱状图)
    
    # PacBio data
    Rscript ${db}/script/RF_plot01.R \
      --input result/tax/RF_model/Species_imp_rf21.txt \
      --tax result/tax/taxonomy_amplicon.txt \
      --optimal 4 \
      --output result/tax/RF_model/
    
``` 

### 6. Functional difference analysis (功能差异分析)

```
### 6.1 Data processing and difference analysis (数据处理及差异分析)
    
    # PacBio data
    Rscript ${db}/script/function_data_process.R \
      --input result/tax/KEGG.PathwayL2.raw.txt \
      --group result/tax/metadata_amplicon.txt \
      --output result/tax/pathway/
    
### 6.2 Heatmap combined with bar chart to show differences (热图结合柱状图展示差异)

    # PacBio data
    Rscript ${db}/script/function_diff_plot01.R \
      --input result/tax/pathway/Difference_pathway21.txt \
      --pathway result/tax/pathway/pathway_count_data.txt \
      --statistic result/tax/pathway/pathway_percent_abundance2.txt \
      --output result/tax/pathway/

```

### Notes (注意事项)

# 1. Some parameters in the plotting code need to be modified according to specific research; (1.绘图代码中的部分参数需要根据特定研究进行修改；)
# 2. You can go to the EasyMicrobiome (https://github.com/YongxinLiu/EasyMicrobiome) folder to get the corresponding R script, and you can adjust the code yourself; (2.可到EasyMicrobiome(https://github.com/YongxinLiu/EasyMicrobiome)文件夹下获取相应的R语言脚本，可自行对代码进行调整;)
# 3. If you have any questions, please feel free to ask and communicate (https://github.com/YongxinLiu/EasyAmplicon/pulls). (3.如有疑问欢迎提问交流(https://github.com/YongxinLiu/EasyAmplicon/pulls)。)

```



