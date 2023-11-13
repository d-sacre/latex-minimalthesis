%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start of file `./class/minimalthesis.cls'.                        %%
%%                                                                   %%
%% version: v0.0.2-alpha-1                                           %%
%% status: alpha                                                     %%
%% file version: 2023-11-XX                                          %%
%%                                                                   %%
%% Copyright 2023 Daniel Sacré.                                      %%
%%                                                                   %%    
%% A very simple document class for writing theses, especially in    %%
%% natural sciences.                                                 %%
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

% \setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{./class/minimalthesis}[2023-11-30 v0.0.2-alpha-1 Daniel Sacré LaTeX Project Public License version 1.3c]

\DeclareOption*{\OptionNotUsed}
\ProcessOptions\relax

\LoadClass[
    a4paper,
    bibliography=totoc,
    listof=totoc,
    noindent,
    parskip=full,
    twoside,
    open= any,
    BCOR=1cm,
    headsepline,
]{scrreprt}

\RequirePackage[dvipsnames]{xcolor} % needs to be loaded here to avoid issues due to options clash with pgf
\RequirePackage{ifthen, etoolbox}
\RequirePackage{pgfkeys, pgffor,pgf}

% load pgfkeys setup
\input{./class/pgfkeys/minimalthesis_pgfkeys.setup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[english]{babel}

\RequirePackage[utf8]{inputenc}
\RequirePackage{fontenc}

\RequirePackage{csquotes}
\RequirePackage{enumitem}

\RequirePackage{scrlayer-scrpage}
\pagestyle{scrheadings}

\clearpairofpagestyles
\automark[section]{chapter}

\clearmainofpairofpagestyles
\chead{\small\rightorleftmark}
\cfoot[\pagemark]{\pagemark} % page number centered in foot

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

% usepackages related to graphics
% \RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{wrapfig}

\RequirePackage{tikz}
\usetikzlibrary{calc,arrows, intersections,arrows.meta}
\usetikzlibrary{shapes.arrows,shapes.geometric,decorations.markings,positioning}
\usetikzlibrary{spy}
\usetikzlibrary{fadings}
\usetikzlibrary{mindmap,trees}

% usepackages related to science
\RequirePackage{siunitx}
\RequirePackage{mhchem}
\RequirePackage{amsmath,bm,amssymb}
\RequirePackage{physics,derivative} % derivative, differentials
\RequirePackage{harpoon} % provides \overrightharp

% plotting
\RequirePackage{tikz-3dplot}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\RequirePackage{pgfplotstable}
\usepgfplotslibrary{fillbetween,groupplots}

\usepgfplotslibrary{external}
\tikzexternalize[prefix=tikzexternalize/]

% \RequirePackage{listings} % only if code snippets to be shown
\RequirePackage[labelfont={bf}]{caption}
\captionsetup{format=plain,labelformat=simple,font=small,labelsep = colon}

% Tables
\RequirePackage{tabulary}
\RequirePackage{multirow,makecell,cellspace}
\RequirePackage{multicol}
\RequirePackage{booktabs,colortbl,array}

% Bibliography
% REMARK: Can neither be set in \AtEndPreamble, nor \AddToHook{begindocument/before}{...};
% See: https://github.com/plk/biblatex/issues/1107
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

\RequirePackage[hidelinks]{hyperref}

% Loading of definitions of special pages
\input{./class/pages/title/minimalthesis_titlepage.def}
\input{./class/pages/toc/minimalthesis_toc.def}
\newcommand{\mtGenerateBibliography}{\printbibliography}

\AddToHook{begindocument/before}{
        % Passing options to packages
        % geometry package
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/debug/show margins}}{true}%
        }{%
            \PassOptionsToPackage{top=1.5cm, bottom=1.5cm, includeheadfoot,asymmetric,showframe}{geometry}  
        }{%
            \PassOptionsToPackage{top=1.5cm, bottom=1.5cm, includeheadfoot,asymmetric}{geometry}
        }
        \RequirePackage{geometry}

    % adding the bibliography file
    \ifthenelse{%
        \equal{\pgfkeysvalueof{/mt/bibliography/file path}}{}%
    }{%
        % no bibliography file specified
        % nothing to do
    }{%
        \input{./class/bib/minimal-thesis_formatting-bib-entries.tex}
        \ExecuteBibliographyOptions{thesistitle}
        \addbibresource{\pgfkeysvalueof{/mt/bibliography/file path}}
    }

    % setting the default font of the document
    \ifthenelse{%
        \equal{\pgfkeysvalueof{/mt/visual styling/default font}}{sans-serif}
    }{%
        \RequirePackage{newtxtext}
        \RequirePackage[uprightGreek]{newtxmath} % TO DO: verify wether uprightGreek option is necessary
        \renewcommand*\familydefault{\sfdefault}
    }{%
        \RequirePackage{lmodern}
        \RequirePackage{microtype}
    }
}

% Setting up document after user settings are available
% setting up the pdf meta data
\AddToHook{begindocument/end}{
    % create pdf title; if no specific pdf title is specified by the user, use thesis title and subtitle.
    % If no thesis subtitle is specified, use only thesis title
    \ifthenelse{\equal{\pgfkeysvalueof{/mt/pdfmetadata/title}}{}}{% if pdf title key is not set by user to a specific value
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/thesis/subtitle}}{}}{
            \pgfkeyssetvalue{/mt/pdfmetadata/title}{\pgfkeysvalueof{/mt/thesis/title}}
        }{
            \pgfkeyssetvalue{/mt/pdfmetadata/title}{\pgfkeysvalueof{/mt/thesis/title}~–~\pgfkeysvalueof{/mt/thesis/subtitle}}
        }
    }{%
        % pdf title key is specified by user
        % nothing to do 
    }

    % setting the pdf metadata
    \hypersetup{
        pdftitle={\pgfkeysvalueof{/mt/pdfmetadata/title}},
        pdfsubject={\pgfkeysvalueof{/mt/pdfmetadata/subject}},
        pdfauthor={\pgfkeysvalueof{/mt/pdfmetadata/author}},
        pdfkeywords={\pgfkeysvalueof{/mt/pdfmetadata/keywords}},
        pdfcreator={\pgfkeysvalueof{/mt/pdfmetadata/creator}}
    }
}