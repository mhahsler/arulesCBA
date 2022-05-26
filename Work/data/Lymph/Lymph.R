if(rstudioapi::isAvailable()) setwd(dirname(rstudioapi::getSourceEditorContext()$path))

lymph <- read.csv("lymphography.data")

head(lymph)

lymph_names <- c(
  "class, normalfind, metastases, malignlymph, fibrosis",
  "lymphatics, normal, arched, deformed, displaced",
  "blockofaffere, no, yes",
  "bloflymphc, no, yes",
  "bloflymphs, no, yes",
  "bypass, no, yes",
  "extravasates, no, yes",
  "regenerationof, no, yes",
  "earlyuptakein, no, yes",
  "lymnodesdimin, 0, 1, 2, 3",
  "lymnodesenlar, 1, 2, 3, 4",
  "changesinlym, bean, oval, round",
  "defectinnode, no, lacunar, lacmarginal, laccentral",
  "changesinnode, no, lacunar, lacmargin, laccentral",
  "changesinstru, no, grainy, droplike, coarse, diluted, reticular, stripped, faint",
  "specialforms, no, chalices, vesicles",
  "dislocationof, no, yes",
  "exclusionofno, no, yes",
  "noofnodesin, 0-9, 10-19, 20-29, 30-39, 40-49, 50-59, 60-69, >=70"
)

lymph_names <- strsplit(lymph_names, split = ", ")
colnames(lymph) <- sapply(lymph_names, "[", 1)
factor_labels <- lapply(lymph_names, "[", -1)


for(i in 1:ncol(lymph)) lymph[[i]] <- factor(lymph[[i]], levels = 1:length(factor_labels[[i]]),
  labels = factor_labels[[i]])

head(lymph)

summary(lymph)

Lymphography <- lymph

save(Lymphography, file="../../../data/Lymphography.rda")

