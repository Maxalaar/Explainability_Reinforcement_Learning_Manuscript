#!/usr/bin/env perl
# Default build settings so that `latexmk manuscript.tex` (with no extra
# flags) always compiles with lualatex and never stops to wait for
# keyboard input on a warning or error.
$pdf_mode = 4;              # lualatex
$lualatex = 'lualatex -interaction=nonstopmode -synctex=1 %O %S';
$pdflatex = $lualatex;

# Build files and the working PDF go to build/Working; build_release.sh
# overrides this with -outdir for the two release versions.
$out_dir = 'build/Working';

# PlotNeuralNet styles (styles/plotneuralnet/*.sty) are loaded by name, so
# their folder is added to the TeX search path.
ensure_path('TEXINPUTS', './styles/plotneuralnet//');

# Glossaries: latexmk runs makeglossaries in the output directory, which the
# automake option of glossaries-extra cannot do when an output directory is set.
add_cus_dep('acn', 'acr', 0, 'makeglossaries');
add_cus_dep('glo', 'gls', 0, 'makeglossaries');
push @generated_exts, 'acn', 'acr', 'alg', 'glo', 'gls', 'glg';
sub makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    return system('makeglossaries', '-d', $path, $base_name);
}
