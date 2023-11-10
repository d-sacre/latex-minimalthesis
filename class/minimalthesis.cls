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

\RequirePackage{pgfkeys,ifthen}

%%%%%%%%%%%%%%%%%%%%%%%%%% only for testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newcommand*\mt@title{}
% \newcommand*\mt@titleformat{}

% \pgfkeys{
%     /mt/.cd,
%     author/name/.store in = \mt@title,
%     author/place of birth/.store in = \mt@titleformat
% }

% \newcommand*\setup[1]{\pgfqkeys{/mt}{#1}}

% \newcommand{\testtitle}{{\mt@titleformat\mt@title}}

% source: https://tex.stackexchange.com/questions/700759/pgfkeys-is-it-possible-to-achieve-a-dictionary-like-input-method-for-subkeys

% should allow for two user input possibilities:
% \setup{
% 	author/name=ABC, 
% 	author/place of birth=DEF
% }

% \setup{
%     author = {
%         name = ABC,
%         place of birth = DEF
%     }
% }

% \ExplSyntaxOn
%     \keys_define:nn{mt}
%     {
%         author .code:n = {\keys_set:nn {mt/author}{#1}},
%         author / name .tl_set:N = \l_mt_author_name,
%         author / place~of~birth .tl_set:N = \l_mt_author_birth,
%     }

%     \newcommand{\test}{%
%         \l_mt_author_name,~ %
%         \l_mt_author_birth%
%     }

%     \newcommand*\setup[1]{\keys_set:nn{mt}{#1}}
% \ExplSyntaxOff



\makeatletter
    % % macros for storing title data
    % \newcommand{\@mt@titlepage@title@font@family}{\normalfont}
    % \newcommand{\@mt@titlepage@title@font@size}{\Huge}
    \newcommand{\@mt@titlepage@title@font@weight}{\bfseries}
    % \newcommand{\@mt@titlepage@title@font@color}{black}

    % % macros for storing subtitle data
    % \newcommand{\@mt@titlepage@subtitle@font@family}{\normalfont}
    % \newcommand{\@mt@titlepage@subtitle@font@size}{\huge}
    \newcommand{\@mt@titlepage@subtitle@font@weight}{\bfseries}
    % \newcommand{\@mt@titlepage@subtitle@font@color}{black}


    \pgfkeys{
        /handlers/.is setter/.code=\pgfkeysedef{\pgfkeyscurrentpath}{%
            \noexpand\pgfqkeys{\pgfkeyscurrentpath}{##1}%
        },
        /mt/.cd,
        author/.is setter,
            author/name/.initial,
            author/place of birth/.initial,
        title/.initial,
        subtitle/.initial,
        pdfmetadata/.is setter,
            pdfmetadata/title/.initial,
            pdfmetadata/subject/.initial = {Academic Thesis},
            pdfmetadata/author/.initial  = \pgfkeysvalueof{/mt/author/name},
            pdfmetadata/keywords/.initial = {Academic Thesis},
            pdfmetadata/creator/.initial = {LaTeX with minimalthesis v0.0.2-alpha and hyperref},
        titlepage/.is setter,
            titlepage/title/.is setter,
                titlepage/title/text/.initial = \pgfkeysvalueof{/mt/title},
                titlepage/title/font/.is setter,
                    titlepage/title/font/family/.initial = \sffamily,
                    titlepage/title/font/size/.initial = \Huge,
                    titlepage/title/font/weight/.store in = \@mt@titlepage@title@font@weight,
                    titlepage/title/font/color/.initial = black,
                titlepage/title/@formated/.initial ={
                    \pgfkeysvalueof{/mt/titlepage/title/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/title/font/size}%
                    \@mt@titlepage@title@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/title/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/title/text}%
                },
            titlepage/subtitle/.is setter,
                titlepage/subtitle/text/.initial = \pgfkeysvalueof{/mt/subtitle},
                titlepage/subtitle/font/.is setter,
                    titlepage/subtitle/font/family/.initial = \normalfont,
                    titlepage/subtitle/font/size/.initial = \huge,
                    titlepage/subtitle/font/weight/.store in = \@mt@titlepage@subtitle@font@weight,
                    titlepage/subtitle/font/color/.initial = black,
                titlepage/subtitle/@formated/.initial = {
                    \pgfkeysvalueof{/mt/titlepage/subtitle/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/subtitle/font/size}%
                    \@mt@titlepage@subtitle@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/subtitle/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/subtitle/text}%
                },
            titlepage/logo/@insertable_element/.initial = \@mt@LogoTitlepage,
        % author/.code={\pgfqkeys{/mt/author}{#1}},
        %     author/name/.initial,
        %     author/place of birth/.initial,
        % title/.initial,
        % subtitle/.initial,
        % pdfmetadata/.code={\pgfqkeys{/mt/pdfmetadata}{#1}},
        %     pdfmetadata/title/.initial,
        %     pdfmetadata/subject/.initial = {Academic Thesis},
        %     pdfmetadata/author/.initial  = \pgfkeysvalueof{/mt/author/name},
        %     pdfmetadata/keywords/.initial = {Academic Thesis},
        %     pdfmetadata/creator/.initial = {LaTeX with minimalthesis v0.0.2-alpha and hyperref},
        % titlepage/.code={\pgfqkeys{/mt/titlepage}{#1}},
        %     % needs to be overhauled for capability to accept dictionary style input
        %     titlepage/title/text/.initial = \pgfkeysvalueof{/mt/title},
        %     titlepage/title/font/family/.store in = \@mt@titlepage@title@font@family,
        %     titlepage/title/font/size/.store in = \@mt@titlepage@title@font@size,
        %     titlepage/title/font/weight/.store in = \@mt@titlepage@title@font@weight,
        %     titlepage/title/font/color/.store in = \@mt@titlepage@title@font@color,
        %     titlepage/subtitle/text/.initial = \pgfkeysvalueof{/mt/subtitle},
        %     titlepage/subtitle/font/family/.store in = \@mt@titlepage@subtitle@font@family,
        %     titlepage/subtitle/font/size/.store in = \@mt@titlepage@subtitle@font@size,
        %     titlepage/subtitle/font/weight/.store in = \@mt@titlepage@subtitle@font@weight,
        %     titlepage/subtitle/font/color/.store in = \@mt@titlepage@subtitle@font@color,
        %     titlepage/logo/@insertable_element/.initial = \@mt@LogoTitlepage,
    }

    \newcommand*\@mt@pgfkeys@setup@TEMPLATE[2]{\pgfqkeys{#1}{#2}}
    \newcommand*\setup[1]{\@mt@pgfkeys@setup@TEMPLATE{/mt}{#1}} %\pgfqkeys{/mt}{#1}
\makeatother



\newcommand{\test}{%
    \pgfkeysvalueof{/mt/author/name}, %
    \pgfkeysvalueof{/mt/author/place of birth}%
}
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
\RequirePackage{wrapfig}

\RequirePackage{tikz}
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

% plotting
\RequirePackage{tikz-3dplot}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\RequirePackage{pgfplotstable}
\usepgfplotslibrary{fillbetween,groupplots}

\usepgfplotslibrary{external}
\tikzexternalize[prefix=tikzexternalize/]

\RequirePackage{listings}
\RequirePackage[labelfont={bf}]{caption}
\captionsetup{format=plain,labelformat=simple,font=small,labelsep = colon}

% Tables
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

% macro definition
\makeatletter
\newcommand{\@mt@LogoTitlepage}{
	\vspace{0.5cm}
	\includegraphics[width=12cm]{./class/img/minimalthesis_logo.pdf}
	\vspace{0.5cm}
}

\newcommand{\mtTitlepage}{%
	\newgeometry{twoside,outer=2.5cm,inner=3.5cm,top=2cm,bottom=2cm,includeheadfoot}
	\begin{titlepage}
		\centering
		\vfil
        { %
            \pgfkeysvalueof{/mt/titlepage/title/@formated}
            % \@mt@titlepage@title@font@family%
            % \@mt@titlepage@title@font@size%
            % \@mt@titlepage@title@font@weight%
            % \color{\@mt@titlepage@title@font@color}%
            % \pgfkeysvalueof{/mt/titlepage/title/text}%
        }%
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/subtitle/text}}{}}{%
            % if no subtitle is specified
            % nothing to do
        }{%
            \\
            \pgfkeysvalueof{/mt/titlepage/subtitle/@formated}
            % \@mt@titlepage@subtitle@font@family%
            % \@mt@titlepage@subtitle@font@size%
            % \@mt@titlepage@subtitle@font@weight%
            % \color{\@mt@titlepage@subtitle@font@color}%
            % \pgfkeysvalueof{/mt/titlepage/subtitle/text}%
        }
		\vfill
		\ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/logo/@insertable_element}}{}}{%
            % if no logo is specified
            % nothing to do
        }{%
			\pgfkeysvalueof{/mt/titlepage/logo/@insertable_element}\\
			\vfill
		}
		% {\usekomavar*{mt::thesis::type}\usekomavar{mt::thesis::type}\\}
		% {\large \usekomavar*{mt::thesis:legal-type-identifier}\\}
		% {\enquote{\usekomavar{mt::thesis:legal-type-identifier}}\vfil}
		% {\usekomavar*{mt::handed-in-by} \usekomavar{mt::handed-in-by}\\}
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% % if sans-serif font selected
		% \usekomavar[\ifstr]{mt::font}{sans-serif}{%
		% 	% if default author format string is \Large\scshape:
		% 	\usekomavar*[\ifstr]{mt::author::name}{\Large\scshape}{%
		% 		{\Large\bfseries\usekomavar{mt::author::name}\\[0.125cm]}%
		% 	}{%
		% 		{\usekomavar*{mt::author::name}\usekomavar{mt::author::name}\\[0.125cm]}%
		% 	}%
		% }{%
		% 	{\usekomavar*{mt::author::name}\usekomavar{mt::author::name}\\[0.125cm]}%
		% }
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% {\large\usekomavar*{mt::author::place-of-birth}\usekomavar{mt::author::place-of-birth}}
		% \vfil
		% \usekomavar[\ifstr]{mt::author::number-of-affiliations}{1}{
		% 	\mtIfKomavarNotEmptyWithOption{mt::institute}
		% 	\mtIfKomavarNotEmptyWithOption{mt::faculty}
		% 	\mtIfKomavarNotEmptyWithOption{mt::group}
		% }{}
		
		% \usekomavar[\ifstr]{mt::author::number-of-affiliations}{2}{
		% 	\begin{tabular}{m{0.45\linewidth}<{\centering}m{0.45\linewidth}<{\centering}}
		% 		\mtIfKomavarNotEmptyWithOptionTABLE{mt::institute}
		% 		\mtIfKomavarNotEmptyWithOptionTABLE{mt::faculty}
		% 		\mtIfKomavarNotEmptyWithOptionTABLE{mt::group}
		% 	\end{tabular}
		% }{}
		
		% \vfill
		% {\usekomavar{mt::date}\\}
		% \vfill
		% \mtIfKomavarNotEmptyWithoutOption{mt::examination-committee}
		% \normalsize
	
	\end{titlepage}
	
	\newpage\null\thispagestyle{empty}
} 
\makeatother

\newcommand{\mtTOC}{
	\newgeometry{left=3cm,right=2.5cm,top=2.75cm,bottom=2.75cm}
	{
		\renewcommand{\rightorleftmark}{appendix}
		\tableofcontents
	}
	
	\newgeometry{twoside,outer=2.5cm,inner=3.5cm,top=2cm,bottom=2cm,includeheadfoot}
	\newpage\null\thispagestyle{empty}
}

% Setting up document after user settings are available
% setting up the pdf meta data
\AddToHook{begindocument/end}{
    % create pdf title; if no specific pdf title is specified by the user, use thesis title and subtitle.
    % If no thesis subtitle is specified, use only thesis title
    \ifthenelse{\equal{\pgfkeysvalueof{/mt/pdfmetadata/title}}{}}{% if pdf title key is not set by user to a specific value
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/subtitle}}{}}{
            \pgfkeyssetvalue{/mt/pdfmetadata/title}{\pgfkeysvalueof{/mt/title}}
        }{
            \pgfkeyssetvalue{/mt/pdfmetadata/title}{\pgfkeysvalueof{/mt/title}~–~\pgfkeysvalueof{/mt/subtitle}}
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