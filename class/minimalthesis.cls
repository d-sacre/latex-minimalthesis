%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start of file `minimalthesis.cls'.                                %%
%%                                                                   %%
%% version: v0.0.2-alpha-1                                            %%
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

%%%%%%%%%%%%%%%%%%%%%%%%%% only for testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

\makeatletter
    % counters
    \newcounter{@mt@thesis@titlepage@reviewers@counter}

    \newcommand{\@mt@titlepage@logo@insertableElement@GENERATE}{
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/logo/object type}}{image}}{%
            % object type = image
            \vspace{0.5cm}
            \ifthenelse{%
                \equal{\pgfkeysvalueof{/mt/titlepage/logo/height}}{}%
            }{%
                % no height specified
                \ifthenelse{%
                    \equal{\pgfkeysvalueof{/mt/titlepage/logo/width}}{}%
                }{%
                    % no height, no width specified
                    \includegraphics{\pgfkeysvalueof{/mt/titlepage/logo/file path}}%
                }{
                    % no height specified, width specified
                    \includegraphics[width = \pgfkeysvalueof{/mt/titlepage/logo/width}]{\pgfkeysvalueof{/mt/titlepage/logo/file path}}
                }
            }{%
                % height specified
                \ifthenelse{%
                    \equal{\pgfkeysvalueof{/mt/titlepage/logo/width}}{}%
                }{%
                    % height specified, no width specified
                    % REMARK: To prevent issues with parsing of optional arguments by includegraphics, writing the full macro for each case.
                    % FUTURE: Improve logic
                    \includegraphics[height = \pgfkeysvalueof{/mt/titlepage/logo/height}]{\pgfkeysvalueof{/mt/titlepage/logo/file path}}
                }{%
                    % height and width specified
                    \includegraphics[%
                        height = \pgfkeysvalueof{/mt/titlepage/logo/height},%
                        width = \pgfkeysvalueof{/mt/titlepage/logo/width}%
                    ]{\pgfkeysvalueof{/mt/titlepage/logo/file path}}%
                }%
            }%
            \vspace{0.5cm}
        }{unrecognized type}%
    }

    \newcommand{\@mt@titlepage@thesisType@text@GENERATE}{
        \pgfkeysvalueof{/mt/thesis/type}%
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/thesis/type}}{Dissertation}%
        }{}{~Thesis}
    }

    \newcommand{\@mt@titlepage@legalIdentifier@text@GENERATE}{
        \pgfkeysvalueof{/mt/titlepage/legal identifier/prefix}\\
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/thesis/type}}{Bachelor}%
        }{%
            \enquote{\pgfkeysvalueof{/mt/academic degree identifiers/bachelor}}%
        }{}%
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/thesis/type}}{Master}%
        }{%
            \enquote{\pgfkeysvalueof{/mt/academic degree identifiers/master}}%
        }{}%
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/thesis/type}}{Dissertation}}{%
            \enquote{\pgfkeysvalueof{/mt/academic degree identifiers/phd}}%
        }{}%
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/thesis/type}}{Doctoral}}{%
            \enquote{\pgfkeysvalueof{/mt/academic degree identifiers/phd}}%
        }{}%
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/thesis/type}}{PhD}}{%
            \enquote{\pgfkeysvalueof{/mt/academic degree identifiers/phd}}%
        }{}%
    }

    \newcommand{\@mt@titlepage@affiliation@formated}{
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{rows}%
        }{%
            % listing style rows; simply return input with styling applied
            \pgfkeysvalueof{/mt/thesis/author/affiliation}%
        }{%
            \ifthenelse{%
                \equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{cols}%
            }{%
                % listing style columns
                \pgfkeys{body loop/.code={{##1}\\},body loop/.list/.expanded=\pgfkeysvalueof{/mt/thesis/author/affiliation}}%
            }{%
                UNKOWN OPTION %
                % needs error message
            }
        }
    }

    \newcommand{\@mt@titlepage@affiliations@singleElementLoop}[2]{
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{rows}%
        }{%
            % listing style rows; simply return input with styling applied
            {%
                \pgfkeysvalueof{/mt/titlepage/author affiliations/font/family/}%
                \pgfkeysvalueof{/mt/titlepage/author affiliations/font/size}%
                \color{\pgfkeysvalueof{/mt/titlepage/author affiliations/font/color}}%
                \@mt@titlepage@authorAffiliations@font@weight%
                #1\\%
            }%
        }{%
            \ifthenelse{%
                \equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{cols}%
            }{%
                % listing style columns
                \begin{minipage}[t]{\@mt@titlepage@affiliations@subcontainer@width\linewidth}
                    \centering
                    \pgfkeysvalueof{/mt/titlepage/author affiliations/font/family/}%
                    \pgfkeysvalueof{/mt/titlepage/author affiliations/font/size}%
                    \color{\pgfkeysvalueof{/mt/titlepage/author affiliations/font/color}}%
                    \@mt@titlepage@authorAffiliations@font@weight%
                    \foreach \element in {#1}{\element\\}%
                \end{minipage}
                \hfil
            }{%
                UNKOWN OPTION%
                % needs error message
            }
        }
    }

    \newcommand{\@mt@titlepage@affiliations@formated}{%
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{cols}%
        }{%
            % calculation of number of affiliations
            \newcounter{@mt@tmp@counter}
            \setcounter{@mt@tmp@counter}{0}
            \pgfkeys{body loop/.code={\stepcounter{@mt@tmp@counter}},body loop/.list/.expanded=\pgfkeysvalueof{/mt/thesis/author/affiliations}}%
            \pgfmathsetmacro{\@mt@titlepage@affiliations@subcontainer@width}{(1/\the@mt@tmp@counter)*\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/column entry width factor}}
            \begin{minipage}{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/column container width}}
                \centering
                \hfil
                \pgfkeys{body loop/.code={\@mt@titlepage@affiliations@singleElementLoop{##1}{\@mt@titlepage@affiliations@subcontainer@width}},body loop/.list/.expanded=\pgfkeysvalueof{/mt/thesis/author/affiliations}}%
            \end{minipage}
        }{%
            \pgfkeys{body loop/.code={\@mt@titlepage@affiliations@singleElementLoop{##1}{\@mt@titlepage@affiliations@subcontainer@width}},body loop/.list/.expanded=\pgfkeysvalueof{/mt/thesis/author/affiliations}}%
        }
    }%

    \newcommand{\@mt@titlepage@examinationCommittee@reviewers@formated}{%
        \pgfkeys{body loop/.code={%
                \\{%
                    \raggedright%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/descriptor/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/descriptor/font/size}
                    \@mt@titlepage@examinationCommittee@reviewers@descriptor@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/descriptor/font/color}}%
                    \the@mt@thesis@titlepage@reviewers@counter.~%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/descriptor/text}%
                } \hfill {%
                    \raggedleft
                    \pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/names/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/names/font/size}
                    \@mt@titlepage@examinationCommittee@reviewers@names@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/examination committee/reviewers/names/font/color}}%
                    {##1}%
                }\stepcounter{@mt@thesis@titlepage@reviewers@counter}
            },%
            body loop/.list/.expanded=\pgfkeysvalueof{/mt/thesis/examiners/reviewers}%
        }%
    }%

    % macros for storing titlepage font weight data
    \newcommand{\@mt@titlepage@title@font@weight}{\bfseries}
    \newcommand{\@mt@titlepage@subtitle@font@weight}{\bfseries}
    \newcommand{\@mt@titlepage@thesisType@font@weight}{}
    \newcommand{\@mt@titlepage@legalIdentifier@font@weight}{}
    \newcommand{\@mt@titlepage@handedInBy@font@weight}{}
    \newcommand{\@mt@titlepage@author@font@weight}{}
    \newcommand{\@mt@titlepage@placeOfBirth@font@weight}{}
    \newcommand{\@mt@titlepage@authorAffiliations@font@weight}{}
    \newcommand{\@mt@titlepage@date@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@title@font@weight}{\bfseries}
    \newcommand{\@mt@titlepage@examinationCommittee@chairman@descriptor@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@chairman@name@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@reviewers@descriptor@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@reviewers@names@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@additionalExaminer@descriptor@font@weight}{}
    \newcommand{\@mt@titlepage@examinationCommittee@additionalExaminer@name@font@weight}{}

    % pgfkeys setup
    \pgfkeys{%
        /handlers/.is setter/.code=\pgfkeysedef{\pgfkeyscurrentpath}{%
            \noexpand\pgfqkeys{\pgfkeyscurrentpath}{##1}%
        },%
        /mt/.cd,%
        thesis/.is setter,
            thesis/title/.initial,%
            thesis/subtitle/.initial,%
            thesis/type/.initial,%
            thesis/author/.is setter,
                thesis/author/name/.initial,
                thesis/author/place of birth/.initial,
                thesis/author/affiliation/.initial,
                thesis/author/affiliations/.initial,
            thesis/type/.initial,
            thesis/date/.initial = \today,
            thesis/examiners/.is setter,
                thesis/examiners/chairman/.initial,
                thesis/examiners/reviewers/.initial,
                thesis/examiners/additional/.initial,
        visual styling/.is setter,
            visual styling/default font/.initial = serif,
        academic degree identifiers/.is setter,
            academic degree identifiers/bachelor/.initial = {Bachelor of Science (B.Sc.)},
            academic degree identifiers/master/.initial = {Master of Science (M.Sc.)},
            academic degree identifiers/phd/.initial = {Philosophical Doctor (PhD)},
        pdfmetadata/.is setter,
            pdfmetadata/title/.initial,
            pdfmetadata/subject/.initial = {Academic Thesis},
            pdfmetadata/author/.initial  = \pgfkeysvalueof{/mt/thesis/author/name},
            pdfmetadata/keywords/.initial = {Academic Thesis},
            pdfmetadata/creator/.initial = {LaTeX with minimalthesis v0.0.2-alpha-1 and hyperref},
        titlepage/.is setter,
            titlepage/title/.is setter,
                titlepage/title/text/.initial = \pgfkeysvalueof{/mt/thesis/title},
                titlepage/title/font/.is setter,
                    titlepage/title/font/family/.initial = \sffamily,
                    titlepage/title/font/size/.initial = \Huge,
                    titlepage/title/font/weight/.store in = \@mt@titlepage@title@font@weight,
                    titlepage/title/font/color/.initial = black,
                titlepage/title/@formated/.initial ={%
                    \pgfkeysvalueof{/mt/titlepage/title/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/title/font/size}%
                    \@mt@titlepage@title@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/title/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/title/text}%
                },
            titlepage/subtitle/.is setter,
                titlepage/subtitle/text/.initial = \pgfkeysvalueof{/mt/thesis/subtitle},
                titlepage/subtitle/font/.is setter,
                    titlepage/subtitle/font/family/.initial = \normalfont,
                    titlepage/subtitle/font/size/.initial = \huge,
                    titlepage/subtitle/font/weight/.store in = \@mt@titlepage@subtitle@font@weight,
                    titlepage/subtitle/font/color/.initial = black,
                titlepage/subtitle/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/subtitle/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/subtitle/font/size}%
                    \@mt@titlepage@subtitle@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/subtitle/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/subtitle/text}%
                },
            titlepage/logo/.is setter,
                titlepage/logo/object type/.initial,
                titlepage/logo/file path/.initial,
                titlepage/logo/height/.initial,
                titlepage/logo/width/.initial,
            titlepage/logo/@insertable_element/.initial = {%
                \@mt@titlepage@logo@insertableElement@GENERATE%
            },%
            titlepage/thesis type/.is setter,% 
                titlepage/thesis type/text/.initial,
                titlepage/thesis type/font/.is setter,
                    titlepage/thesis type/font/family/.initial = \normalfont, 
                    titlepage/thesis type/font/size/.initial = \Large,
                    titlepage/thesis type/font/weight/.store in = \@mt@titlepage@thesisType@font@weight,
                    titlepage/thesis type/font/color/.initial = black,
                titlepage/thesis type/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/thesis type/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/thesis type/font/size}%
                    \@mt@titlepage@thesisType@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/thesis type/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/thesis type/text}%
                },
            titlepage/legal identifier/.is setter,% 
                titlepage/legal identifier/text/.initial,
                titlepage/legal identifier/prefix/.initial = To obtain the Academic Degree,
                titlepage/legal identifier/font/.is setter,
                    titlepage/legal identifier/font/family/.initial = \normalfont, % needs to be changed if main document font is set to sans serif
                    titlepage/legal identifier/font/size/.initial = \large,
                    titlepage/legal identifier/font/weight/.store in = \@mt@titlepage@legalIdentifier@font@weight,
                    titlepage/legal identifier/font/color/.initial = black,
                titlepage/legal identifier/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/legal identifier/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/legal identifier/font/size}%
                    \@mt@titlepage@legalIdentifier@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/legal identifier/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/legal identifier/text}%
                },
            titlepage/handed in by/.is setter,
                titlepage/handed in by/text/.initial = handed in by,
                titlepage/handed in by/font/.is setter,
                    titlepage/handed in by/font/family/.initial = \normalfont,
                    titlepage/handed in by/font/size/.initial = \large,
                    titlepage/handed in by/font/weight/.store in = \@mt@titlepage@handedInBy@font@weight,
                    titlepage/handed in by/font/color/.initial = black,
                titlepage/handed in by/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/handed in by/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/handed in by/font/size}%
                    \@mt@titlepage@handedInBy@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/handed in by/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/handed in by/text}%
                },%
            titlepage/author/.is setter,% 
                titlepage/author/text/.initial = \pgfkeysvalueof{/mt/thesis/author/name},
                titlepage/author/font/.is setter,
                    titlepage/author/font/family/.initial = \scshape, % needs to be changed if main document font is set to sans serif
                    titlepage/author/font/size/.initial = \Large,
                    titlepage/author/font/weight/.store in = \@mt@titlepage@author@font@weight,
                    titlepage/author/font/color/.initial = black,
                titlepage/author/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/author/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/author/font/size}%
                    \@mt@titlepage@author@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/author/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/author/text}%
                },%
            titlepage/place of birth/.is setter,%
                titlepage/place of birth/prefix/.initial = {born in},
                titlepage/place of birth/text/.initial = {\pgfkeysvalueof{/mt/titlepage/place of birth/prefix}~\pgfkeysvalueof{/mt/thesis/author/place of birth}},
                titlepage/place of birth/font/.is setter,
                    titlepage/place of birth/font/family/.initial = \normalfont,
                    titlepage/place of birth/font/size/.initial = \large,
                    titlepage/place of birth/font/weight/.store in = \@mt@titlepage@placeOfBirth@font@weight,
                    titlepage/place of birth/font/color/.initial = black,
                titlepage/place of birth/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/place of birth/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/place of birth/font/size}%
                    \@mt@titlepage@placeOfBirth@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/place of birth/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/place of birth/text}%
                },%
            titlepage/author affiliations/.is setter,
                titlepage/author affiliations/font/.is setter,
                    titlepage/author affiliations/font/family/.initial = \normalfont,
                    titlepage/author affiliations/font/size/.initial = \normalsize,
                    titlepage/author affiliations/font/weight/.store in = \@mt@titlepage@authorAffiliations@font@weight,
                    titlepage/author affiliations/font/color/.initial = black,
                titlepage/author affiliations/listing style/.is setter,
                    titlepage/author affiliations/listing style/alignment/.initial = rows,
                    titlepage/author affiliations/listing style/padding/.is setter, 
                        titlepage/author affiliations/listing style/padding/vertical/.initial = {\ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/alignment}}{rows}}{\vfil}{\vfill}},
                    titlepage/author affiliations/listing style/column container width/.initial = \linewidth,
                    titlepage/author affiliations/listing style/column entry width factor/.initial = 0.75,
            titlepage/date/.is setter,%
                titlepage/date/text/.initial = \pgfkeysvalueof{/mt/thesis/date},
                titlepage/date/font/.is setter,
                    titlepage/date/font/family/.initial = \normalfont,
                    titlepage/date/font/size/.initial = \normalsize,
                    titlepage/date/font/weight/.store in = \@mt@titlepage@date@font@weight,
                    titlepage/date/font/color/.initial = black,
                titlepage/date/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/date/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/date/font/size}%
                    \@mt@titlepage@date@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/date/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/date/text}%
                },%
            titlepage/examination committee/.is setter,%
                titlepage/examination committee/width/.initial = 0.66\linewidth,
                titlepage/examination committee/title/.is setter,
                    titlepage/examination committee/title/text/.initial = {Examination Committee:},
                    titlepage/examination committee/title/padding/.is setter,
                        titlepage/examination committee/title/padding/vertical/.initial = {0.125cm},
                    titlepage/examination committee/title/font/.is setter,
                        titlepage/examination committee/title/font/family/.initial = \normalfont,
                        titlepage/examination committee/title/font/size/.initial = \normalsize,
                        titlepage/examination committee/title/font/weight/.store in = \@mt@titlepage@examinationCommittee@title@font@weight,
                        titlepage/examination committee/title/font/color/.initial = black,
                    titlepage/examination committee/chairman/.is setter,
                        titlepage/examination committee/chairman/descriptor/.is setter,
                            titlepage/examination committee/chairman/descriptor/text/.initial = {Chairman:},
                            titlepage/examination committee/chairman/descriptor/font/.is setter,
                                titlepage/examination committee/chairman/descriptor/font/family/.initial = \normalfont,
                                titlepage/examination committee/chairman/descriptor/font/size/.initial = \normalsize,
                                titlepage/examination committee/chairman/descriptor/font/weight/.store in = \@mt@titlepage@examinationCommittee@chairman@descriptor@font@weight,
                                titlepage/examination committee/chairman/descriptor/font/color/.initial = black,
                        titlepage/examination committee/chairman/name/.is setter,
                            titlepage/examination committee/chairman/name/font/.is setter,
                                titlepage/examination committee/chairman/name/font/family/.initial = \normalfont,
                                titlepage/examination committee/chairman/name/font/size/.initial = \normalsize,
                                titlepage/examination committee/chairman/name/font/weight/.store in = \@mt@titlepage@examinationCommittee@chairman@name@font@weight,
                                titlepage/examination committee/chairman/name/font/color/.initial = black,
                    titlepage/examination committee/reviewers/.is setter,
                        titlepage/examination committee/reviewers/descriptor/.is setter,
                            titlepage/examination committee/reviewers/descriptor/text/.initial = {Reviewer:},
                            titlepage/examination committee/reviewers/descriptor/font/.is setter,
                                titlepage/examination committee/reviewers/descriptor/font/family/.initial = \normalfont,
                                titlepage/examination committee/reviewers/descriptor/font/size/.initial = \normalsize,
                                titlepage/examination committee/reviewers/descriptor/font/weight/.store in = \@mt@titlepage@examinationCommittee@reviewers@descriptor@font@weight,
                                titlepage/examination committee/reviewers/descriptor/font/color/.initial = black,
                        titlepage/examination committee/reviewers/names/.is setter,
                            titlepage/examination committee/reviewers/names/font/.is setter,
                                titlepage/examination committee/reviewers/names/font/family/.initial = \normalfont,
                                titlepage/examination committee/reviewers/names/font/size/.initial = \normalsize,
                                titlepage/examination committee/reviewers/names/font/weight/.store in = \@mt@titlepage@examinationCommittee@reviewers@names@font@weight,
                                titlepage/examination committee/reviewers/names/font/color/.initial = black,
                    titlepage/examination committee/additional examiner/.is setter,
                        titlepage/examination committee/additional examiner/descriptor/.is setter,
                            titlepage/examination committee/additional examiner/descriptor/text/.initial = {Additional Examiner:},
                            titlepage/examination committee/additional examiner/descriptor/font/.is setter,
                                titlepage/examination committee/additional examiner/descriptor/font/family/.initial = \normalfont,
                                titlepage/examination committee/additional examiner/descriptor/font/size/.initial = \normalsize,
                                titlepage/examination committee/additional examiner/descriptor/font/weight/.store in = \@mt@titlepage@examinationCommittee@additionalExaminer@descriptor@font@weight,
                                titlepage/examination committee/additional examiner/descriptor/font/color/.initial = black,
                        titlepage/examination comittee/additional examiner/name/.is setter,  
                            titlepage/examination committee/additional examiner/name/font/.is setter,
                                titlepage/examination committee/additional examiner/name/font/family/.initial = \normalfont,
                                titlepage/examination committee/additional examiner/name/font/size/.initial = \normalsize,
                                titlepage/examination committee/additional examiner/name/font/weight/.store in = \@mt@titlepage@examinationCommittee@additionalExaminer@name@font@weight,
                                titlepage/examination committee/additional examiner/name/font/color/.initial = black,
                titlepage/examination committee/title/@formated/.initial = {%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/title/font/family}%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/title/font/size}%
                    \@mt@titlepage@examinationCommittee@title@font@weight%
                    \color{\pgfkeysvalueof{/mt/titlepage/examination committee/title/font/color}}%
                    \pgfkeysvalueof{/mt/titlepage/examination committee/title/text}%
                },%
        debug/.is setter,
            debug/show margins/.initial = false
    }

    % \newcommand*\@mt@pgfkeys@setup@TEMPLATE[2]{\pgfqkeys{#1}{#2}}
    \newcommand*\mtSetupComplete[1]{\pgfqkeys{/mt}{#1}}%\@mt@pgfkeys@setup@TEMPLATE{/mt}{#1}} %\pgfqkeys{/mt}{#1}
\makeatother

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
\RequirePackage{physics} % derivative, differentials
\RequirePackage{derivative}
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
\newcommand{\mtTitlepage}{%
	\newgeometry{twoside,outer=2.5cm,inner=3.5cm,top=2cm,bottom=2cm,includeheadfoot}
	\begin{titlepage}
		\centering
		\vfil
        % needs to leak font settings so that line break distance to optional subtitle is correct
        \pgfkeysvalueof{/mt/titlepage/title/@formated}% 
        \ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/subtitle/text}}{}}{%
            % if no subtitle is specified
            % nothing to do
        }{%
            \\
            {\pgfkeysvalueof{/mt/titlepage/subtitle/@formated}\\}%
            \normalfont\normalsize% required to reset any changes from the title
        }%
		\vfill
		\ifthenelse{\equal{\pgfkeysvalueof{/mt/titlepage/logo/object type}}{}}{%
            % if no logo is specified
            % nothing to do
        }{%
			\pgfkeysvalueof{/mt/titlepage/logo/@insertable_element}\\
			\vfill
		}
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/thesis type/text}}{}%
        }{%
            % if thesis type text is empty
            {\pgfkeysvalueof{/mt/titlepage/thesis type/@formated}
            \@mt@titlepage@thesisType@text@GENERATE\\}
        }{%
            {\pgfkeysvalueof{/mt/titlepage/thesis type/@formated}\\}
        }
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/legal identifier/text}}{}%
        }{%
            % if legal identifier text is empty
            {\pgfkeysvalueof{/mt/titlepage/legal identifier/@formated}
            \@mt@titlepage@legalIdentifier@text@GENERATE}
            \vfil
        }{%
            {\pgfkeysvalueof{/mt/titlepage/legal identifier/@formated}}
            \vfil
        }
        \ifthenelse{%
            \equal{\pgfkeysvalueof{titlepage/handed in by/text}}{}%
        }{%
            % no handed in by text is specified
            % nothing to do
        }{%
            {\pgfkeysvalueof{/mt/titlepage/handed in by/@formated}\\}%
        }
        
        % author formatted
        % TO DO: Needs to change font when main document font is snas serif
        \ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/thesis/author/place of birth}}{}
        }{%
            {\pgfkeysvalueof{/mt/titlepage/author/@formated}}%
        }{%
            { \pgfkeysvalueof{/mt/titlepage/author/@formated}\\[0.125cm]}%
        }%
        
        % place of birth formatted
        \ifthenelse{%
                \equal{\pgfkeysvalueof{/mt/thesis/author/place of birth}}{}
            }{
                % no place of birth specified
                % nothing to do
            }{%
                {\pgfkeys{/mt/titlepage/place of birth/@formated}}% peculiarity: setting line break here destroys \vfil(l) for author affiliations
            }%
		\ifthenelse{
            \equal{\pgfkeysvalueof{/mt/thesis/author/affiliations}}{}
        }{%
            % no author multiple affiliations specified
            \ifthenelse{%
                \equal{\pgfkeysvalueof{/mt/thesis/author/affiliation}}{}
            }{%
                % no single affiliation specified
                % nothing to do
            }{%
                % single author affiliation specified
                \pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/padding/vertical}
                \@mt@titlepage@affiliation@formated%
            }
        }{%
            % if author affiliations specified
            \pgfkeysvalueof{/mt/titlepage/author affiliations/listing style/padding/vertical}
            \@mt@titlepage@affiliations@formated%
        }
		\vfill
		\ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/date/text}}{}%
        }{%
            % if no title page date text specified
            % nothing to do
        }{%
            {\pgfkeysvalueof{/mt/titlepage/date/@formated}}%
        }
		\vfill
        % examination committe
        % TO-DO: Port this from minipage to table, so that the spacing is less ragged
        % ISSUE: pgfkey list expansion does not work inside of table
		\ifthenelse{%
            \equal{\pgfkeysvalueof{/mt/titlepage/examination committee/title/text}}{}%
        }{%
            % if no examination comittee title is specified
            % nothing to do
        }{%
            \setcounter{@mt@thesis@titlepage@reviewers@counter}{1}
            \begin{minipage}{\pgfkeysvalueof{/mt/titlepage/examination committee/width}}
                {\raggedright\pgfkeysvalueof{/mt/titlepage/examination committee/title/@formated}\\[\pgfkeysvalueof{/mt/titlepage/examination committee/title/padding/vertical}]}
                \ifthenelse{%
                    \equal{\pgfkeysvalueof{/mt/thesis/examiners/chairman}}{}%
                }{%
                    % if no chairman specified
                    % nothing to do
                }{%
                    {%
                        \raggedright%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/chairman/descriptor/font/family}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/chairman/descriptor/font/size}%
                        \@mt@titlepage@examinationCommittee@chairman@descriptor@font@weight%
                        \color{\pgfkeysvalueof{/mt/titlepage/examination committee/chairman/descriptor/font/color}}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/chairman/descriptor/text}%
                    }%
                    \hfill%
                    {%
                        \raggedleft%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/chairman/name/font/family}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/chairman/name/font/size}%
                        \@mt@titlepage@examinationCommittee@chairman@name@font@weight%
                        \color{\pgfkeysvalueof{/mt/titlepage/examination committee/chairman/name/font/color}}%
                        \pgfkeysvalueof{/mt/thesis/examiners/chairman}%
                    }%
                }%
                \ifthenelse{%
                    \equal{\pgfkeysvalueof{/mt/thesis/examiners/reviewers}}{}%
                }{%
                    % no reviewers specified
                    % nothing to do
                }{%
                    % \pgfkeysvalueof{/mt/titlepage/examination comitte/reviewers/@formated}
                    \@mt@titlepage@examinationCommittee@reviewers@formated%
                }%
                \ifthenelse{%
                    \equal{\pgfkeysvalueof{/mt/thesis/examiners/additional}}{}%
                }{%
                    % no additional reviewer specified
                    % nothing to do
                }{%
                   {%
                        \\%
                        \raggedright%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/descriptor/font/family}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/descriptor/font/size}%
                        \@mt@titlepage@examinationCommittee@additionalExaminer@descriptor@font@weight%
                        \color{\pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/descriptor/font/color}}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/descriptor/text}%
                    } 
                    \hfill 
                    {%
                        \raggedleft%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/name/font/family}%
                        \pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/name/font/size}%
                        \@mt@titlepage@examinationCommittee@additionalExaminer@name@font@weight%
                        \color{\pgfkeysvalueof{/mt/titlepage/examination committee/additional examiner/name/font/color}}%
                        \pgfkeysvalueof{/mt/thesis/examiners/additional}%
                    }
                }%
            \end{minipage}
     
        }
		\normalsize\normalfont % set font to document default to prevent any issues futher along
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

\AtEndPreamble{
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