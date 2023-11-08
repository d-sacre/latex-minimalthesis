%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start of file `minimalthesis.cls'.                                %%
%%                                                                   %%
%% version: v0.0.2                                                   %%
%% status: alpha                                                     %%
%% file version: 2023-11-XX                                          %%
%%                                                                   %%
%% Copyright 2023 Daniel Sacré.                                      %%
%%                                                                   %%    
%% A very simple document class for writing theses, especially in    %%
%% natural sciences                                                  %%
%%                                                                   %%
%% This piece of software comes without any warranty, not even that  %%
%% it is fit for the intended purpose. Since it is an alpha-release, %%
%% Bug reports and suggestions via github are highly welcome.        %%
%%                                                                   %%
%% LICENSE:                                                          %%
%% This work may be distributed and/or modified under the            %%
%% conditions of the LaTeX Project Public License version 1.3c, or   %%
%% (at your option) any later version. The full license text is      %%
%% available at http://www.latex-project.org/lppl/.                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{./class/minimalthesis}[2023-11-30 v0.0.2-alpha Daniel Sacré LaTeX Project Public License version 1.3c]

\DeclareOption*{\OptionNotUsed}
\ProcessOptions\relax

\LoadClass[
    a4paper,
    bibliography=totoc,
    listof=totoc,
    noindent,
    parskip=full,
    twoside,
    open=any,
    BCOR=1cm,
    headsepline,
]{scrreprt}

\RequirePackage{pgfkeys,etoolbox,ragged2e}

%%%%%%%%%%%%%%%%%%%%%%%%%% only for testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*\mt@title{}
\newcommand*\mt@titleformat{}

\pgfkeys{
    /mt/.cd,
    author/name/.store in = \mt@title,
    author/place of birth/.store in = \mt@titleformat
}

\newcommand*\setup[1]{\pgfqkeys{/mt}{#1}}

\newcommand{\testtitle}{{\mt@titleformat\mt@title}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[english]{babel}

\RequirePackage[utf8]{inputenc}
\RequirePackage{fontenc}

\RequirePackage{csquotes}
\RequirePackage{enumitem}

\RequirePackage[top=1.5cm, bottom=1.5cm, includeheadfoot,showframe=false,asymmetric]{geometry}

\RequirePackage{scrlayer-scrpage}
\pagestyle{scrheadings}


\clearpairofpagestyles

\automark[section]{chapter}


\clearmainofpairofpagestyles
\chead{\small\rightorleftmark}
\cfoot[\pagemark]{\pagemark} %Seitenzahl zentriert im Fuß


\makeatletter
\newcommand{\rightorleftmark}{%
        \begingroup\protected@edef\x{\rightmark}%
        \ifx\x\@empty
            \endgroup
            \leftmark
        \else
            \endgroup
            \rightmark
        \fi
    }
\makeatother
%%%%%https://tex.stackexchange.com/questions/101915/latex-fancyhdr-is-possible-to-use-leftmark-and-rightmark-alternatively

\renewcommand*{\chapterheadstartvskip}{\vspace*{0cm}}
\renewcommand*{\chapterheadendvskip}{\vspace{0.5cm}}

\makeatletter
%% check if this are the original definitions
\CheckCommand\section{%
    \scr@startsection{section}{\sectionnumdepth}{\z@}%
    {-3.5ex \@plus -1ex \@minus -.2ex}%
    {2.3ex \@plus.2ex}%
    {\ifnum \scr@compatibility>\@nameuse{scr@v@2.96}\relax
    \setlength{\parfillskip}{\z@ plus 1fil}\fi
    \raggedsection\normalfont\sectfont\nobreak\size@section}%
}

\renewcommand\section{%
    \scr@startsection{section}{\sectionnumdepth}{\z@}%
    {-.5\baselineskip}%
    {.0625\baselineskip}%
    {\ifnum \scr@compatibility>\@nameuse{scr@v@2.96}\relax
    \setlength{\parfillskip}{\z@ plus 1fil}\fi
    \raggedsection\normalfont\sectfont\nobreak\size@section}%
}
\makeatother

%usepackages related to graphics
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{wrapfig}

\usetikzlibrary{calc,arrows, intersections,arrows.meta}
\usetikzlibrary{shapes.arrows,shapes.geometric,decorations.markings,positioning}
\usetikzlibrary{spy}
\usetikzlibrary{fadings}
\usetikzlibrary{mindmap,trees}

%usepackages related to science
\RequirePackage{siunitx}
\RequirePackage{mhchem}
\RequirePackage{amsmath,bm,amssymb}
\RequirePackage{physics} % derivative, differentials
\RequirePackage{derivative}
\RequirePackage{harpoon} %provides \overrightharp
\RequirePackage{tikz-3dplot}


\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\RequirePackage{pgfplotstable}
\usepgfplotslibrary{fillbetween,groupplots}


\usepgfplotslibrary{external}
\tikzexternalize[prefix=tikzexternalize/]

%\pgfplotsset{
%    legend image with text/.style={
%        legend image code/.code={%
%            \node[anchor=center] at (0.3cm,0cm) {#1};
%        }
%    },
%}

\RequirePackage{blindtext}
\RequirePackage{listings}

\RequirePackage[labelfont={bf}]{caption}
\captionsetup{format=plain,labelformat=simple,font=small,labelsep = colon}

\RequirePackage{tabulary}
\RequirePackage{multirow,makecell,cellspace}
\RequirePackage{multicol}
\RequirePackage{booktabs,colortbl,array}

% Bibliography
\RequirePackage[
    backend=biber,
    style=chem-angew,
	articletitle,
    % sortlocale=de_DE,
		% style=apsrev4-1,
	sorting=none,
    natbib=true,
    url=false,
    doi=true,
    eprint=true,
	maxbibnames=99,
]{biblatex}

% needs to be implemented
% \input{./minimalthesis/minimal-thesis_formatting-bib-entries.tex}
% \ExecuteBibliographyOptions{thesistitle}

\RequirePackage[hidelinks]{hyperref}