#!/usr/bin/env Rscript
# LC-MS Peak Picker — XCMS CentWave wrapper for Galaxy
# A*STAR Bioinformatics Institute

suppressPackageStartupMessages(library(optparse))

# ── Argument parsing ───────────────────────────────────────────────
option_list <- list(
  make_option("--input",       type="character", help="Input mzML/mzXML file"),
  make_option("--output",      type="character", help="Output .peaks file"),
  make_option("--ppm",         type="double",  default=15,   help="PPM error margin"),
  make_option("--sn",          type="double",  default=1.5,  help="S/N threshold"),
  make_option("--min_pw",      type="double",  default=5,    help="Min peakwidth (s)"),
  make_option("--max_pw",      type="double",  default=20,   help="Max peakwidth (s)"),
  make_option("--pref_k",      type="integer", default=0L,   help="Prefilter k"),
  make_option("--pref_i",      type="double",  default=0,    help="Prefilter I"),
  make_option("--sample_name", type="character", default="sample", help="Sample name")
)

opt <- parse_args(OptionParser(option_list=option_list))

# ── Validate inputs ────────────────────────────────────────────────
if (is.null(opt$input) || !file.exists(opt$input)) {
  stop("Input file not found: ", opt$input)
}

if (is.null(opt$output)) {
  stop("Output path not specified.")
}

cat("LC-MS Peak Picker v2.0\n")
cat("======================\n")
cat("Input:       ", opt$input, "\n")
cat("Sample name: ", opt$sample_name, "\n")
cat("PPM:         ", opt$ppm, "\n")
cat("S/N:         ", opt$sn, "\n")
cat("Peakwidth:   ", opt$min_pw, "-", opt$max_pw, "s\n")
cat("Prefilter:   k=", opt$pref_k, " I=", opt$pref_i, "\n")
cat("\n")

# ── Load libraries ─────────────────────────────────────────────────
cat("Loading XCMS...\n")
suppressPackageStartupMessages(library(MSnbase))
suppressPackageStartupMessages(library(xcms))

# ── Run CentWave ───────────────────────────────────────────────────
tryCatch({

  cat("Reading MS data...\n")
  raw_data <- readMSData(opt$input, mode="onDisk", verbose=FALSE)

  cat("Running CentWave peak detection...\n")
  cwp <- CentWaveParam(
    ppm       = opt$ppm,
    peakwidth = c(opt$min_pw, opt$max_pw),
    snthresh  = opt$sn,
    prefilter = c(opt$pref_k, opt$pref_i)
  )

  xdata    <- findChromPeaks(raw_data, param=cwp)
  peaks_df <- as.data.frame(chromPeaks(xdata))

  if (nrow(peaks_df) == 0) {
    cat("WARNING: No peaks detected. Consider relaxing parameters.\n")
  }

  # ── Ensure required columns ──────────────────────────────────────
  required_cols <- c("mz","mzmin","mzmax","rt","rtmin","rtmax",
                     "into","intb","maxo","sn")
  for (col in required_cols) {
    if (!col %in% colnames(peaks_df)) {
      peaks_df[[col]] <- 0.0
    }
  }

  # Add sample name column
  peaks_df$sample <- opt$sample_name

  # Select and order final columns
  final_cols <- c(required_cols, "sample")
  peaks_df   <- peaks_df[, final_cols]

  # ── Write output ─────────────────────────────────────────────────
  write.table(peaks_df, opt$output,
              sep="\t", row.names=FALSE, quote=FALSE)

  cat("\nSUCCESS:", nrow(peaks_df), "peaks detected and written to output.\n")

}, error=function(e) {
  cat("\nERROR:", conditionMessage(e), "\n")
  quit(status=1)
})
